#!/usr/bin/env bash
# Build CLIVORA Android release APK (and optionally AAB).
set -euo pipefail
export PATH="${FLUTTER_HOME:-/opt/flutter}/bin:${PATH}"
export ANDROID_HOME="${ANDROID_HOME:-/opt/android-sdk}"
cd "$(dirname "$0")"

VER=$(rg '^version:' pubspec.yaml | awk '{print $2}' | cut -d+ -f1)
mkdir -p releases

BUILD_AAB="${BUILD_AAB:-0}"

echo "Building APK..."
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk "releases/clivora-${VER}.apk"
echo "APK: releases/clivora-${VER}.apk"

if [[ "$BUILD_AAB" == "1" ]]; then
  echo "Building AAB..."
  flutter build appbundle --release
  cp build/app/outputs/bundle/release/app-release.aab "releases/clivora-${VER}.aab"
  echo "AAB: releases/clivora-${VER}.aab"
fi
