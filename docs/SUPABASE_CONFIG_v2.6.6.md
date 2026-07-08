# Supabase configuration for CLIVORA v2.6.6

Apply these in the Supabase dashboard for project `jtzjwgovqczlccyeujhq`.

## Auth URL configuration

| Setting | Value |
|---------|--------|
| **Site URL** | `https://clivora.codcrafters.org` |
| **Redirect URLs** | `https://clivora.codcrafters.org/auth/reset-password` |
| | `https://clivora.codcrafters.org/**` |

Password reset emails must not use `http://localhost:3000`. The app sends `redirectTo: https://clivora.codcrafters.org/auth/reset-password` from `supabase_auth_helper.dart`.

## Edge Function secrets

Set on **Project Settings → Edge Functions → Secrets**:

```
RESEND_API_KEY=re_FWZnh89b_FWDyETLyrPNELR61ZgkdGu4v
RESEND_FROM=CLIVORA <onboarding@resend.dev>
```

Redeploy the function after updating secrets:

```bash
supabase functions deploy send-clivora-email --project-ref jtzjwgovqczlccyeujhq
```

## SQL migrations

Run in the SQL Editor (in order if not already applied):

- `supabase/migrations/014_team_invites.sql` — team invite accept/decline flow

## Data privacy

- RLS policies on `notifications`, `client_tasks`, `team_invites`, and `project_shares` restrict rows to owning users.
- Do not commit service role keys to the repo.
