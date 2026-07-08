#!/usr/bin/env bash
# Build CLIVORA Android release APK (and optionally AAB) with Play upload signing.
set -euo pipefail
export PATH="${FLUTTER_HOME:-$HOME/flutter}/bin:${PATH}"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/android-sdk}"
cd "$(dirname "$0")"

VER=$(rg '^version:' pubspec.yaml | awk '{print $2}' | cut -d+ -f1)
mkdir -p releases
BUILD_AAB="${BUILD_AAB:-0}"
EXPECTED_SHA1="96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36"

if [[ "${SKIP_SIGNING_CHECK:-0}" != "1" ]]; then
  bash scripts/prepare-android-signing.sh
fi

echo "Building APK..."
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk "releases/clivora-${VER}.apk"
echo "APK: releases/clivora-${VER}.apk"

if [[ "$BUILD_AAB" == "1" ]]; then
  echo "Building AAB..."
  flutter build appbundle --release
  cp build/app/outputs/bundle/release/app-release.aab "releases/clivora-${VER}.aab"
  echo "AAB: releases/clivora-${VER}.aab"

  AAB_SHA1=$(keytool -printcert -jarfile "releases/clivora-${VER}.aab" 2>/dev/null | awk -F': ' '/SHA1:/{print toupper($2); exit}')
  echo "AAB signing SHA1: ${AAB_SHA1:-unknown}"
  if [[ "$AAB_SHA1" != "$(echo "$EXPECTED_SHA1" | tr '[:lower:]' '[:upper:]')" ]]; then
    echo "ERROR: AAB not signed with Play upload key. Upload will be rejected."
    exit 1
  fi
  echo "Play upload signing verified."
fi
