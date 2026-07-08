#!/usr/bin/env bash
# Prepare android/key.properties + keystore for Play upload signing.
# Supports Cursor Cloud secrets:
#   ANDROID_KEYSTORE_BASE64  — base64 of clivora-upload-keystore.jks
#   ANDROID_KEYSTORE_PASSWORD
#   ANDROID_KEY_ALIAS        — default clivora
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ANDROID_DIR="$ROOT/android"
KEYSTORE_PATH="$ANDROID_DIR/clivora-upload-keystore.jks"
KEY_PROPS="$ANDROID_DIR/key.properties"
EXPECTED_SHA1="96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36"

if [[ -n "${ANDROID_KEYSTORE_BASE64:-}" ]]; then
  echo "Decoding ANDROID_KEYSTORE_BASE64 → $KEYSTORE_PATH"
  echo "$ANDROID_KEYSTORE_BASE64" | base64 -d > "$KEYSTORE_PATH"
fi

if [[ -f "$KEYSTORE_PATH" && -n "${ANDROID_KEYSTORE_PASSWORD:-}" ]]; then
  cat > "$KEY_PROPS" <<EOF
storePassword=${ANDROID_KEYSTORE_PASSWORD}
keyPassword=${ANDROID_KEYSTORE_PASSWORD}
keyAlias=${ANDROID_KEY_ALIAS:-clivora}
storeFile=clivora-upload-keystore.jks
EOF
  echo "Wrote $KEY_PROPS"
fi

if [[ ! -f "$KEY_PROPS" || ! -f "$KEYSTORE_PATH" ]]; then
  echo ""
  echo "ERROR: Play upload keystore not configured."
  echo "Place android/clivora-upload-keystore.jks + android/key.properties"
  echo "OR set Cursor secrets: ANDROID_KEYSTORE_BASE64, ANDROID_KEYSTORE_PASSWORD"
  echo "Expected upload cert SHA1: $EXPECTED_SHA1"
  exit 1
fi

ACTUAL_SHA1=$(keytool -list -v -keystore "$KEYSTORE_PATH" \
  -alias "${ANDROID_KEY_ALIAS:-clivora}" \
  -storepass "${ANDROID_KEYSTORE_PASSWORD:-$(grep storePassword "$KEY_PROPS" | cut -d= -f2)}" 2>/dev/null \
  | awk -F': ' '/SHA1:/{print toupper($2); exit}')

if [[ "$ACTUAL_SHA1" != "$(echo "$EXPECTED_SHA1" | tr '[:lower:]' '[:upper:]')" ]]; then
  echo "ERROR: Keystore SHA1 mismatch."
  echo "  Expected: $EXPECTED_SHA1"
  echo "  Got:      ${ACTUAL_SHA1:-unknown}"
  exit 1
fi

echo "Upload keystore OK (SHA1 $ACTUAL_SHA1)"
