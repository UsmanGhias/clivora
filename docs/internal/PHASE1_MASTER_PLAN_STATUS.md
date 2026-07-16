# CLIVORA — Phase 1–5 launch readiness status

**Date:** 16 July 2026  
**Branch:** `cursor/cloud-agent-1784230796340-n5s0o` (single combined PR)

| Phase | Status |
|-------|--------|
| 1 Drift sync outbox + conflicts + Sync Center | **Done** (schema v18, tests pass) |
| 2 Private storage buckets + inventory | **Done** (migration applied on Clivora) |
| 3 Truthful UI / dead metrics | **Done** (web) |
| 4 Calendar / contracts CTA | **Done** (minimal) |
| 5 Client needs-action home | **Done** |
| Stripe / pentest / funded escrow | Deferred |
| Signed AAB / APK in this cloud env | Blocked (no Android SDK) — build locally |

## Local Android release commands

```bash
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release
flutter build apk --release
```

## Web release

```bash
cd web && npm ci && npm run lint && npm run typecheck && npm run build
bash push-to-clivora-web.sh
```

WhatsApp brief: `docs/internal/WHATSAPP_DONE_LEFT_IDEA.md`  
Storage inventory: `docs/internal/STORAGE_BUCKET_INVENTORY.md`
