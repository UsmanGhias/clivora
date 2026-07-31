-- Audit P0 (2026-07-31): payment insert, search_path, duplicate index, storage listing, admin secret EXECUTE.
-- Apply ONLY after web API/checkout changes are deployed. Do not apply via MCP to production without an explicit gate.
-- Staging Hostinger currently shares production Supabase until a dedicated branch exists.

-- ---------------------------------------------------------------------------
-- 1) Payment requests: remove unrestricted anon/authenticated INSERT
-- ---------------------------------------------------------------------------
drop policy if exists pro_payment_requests_insert_anon on public.pro_payment_requests;
-- Inserts are service-role only (Safepay checkout, /api/pro/payment-requests, admin tools).
-- Keep existing admin select/update policies.

-- ---------------------------------------------------------------------------
-- 2) Mutable search_path on trigger helpers
-- ---------------------------------------------------------------------------
alter function public.crm_reject_stale_update() set search_path = public;
alter function public.crm_invoice_payment_status() set search_path = public;
alter function public.invoice_shares_sync_total_minor() set search_path = public;

-- ---------------------------------------------------------------------------
-- 3) Duplicate idempotency unique indexes (identical definitions)
-- ---------------------------------------------------------------------------
drop index if exists public.automation_webhook_queue_idem_uidx;
-- keep public.automation_webhook_queue_idempotency_key_uidx

-- ---------------------------------------------------------------------------
-- 4) Storage: keep buckets public for CDN URLs; stop broad API listing
-- ---------------------------------------------------------------------------
drop policy if exists avatars_public_select on storage.objects;
drop policy if exists portfolio_thumbs_public_select on storage.objects;

drop policy if exists avatars_owner_select on storage.objects;
create policy avatars_owner_select
  on storage.objects
  for select
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (auth.uid())::text
  );

drop policy if exists portfolio_thumbs_owner_select on storage.objects;
create policy portfolio_thumbs_owner_select
  on storage.objects
  for select
  to authenticated
  using (
    bucket_id = 'portfolio-thumbs'
    and (storage.foldername(name))[1] = (auth.uid())::text
  );

-- ---------------------------------------------------------------------------
-- 5) Narrow EXECUTE on admin secret RPCs (callers must use service-role table access)
-- ---------------------------------------------------------------------------
revoke all on function public.admin_get_integration_secret(text) from public, anon, authenticated;
revoke all on function public.admin_upsert_integration_secret(text, text) from public, anon, authenticated;

-- Dashboard summary: drop anonymous execute; keep authenticated (function must enforce is_admin)
revoke all on function public.admin_dashboard_summary() from public, anon;
grant execute on function public.admin_dashboard_summary() to authenticated;
