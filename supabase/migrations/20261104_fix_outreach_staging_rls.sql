-- 20261104_fix_outreach_staging_rls.sql
-- Fix critical security advisory: rls_disabled_in_public
-- Formally enforce Row Level Security on public._outreach_freelancer_staging and public._outreach_client_staging
-- Revoke all direct anon & authenticated access so staging tables cannot be read, modified, or deleted publicly.

ALTER TABLE IF EXISTS public._outreach_freelancer_staging ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public._outreach_freelancer_staging FROM anon, authenticated;

ALTER TABLE IF EXISTS public._outreach_client_staging ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public._outreach_client_staging FROM anon, authenticated;
