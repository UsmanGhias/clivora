#!/usr/bin/env bash
# Build signed CLIVORA Android APK and AAB. Release builds fail closed without the Play upload key.
set -euo pipefail

export PATH="${FLUTTER_HOME:-$HOME/flutter}/bin:${PATH}"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/android-sdk}"
cd "$(dirname "$0")"

VER_WITH_CODE=$(grep -E '^version:' pubspec.yaml | awk '{print $2}')
VER="${VER_WITH_CODE%%+*}"
CODE="${VER_WITH_CODE##*+}"
EXPECTED_SHA1="96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36"

if [[ "${SKIP_SIGNING_CHECK:-0}" == "1" ]]; then
  echo "Refusing unsigned release build. Use debug flutter commands for local development." >&2
  exit 2
fi

bash scripts/prepare-android-signing.sh
mkdir -p releases

echo "Building APK ${VER}+${CODE}..."
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk "releases/clivora-${VER}.apk"

echo "Building AAB ${VER}+${CODE}..."
flutter build appbundle --release
cp build/app/outputs/bundle/release/app-release.aab "releases/clivora-${VER}.aab"

APK="releases/clivora-${VER}.apk"
AAB="releases/clivora-${VER}.aab"
APKSIGNER="$(find "${ANDROID_HOME}/build-tools" -name apksigner -type f 2>/dev/null | sort -V | tail -1)"
if [[ -z "$APKSIGNER" ]]; then
  echo "Android apksigner was not found" >&2
  exit 1
fi

echo "Verifying APK certificate..."
APK_SHA1_RAW=$("$APKSIGNER" verify --print-certs "$APK" | awk -F': ' '/Signer #1 certificate SHA-1 digest:/{print toupper($2); exit}')
APK_SHA1=$(echo "${APK_SHA1_RAW:-}" | tr -d ':' | sed 's/../&:/g;s/:$//')
echo "APK signing SHA1: ${APK_SHA1:-unknown}"
if [[ "$APK_SHA1" != "$EXPECTED_SHA1" ]]; then
  echo "ERROR: APK is not signed with the Play upload key." >&2
  echo "  raw=$APK_SHA1_RAW" >&2
  exit 1
fi

echo "Verifying AAB certificate..."
AAB_SHA1=$(keytool -printcert -jarfile "$AAB" 2>/dev/null | awk -F': ' '/SHA1:/{print toupper($2); exit}')
echo "AAB signing SHA1: ${AAB_SHA1:-unknown}"
if [[ "$AAB_SHA1" != "$EXPECTED_SHA1" ]]; then
  echo "ERROR: AAB is not signed with the Play upload key." >&2
  exit 1
fi

sha256sum "$APK" "$AAB" > "releases/SHA256SUMS.txt"
echo "APK: $APK"
echo "AAB: $AAB"
echo "Checksums: releases/SHA256SUMS.txt"
