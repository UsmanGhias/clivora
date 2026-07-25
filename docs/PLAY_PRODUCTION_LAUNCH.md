# Play production launch checklist (CLIVORA 5.3.8)

Direct **Production** track launch — **do not** create Open testing / Closed testing tracks unless you want them later.

## Build / signing (repo)

- [x] Version `5.3.8+538`
- [x] Signed with Play **upload** key (`SHA1 96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36`)
- [x] Native Google Sign-In
- [x] In-app upgrades use **Google Play Billing** only
- [x] Connect cloud session refresh before save/browse (fixes false “Sign in required”)
- [x] Hub restored to prior Command Center layout; pending-sync strip removed

## Cloud AI / CI build (APK + AAB)

```bash
git clone git@github.com:UsmanGhias/clivora.git && cd clivora
git checkout main && git pull
# Needs upload keystore: android/clivora-upload-keystore.jks + android/key.properties
# OR env: ANDROID_KEYSTORE_BASE64, ANDROID_STORE_PASSWORD, ANDROID_KEY_PASSWORD, ANDROID_KEY_ALIAS
bash build-android.sh
# Expect: releases/clivora-5.3.8.apk + releases/clivora-5.3.8.aab
# SHA-1: 96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36
```

## Play Console — Production only

1. Activate the 4 subscription product IDs (see `docs/GOOGLE_PLAY_BILLING_SETUP.md`)
2. Upload `releases/clivora-5.3.8.aab` to **Production** (skip Open testing)
3. Start rollout → wait for Google review → Active

## Post-install smoke

- Sign out + sign in again once (refreshes cloud JWT)
- Connect → Save listing (no Sign in required)
- Open jobs tab shows approved needs
- Hub looks like prior Command Center (2.35 tiles + descriptions)
