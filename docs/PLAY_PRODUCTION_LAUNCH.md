# Play production launch checklist (CLIVORA 4.2.10)

Direct **Production** track launch — **do not** create Open testing / Closed testing tracks unless you want them later.

## Build / signing (repo)

- [x] Version `4.2.10+111`
- [x] Signed with Play **upload** key (`SHA1 96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36`)
- [x] Native Google Sign-In
- [x] In-app upgrades use **Google Play Billing** only (no web checkout deep-link from APK)
- [x] In-app account deletion
- [x] Privacy / Terms in app + `https://clivora.codcrafters.org/privacy`
- [x] Connect auto-approve on publish (admin settings default ON)
- [x] Hub pending-sync banner removed (conflicts/failures only in shell)

## Cloud AI / CI build (APK + AAB)

```bash
git clone git@github.com:UsmanGhias/clivora.git && cd clivora
git checkout main && git pull
# Needs upload keystore: android/clivora-upload-keystore.jks + android/key.properties
# OR env: ANDROID_KEYSTORE_BASE64, ANDROID_STORE_PASSWORD, ANDROID_KEY_PASSWORD, ANDROID_KEY_ALIAS
bash build-android.sh
# Expect: releases/clivora-4.2.10.apk + releases/clivora-4.2.10.aab
```

Full detail: [`docs/releases/CLOUD_BUILD.md`](releases/CLOUD_BUILD.md)

## Play Console — Production only (owner)

1. **Monetise → Subscriptions** — create/activate all four product IDs (see `docs/GOOGLE_PLAY_BILLING_SETUP.md`):
   - `clivora_pro_freelancer_monthly`
   - `clivora_pro_client_monthly`
   - `clivora_pro_plus_freelancer_monthly`
   - `clivora_pro_plus_client_monthly`
2. Supabase secret `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` set for `verify-play-purchase`
3. **Test and release → Production → Create new release**
4. Upload **`releases/clivora-4.2.10.aab`** (not APK)
5. Release notes from `play-store/listing/PLAY_STORE_LISTING.md`
6. Confirm App content: privacy, Data safety, 18+, Ads = No
7. Countries / pricing
8. **Start rollout to Production** at 100% (or staged % if you prefer) — **skip Open testing**
9. Wait for Google review → Production becomes **Active**

## Do not upload

- Preview/sideload AABs (wrong signing SHA)
- Older builds superseded by `4.2.10+111`

## Policy reminders

- Digital subscriptions in-app → Play Billing only
- Account deletion reachable without support email
- Honest Data safety declarations
- CAMERA only for profile/attachments

## Post-publish smoke

- [ ] Install from Play Production
- [ ] Email + Google Sign-In
- [ ] Freelancer home Work queue metrics fill the card evenly
- [ ] Hub tiles readable (no truncated titles); no orange “sync pending” strip
- [ ] Connect: publish listing → appears for other role (auto-approved)
- [ ] Upgrade → Play Billing sheet; Restore purchases
- [ ] Delete account flow
