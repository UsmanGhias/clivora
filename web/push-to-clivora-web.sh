#!/usr/bin/env bash
# Push this web/ directory to github.com/UsmanGhias/clivora-web
# Prerequisite: create the empty repo on GitHub first (Settings or gh with repo scope).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
TMP="${TMPDIR:-/tmp}/clivora-web-push-$$"
rm -rf "$TMP"
mkdir -p "$TMP"
rsync -a --exclude node_modules --exclude .next "$ROOT/" "$TMP/"
cd "$TMP"
git init -b main
git add .
git commit -m "CLIVORA web admin v2.6.6 — admin dashboard, reset password, sync API"
git remote add origin "https://github.com/UsmanGhias/clivora-web.git"
git push -u origin main
echo "Pushed to https://github.com/UsmanGhias/clivora-web"
