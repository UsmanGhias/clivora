#!/usr/bin/env bash
# Build CLIVORA Android release APK + AAB (Flutter not on default PATH here).
set -euo pipefail
export PATH="/home/usmanghias/flutter/bin:$PATH"
export ANDROID_HOME="${ANDROID_HOME:-/home/usmanghias/android-sdk}"
cd "$(dirname "$0")"

VER=$(rg '^version:' pubspec.yaml | awk '{print $2}' | cut -d+ -f1)
mkdir -p releases

echo "Building APK..."
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk "releases/clivora-${VER}.apk"
echo "APK: releases/clivora-${VER}.apk"

echo "Building AAB..."
flutter build appbundle --release
cp build/app/outputs/bundle/release/app-release.aab "releases/clivora-${VER}.aab"
echo "AAB: releases/clivora-${VER}.aab"
