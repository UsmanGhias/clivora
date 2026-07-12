# Google Sign-In branding (CLIVORA)

When users tap **Sign in with Google** on the website, Google shows “Continue to …”.  
If that text is `jtzjwgovqczlccyeujhq.supabase.co`, it looks unprofessional. This is **not a database leak** — it is Google showing the OAuth redirect host. Fix it with Google Cloud branding (and optionally a Supabase custom auth domain).

The **Android app** uses native Google Sign-In and does **not** show the Supabase URL.

---

## Fix in Google Cloud (required — free)

1. Open [Google Search Console](https://search.google.com/search-console) and verify **`codcrafters.org`** (or `clivora.codcrafters.org`).
2. Open [Google Cloud Console → OAuth consent / Branding](https://console.cloud.google.com/auth/branding).
3. Set:
   - **App name:** `CLIVORA`
   - **User support email:** `iusmanghias@gmail.com`
   - **App logo:** CLIVORA logo (square, ≥120×120)
   - **Application home page:** `https://clivora.codcrafters.org`
   - **Privacy policy:** `https://clivora.codcrafters.org/privacy`
   - **Terms of service:** `https://clivora.codcrafters.org/terms`
   - **Authorized domains:** `codcrafters.org` and `supabase.co` (Supabase callback still needs this)
4. **Publish** the app (leave Testing only if you added test users).
5. Credentials → OAuth client (Web) → Authorized redirect URIs must include:

```
https://jtzjwgovqczlccyeujhq.supabase.co/auth/v1/callback
```

6. Paste the same Client ID / Secret into **Supabase → Authentication → Providers → Google**.

After publish + branding, Google shows **CLIVORA** instead of the raw project string for most users.

---

## Optional: Custom Auth Domain (best UX)

On Supabase Pro, add a custom domain such as `auth.clivora.codcrafters.org`.  
Then Google’s “Continue to …” can show your domain instead of `*.supabase.co`.

---

## Supabase Auth URLs (Dashboard)

| Setting | Value |
|---------|--------|
| Site URL | `https://clivora.codcrafters.org` |
| Redirect URLs | `https://clivora.codcrafters.org/**` |
| | `https://clivora.codcrafters.org/auth/callback` |
| | `https://clivora.codcrafters.org/auth/reset-password` |
| | `org.codcrafters.clivora://login-callback` (if used) |

Supabase MCP cannot edit Auth URL settings — set these in the Dashboard once.

---

## Security note

Showing `*.supabase.co` is a branding issue, not an open database. RLS still protects data. Users never receive your service role key from this screen.
