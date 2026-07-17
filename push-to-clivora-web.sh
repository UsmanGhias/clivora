#!/usr/bin/env bash
# Push /workspace/web to UsmanGhias/clivora-web (Vercel production source).
# IMPORTANT: This replaces the remote tree with the monorepo web/ snapshot.
# Prefer a PR merge into clivora-web when collaborating on design-sensitive work.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
TMP="${TMPDIR:-/tmp}/clivora-web-push-$$"
rm -rf "$TMP"
mkdir -p "$TMP"
cp -a "$ROOT/." "$TMP/"
cd "$TMP"
rm -rf .git node_modules .next
git init -b main
git config user.name "UsmanGhias"
git config user.email "usmanghias1@gmail.com"
git add .
git commit -m "CLIVORA web: Freelancer OS responsive production polish"
REMOTE="${CLIVORA_WEB_REMOTE:-https://github.com/UsmanGhias/clivora-web.git}"
git remote add origin "$REMOTE"
if ! git push -u origin main --force; then
  echo "ERROR: push to clivora-web failed. Grant Cursor/GitHub access to UsmanGhias/clivora-web" >&2
  echo "or set CLIVORA_WEB_REMOTE / CLIVORA_WEB_SYNC_TOKEN with a working PAT." >&2
  exit 1
fi
echo "Pushed to $REMOTE"
