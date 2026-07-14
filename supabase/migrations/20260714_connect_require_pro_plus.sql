-- PR-03: Connect write RPCs must require Pro Plus (or admin) — SECURITY DEFINER previously bypassed table RLS.

create or replace function public.connect_require_pro_plus()
returns void
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'AUTH_REQUIRED';
  end if;
  if public.is_admin() or public.is_pro_plus() then
    return;
  end if;
  raise exception 'PRO_PLUS_REQUIRED';
end;
$$;

revoke all on function public.connect_require_pro_plus() from public;
grant execute on function public.connect_require_pro_plus() to authenticated;

create or replace function public.connect_spend_credits(
  p_action text, p_related_type text default null, p_related_id uuid default null,
  p_idempotency_key text default null)
returns integer
language plpgsql security definer set search_path = public
as $$
declare
  v_cost integer := case p_action
    when 'proposal' then 1 when 'contact' then 1
    when 'publish_need' then 3 when 'publish_profile' then 3 else 0 end;
  v_account public.connect_credit_accounts;
  v_key text := coalesce(nullif(p_idempotency_key, ''), gen_random_uuid()::text);
begin
  perform public.connect_require_pro_plus();
  if v_cost = 0 then raise exception 'ACTION_NOT_ALLOWED'; end if;
  if not public.connect_credit_eligible(auth.uid()) then raise exception 'PROFILE_INCOMPLETE'; end if;
  perform public.connect_prepare_credit_account(auth.uid());
  if exists (select 1 from public.connect_credit_ledger where user_id = auth.uid() and idempotency_key = v_key) then
    return v_cost;
  end if;
  select * into v_account from public.connect_credit_accounts where user_id = auth.uid() for update;
  if not v_account.legacy_unlimited and v_account.balance < v_cost then raise exception 'INSUFFICIENT_CREDITS'; end if;
  insert into public.connect_credit_ledger(user_id, entry_type, action, amount, related_type, related_id, idempotency_key)
    values (auth.uid(), 'debit', p_action, case when v_account.legacy_unlimited then 0 else v_cost end,
      p_related_type, p_related_id, v_key);
  if not v_account.legacy_unlimited then
    update public.connect_credit_accounts set balance = balance - v_cost, updated_at = now()
      where user_id = auth.uid();
  end if;
  return v_cost;
end;
$$;

create or replace function public.connect_submit_proposal(
  p_to_user_id uuid, p_need_id uuid, p_amount numeric, p_currency text,
  p_timeline_days integer, p_message text)
returns uuid language plpgsql security definer set search_path = public
as $$
declare v_id uuid := gen_random_uuid();
begin
  perform public.connect_require_pro_plus();
  if p_to_user_id is null or p_to_user_id = auth.uid() then raise exception 'ACTION_NOT_ALLOWED'; end if;
  perform public.connect_spend_credits('proposal', 'connect_proposal', v_id, 'proposal:' || v_id::text);
  insert into public.connect_proposals
    (id, from_user_id, to_user_id, need_id, amount, currency, timeline_days, message, status)
  values (v_id, auth.uid(), p_to_user_id, p_need_id, coalesce(p_amount, 0), coalesce(nullif(p_currency, ''), 'USD'),
    p_timeline_days, coalesce(p_message, ''), 'pending');
  return v_id;
end;
$$;

create or replace function public.connect_send_request(
  p_to_user_id uuid, p_target_profile_id uuid, p_target_need_id uuid, p_message text)
returns uuid language plpgsql security definer set search_path = public
as $$
declare v_id uuid := gen_random_uuid();
begin
  perform public.connect_require_pro_plus();
  if p_to_user_id is null or p_to_user_id = auth.uid() then raise exception 'ACTION_NOT_ALLOWED'; end if;
  perform public.connect_spend_credits('contact', 'connect_request', v_id, 'contact:' || v_id::text);
  insert into public.connect_requests
    (id, from_user_id, to_user_id, target_profile_id, target_need_id, message, status)
  values (v_id, auth.uid(), p_to_user_id, p_target_profile_id, p_target_need_id, coalesce(p_message, ''), 'pending');
  return v_id;
end;
$$;

create or replace function public.connect_publish_need(
  p_title text, p_summary text, p_skills text[], p_budget_band text)
returns uuid language plpgsql security definer set search_path = public
as $$
declare v_id uuid := gen_random_uuid();
begin
  perform public.connect_require_pro_plus();
  if not exists (select 1 from public.profiles where id = auth.uid() and account_type in ('client', 'admin')) then raise exception 'ACTION_NOT_ALLOWED'; end if;
  perform public.connect_spend_credits('publish_need', 'connect_need', v_id, 'publish_need:' || v_id::text);
  insert into public.connect_need_posts
    (id, client_user_id, title, summary, skills, budget_band, is_open, moderation_status)
  values (v_id, auth.uid(), left(coalesce(p_title, ''), 200), coalesce(p_summary, ''), coalesce(p_skills, '{}'),
    left(coalesce(p_budget_band, ''), 120), true, 'pending');
  return v_id;
end;
$$;

create or replace function public.connect_publish_profile(
  p_headline text, p_bio text, p_skills text[], p_rate numeric)
returns uuid language plpgsql security definer set search_path = public
as $$
declare v_id uuid := auth.uid();
begin
  perform public.connect_require_pro_plus();
  if v_id is null or not exists (select 1 from public.profiles where id = v_id and account_type = 'freelancer') then
    raise exception 'ACTION_NOT_ALLOWED';
  end if;
  perform public.connect_spend_credits('publish_profile', 'connect_profile', v_id, 'publish_profile:' || v_id::text);
  insert into public.connect_profiles (user_id, display_title, headline, bio, skills, rate_band, is_listed)
    values (v_id, left(coalesce(p_headline, ''), 200), left(coalesce(p_headline, ''), 200), coalesce(p_bio, ''), coalesce(p_skills, '{}'),
      left(coalesce(p_rate, 0)::text, 80), true)
  on conflict (user_id) do update set headline = excluded.headline, bio = excluded.bio,
    skills = excluded.skills, rate_band = excluded.rate_band, is_listed = true, updated_at = now();
  return v_id;
end;
$$;
