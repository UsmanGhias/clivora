#!/usr/bin/env bash
# Decrypt android/.signing/clivora-upload.export with CLIVORA_UPLOAD_KEY_PASSWORD,
# write android/clivora-upload-keystore.jks + key.properties, verify Play upload SHA1.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
python3 "$ROOT/scripts/import-play-upload-export.py" "$@"
echo "Next: BUILD_AAB=1 ./build-android.sh"
