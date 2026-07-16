# Storage bucket inventory (Clivora production)

**Project:** `jtzjwgovqczlccyeujhq`  
**Migration:** `20260716_p0_private_storage_buckets` (+ prior `p0_chat_storage_owner_only`)

| Bucket | Visibility | Notes |
|--------|------------|-------|
| avatars | Public read | Owner-folder write |
| portfolio-thumbs | Public read | Owner-folder write |
| portfolio-files | **Private** | Owner-folder only |
| chat-attachments | **Private** | Owner-folder only (prior migration) |
| contracts | **Private** | Owner-folder only |
| invoice-docs | **Private** | Owner-folder only |
| project-files | **Private** | Owner-folder only |
| dispute-evidence | **Private** | Owner-folder only |
| identity-docs | **Private** | Strictly private, owner-folder |
| support-attachments | **Private** | Owner-folder only |
| temp-exports | **Private** | Owner-folder only |

## Still needed (post-RC)

- Relationship-based SELECT (client can read files shared via project/invoice/chat)
- Short-lived signed URL helpers everywhere (chat already 1h)
- MIME magic-byte verification at upload edge
- Access revoke on team member removal
- Negative cross-user tests
