#!/usr/bin/env bash
# Push this web/ directory to github.com/UsmanGhias/clivora-web
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
TMP="${TMPDIR:-/tmp}/clivora-web-push-$$"
rm -rf "$TMP"
mkdir -p "$TMP"
cp -a "$ROOT/." "$TMP/"
cd "$TMP"
git init -b main
git add .
git commit -m "CLIVORA web admin v2.6.6 — admin dashboard, reset password, sync API"
REMOTE="${CLIVORA_WEB_REMOTE:-https://github.com/UsmanGhias/clivora-web.git}"
git remote add origin "$REMOTE"
if ! git push -u origin main; then
  echo ""
  echo "Push failed. If using Cursor Cloud Agent, grant Cursor GitHub app access to UsmanGhias/clivora-web."
  echo "Or mirror from: git pull https://github.com/UsmanGhias/clivora clivora-web-sync"
  exit 1
fi
echo "Pushed to $REMOTE"
