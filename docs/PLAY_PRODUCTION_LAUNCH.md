# Play production launch checklist (CLIVORA 4.2.3)

Use this before making the app available to everyone on Google Play.

## Build / signing (done in repo)

- [x] Version `4.2.3+104`
- [x] Signed with Play **upload** key (`SHA1 96:93:81:80:...`)
- [x] Hub / Command Center from `v3.9.6-playstore` (Work & collaboration first)
- [x] Connect icon `travel_explore` on client + freelancer Plus
- [x] Hub icon `Icons.hub`
- [x] Native Google Sign-In (no preview keystore)
- [x] In-app upgrades use **Google Play Billing** only
- [x] In-app account deletion (`Security & Privacy`)
- [x] Privacy / Terms routes in app + web URLs
- [x] `AD_ID` permission removed; camera/biometric marked optional

## Play Console (owner must complete)

1. **Create release** → upload `clivora-4.2.3.aab`
2. **App content**
   - Privacy policy URL: `https://clivora.codcrafters.org/privacy`
   - Data safety form (match `play-store/listing/PLAY_STORE_LISTING.md`)
   - Target audience: 18+ / not for children
   - Ads: No
3. **Store listing** — copy from `play-store/listing/PLAY_STORE_LISTING.md`
4. **Subscriptions** — ensure Pro / Pro Plus products exist and match `BillingService` product IDs
5. **App signing** — Play App Signing enabled; upload key matches SHA above
6. **Firebase** — Android app SHA-1 includes upload cert `96:93:81:80:...` (for Google Sign-In)
7. **Supabase Auth** — authorized redirect URLs include app deep links if used
8. **Countries / pricing** — set availability
9. **Pre-launch report** — review crashes / policy findings
10. **Rollout** — start with closed/open testing if desired, then production

## Do not upload

- Preview/sideload AABs (`7F:6B:CA:0D:...` signing)
- `v2.20`, `v2.21-preview`, `v4.1.7-sideload`, superseded `v4.2.1`

## Policy reminders

- Digital subscriptions sold in-app → Play Billing only (already wired)
- Account deletion must remain reachable without contacting support
- Declare all collected data honestly in Data safety
- No misleading “offline forever / bank-level” claims beyond what you deliver
- CAMERA only for profile/attachments; do not request unused SMS/call logs/location

## Post-publish smoke test

- [ ] Install from Play internal track
- [ ] Email + Google Sign-In
- [ ] Freelancer Home + Hub Command Center
- [ ] Connect tab icon looks correct
- [ ] Upgrade screen opens Play Billing
- [ ] Delete account flow completes
