#!/usr/bin/env bash
# Upload CLIVORA release APK to a Slack channel via Bot Token (files:write + chat:write).
set -euo pipefail

APK_PATH="${1:-}"
CHANNEL_ID="${SLACK_CHANNEL_ID:-C0BF7GQUP3R}"
TOKEN="${SLACK_BOT_TOKEN:-}"

if [[ -z "$TOKEN" ]]; then
  echo "ERROR: SLACK_BOT_TOKEN is not set."
  echo "Add it as a Cursor Cloud Agent secret, then re-run this script."
  exit 1
fi

if [[ -z "$APK_PATH" ]]; then
  VER=$(rg '^version:' pubspec.yaml | awk '{print $2}' | cut -d+ -f1)
  APK_PATH="releases/clivora-${VER}.apk"
fi

if [[ ! -f "$APK_PATH" ]]; then
  echo "ERROR: APK not found at $APK_PATH"
  exit 1
fi

FILENAME=$(basename "$APK_PATH")
FILESIZE=$(wc -c < "$APK_PATH" | tr -d ' ')
TITLE="CLIVORA test build — ${FILENAME}"
COMMENT="CLIVORA Android test APK for device QA. Install on device (allow unknown sources if sideloading). Reply in thread with issues."

echo "Requesting Slack upload URL for $FILENAME ($FILESIZE bytes)..."

UPLOAD_JSON=$(curl -fsS -X POST "https://slack.com/api/files.getUploadURLExternal" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "filename=$FILENAME" \
  --data-urlencode "length=$FILESIZE")

if ! echo "$UPLOAD_JSON" | rg -q '"ok":true'; then
  echo "ERROR: files.getUploadURLExternal failed:"
  echo "$UPLOAD_JSON"
  exit 1
fi

UPLOAD_URL=$(echo "$UPLOAD_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)['upload_url'])")
FILE_ID=$(echo "$UPLOAD_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)['file_id'])")

echo "Uploading binary to Slack..."
curl -fsS -X POST "$UPLOAD_URL" \
  -H "Content-Type: application/octet-stream" \
  --data-binary @"$APK_PATH" > /dev/null

echo "Completing upload to channel $CHANNEL_ID..."
COMPLETE_JSON=$(curl -fsS -X POST "https://slack.com/api/files.completeUploadExternal" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d "$(python3 - <<PY
import json
print(json.dumps({
  "files": [{"id": "$FILE_ID", "title": "$TITLE"}],
  "channel_id": "$CHANNEL_ID",
  "initial_comment": "$COMMENT",
}))
PY
)")

if ! echo "$COMPLETE_JSON" | rg -q '"ok":true'; then
  echo "ERROR: files.completeUploadExternal failed:"
  echo "$COMPLETE_JSON"
  exit 1
fi

echo "SUCCESS: APK posted to Slack channel $CHANNEL_ID"
