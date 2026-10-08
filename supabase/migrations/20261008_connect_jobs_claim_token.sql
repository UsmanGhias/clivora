-- Migration: 20261008_connect_jobs_claim_token.sql
-- Enables universal claim tokens and robust 1-click claim RPC for employer outreach

create or replace function public.connect_job_claim(p_token text)
returns jsonb language plpgsql security definer set search_path to 'public' as $fn$
declare
  v_job record;
  v_user_id uuid;
begin
  if p_token is null or length(trim(p_token)) = 0 then
    return jsonb_build_object('ok', false, 'error', 'invalid_token');
  end if;

  v_user_id := auth.uid();
  if v_user_id is null then
    return jsonb_build_object('ok', false, 'error', 'unauthenticated');
  end if;

  select * into v_job from public.connect_jobs
  where claim_token = trim(p_token)
  limit 1;

  if not found then
    return jsonb_build_object('ok', false, 'error', 'invalid_or_claimed');
  end if;

  -- Ensure the claiming user has client profile status
  update public.profiles
  set account_type = 'client', role = 'client'
  where id = v_user_id;

  insert into public.connect_profiles (user_id, account_type, display_title, moderation_status, is_listed, is_verified)
  values (v_user_id, 'client', coalesce(v_job.company_name, 'Hiring Partner'), 'approved', true, true)
  on conflict (user_id) do update
  set account_type = 'client',
      moderation_status = 'approved',
      updated_at = now();

  -- Transfer the job ownership to the claiming user
  update public.connect_jobs
  set claimed_by = v_user_id,
      posted_by = v_user_id,
      claim_token = null,
      updated_at = now()
  where id = v_job.id;

  return jsonb_build_object('ok', true, 'job_id', v_job.id, 'title', v_job.title);
end;
$fn$;

revoke all on function public.connect_job_claim(text) from public;
grant execute on function public.connect_job_claim(text) to authenticated;

-- Ensure all jobs have secure claim tokens
update public.connect_jobs
set claim_token = encode(gen_random_bytes(16), 'hex')
where claim_token is null;
