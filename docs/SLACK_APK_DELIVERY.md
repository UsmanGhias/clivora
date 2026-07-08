# Slack APK delivery setup

Post CLIVORA test APKs to your CodCrafters Slack channel after each build.

## Channel

- Workspace: `codcrafters.slack.com`
- Channel ID: `C0BF7GQUP3R`

## One-time setup

1. Open [Slack API Apps](https://api.slack.com/apps) → **Create New App** (or reuse an existing bot).
2. Under **OAuth & Permissions**, add bot scopes:
   - `files:write`
   - `chat:write`
3. **Install to workspace** and copy the **Bot User OAuth Token** (`xoxb-...`).
4. In Slack, open channel `C0BF7GQUP3R` and run `/invite @YourBotName`.
5. In [Cursor Dashboard → Cloud Agents → Secrets](https://cursor.com/dashboard), add:
   - `SLACK_BOT_TOKEN` = `xoxb-...`
   - `SLACK_CHANNEL_ID` = `C0BF7GQUP3R` (optional; script defaults to this)

> **Note:** Cursor’s built-in Slack integration (`@cursor`) triggers agents and sends text summaries. It does **not** upload APK binaries. Use the bot token above for file upload.

## Upload after build

```bash
./build-android.sh
./scripts/slack_upload_apk.sh
```

Or specify a path:

```bash
./scripts/slack_upload_apk.sh releases/clivora-2.6.4.apk
```

## Troubleshooting

| Error | Fix |
|-------|-----|
| `not_authed` / `invalid_auth` | Check `SLACK_BOT_TOKEN` secret |
| `channel_not_found` | Invite bot to channel |
| `missing_scope` | Add `files:write` and reinstall app |
| `file_too_large` | Slack free tier limit is 1 GB; APK is ~82 MB |
