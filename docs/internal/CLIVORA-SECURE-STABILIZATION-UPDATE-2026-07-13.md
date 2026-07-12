# CLIVORA Secure Stabilization Update — 2026-07-13

## Completed in this release wave

- Replaced legacy admin passwords, shared sync keys, custom session tokens, and fallback credentials with Supabase Auth sessions.
- Added independent admin route protection, role checks, MFA/AAL2 enforcement for sensitive APIs, private no-store responses, and security headers.
- Retired the exposed admin sync endpoint and removed browser/URL credential paths.
- Hardened Stripe checkout/webhook behavior, Play purchase verification, push targeting, and reminder authorization to fail closed.
- Added Node 24 and Flutter 3.44 CI foundations, web mirror synchronization, and tag-driven signed Android release automation.
- Updated Android release version to `2.17.0+74`; release builds now fail when signing material is missing.
- Added monthly Connect Credits with Free 5, Pro 30, Pro Plus 100 allowances, 90-day Pro Plus grandfathering, idempotent ledger entries, refunds for moderated failures, and transactional RPC contracts.
- Added client/freelancer/admin summary RPCs and authenticated product-event recording.

## Validation status

- Android signing material is present locally and the release build has been started using the configured keystore.
- `git diff --check` passes.
- Full web build, Playwright, Lighthouse, Supabase migration replay, and GitHub release validation must run in CI because the local checkout does not contain Node/Supabase CLI production services.

## Recommended next research

1. Run the staging migration against an empty Supabase project and compare every production table, function, index, policy, and storage rule.
2. Add automated RLS role-matrix tests for anonymous, owner, participant, moderator, and administrator sessions.
3. Measure Connect funnel conversion and credit exhaustion with non-PII events before changing allowances or pricing.
4. Profile web LCP/INP and Android cold start on low-end devices before adding marketplace search depth.
5. Review Stripe Connect compliance and escrow requirements separately before enabling any money-moving flow.
6. Add end-to-end tests for parallel credit spending, idempotency, refunds, upgrades, downgrades, and grandfather expiry.

## Operational follow-up

After CI succeeds, create the exact tag `v2.17.0-playstore` on merged `main`. The workflow will publish APK, AAB, and `SHA256SUMS.txt` as immutable GitHub Release assets.
