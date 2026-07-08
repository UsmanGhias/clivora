# CLIVORA v2.5–v2.6 Feature Roadmap

Based on the production readiness research report. **Test on Linux desktop** with `flutter run -d linux` (no APK needed for dev).

## v2.5.0 (done)

| Feature | Status |
|---------|--------|
| Onboarding screens (4 slides) | Done |
| Skeleton loading (dashboard) | Done |
| Offline status bar + connectivity sync | Done |
| Biometric lock (optional) | Done |
| Encrypted secure storage | Done |
| Local notifications (device alerts) | Done |
| Cached network images (chat) | Done |
| Security & Privacy settings | Done |
| Account deletion flow | Done |
| OSS licenses screen | Done |
| GitHub Actions CI (analyze + test) | Done |

## v2.6.0 (done — code)

| Feature | Status |
|---------|--------|
| Linux desktop target (`flutter create --platforms=linux`) | Done |
| Urdu/RTL localization (ARB + language picker) | Done |
| Coach marks on dashboard | Done |
| Task due local reminders (scheduled) | Done |
| Sync outbox on cloud writes when offline | Done |
| Lottie animation (onboarding + widget) | Done |
| Telemetry service (Firebase-ready on mobile; local on Linux) | Done |

## v2.7+ (next)

- Full app-wide Urdu strings (expand ARB coverage)
- Firebase Analytics + Crashlytics (wire when Play Console + google-services.json ready)
- Team collaboration v1
- Maps, barcode scan, Lottie empty states app-wide

See `deep-research-report.md` for the full 100-feature matrix.
