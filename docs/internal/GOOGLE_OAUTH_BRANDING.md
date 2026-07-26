# Google Sign-In branding (CLIVORA)

When users tap **Sign in with Google** on the website, Google shows “Continue to …”.  
If that text is `jtzjwgovqczlccyeujhq.supabase.co`, it looks unprofessional. This is **not a database leak** — it is Google showing the OAuth redirect host.

The **Android app** uses native Google Sign-In and does **not** show the Supabase URL.

---

## Fix in Google Cloud (required — free)

1. Open [Google Search Console](https://search.google.com/search-console) and verify **`clivora.io`**.
2. Open [Google Cloud Console → OAuth consent / Branding](https://console.cloud.google.com/auth/branding).
3. Set:
   - **App name:** `CLIVORA`
   - **User support email:** `contact@clivora.io`
   - **App logo:** CLIVORA logo (square, ≥120×120)
   - **Application home page:** `https://clivora.io`
   - **Privacy policy:** `https://clivora.io/privacy`
   - **Terms of service:** `https://clivora.io/terms`
   - **Authorized domains:** `clivora.io` and `supabase.co` (Supabase callback still needs `supabase.co`)
4. **Publish** the app (leave Testing only if you added test users).
5. Credentials → OAuth client (Web) → Authorized redirect URIs must include:

```
https://jtzjwgovqczlccyeujhq.supabase.co/auth/v1/callback
```

6. Paste the same Client ID / Secret into **Supabase → Authentication → Providers → Google**.

After publish + branding + domain verification, Google shows **CLIVORA** for most users. Until the brand is verified, Google may still show the technical host.

---

## Best UX: Custom Auth Domain (optional)

On Supabase (custom domains), add `auth.clivora.io` pointing at your project.  
Then Google’s “Continue to …” can show **auth.clivora.io** / your brand instead of `*.supabase.co`.

Also update Google OAuth redirect URI to the custom auth callback when enabled.

---

## Supabase Auth URLs (Dashboard)

| Setting | Value |
|---------|--------|
| Site URL | `https://clivora.io` |
| Redirect URLs | `https://clivora.io/**` |
| | `https://clivora.io/auth/callback` |
| | `https://clivora.io/auth/reset-password` |
| | `org.codcrafters.clivora://login-callback` (Android) |

Supabase MCP cannot edit Auth URL settings — set these in the Dashboard.

---

## Security note

Showing `*.supabase.co` is a branding issue, not an open database. RLS still protects data.
