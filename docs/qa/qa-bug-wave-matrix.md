# QA Bug Wave — verification matrix

Status: implemented on `cursor/pro-plus-web-v2-7-1-d928` (APK remains **3.8.1+81** until this matrix is signed off).

| # | Bug | Fix surface | Verify |
|---|-----|-------------|--------|
| 1 | Client add-freelancer / link request errors | `client_invite_freelancer` RPC + `FreelancerLinkService` | Client Account → Link freelancer with a real email → success, freelancer gets invite notification |
| 2 | Mobile Apply used Contact not proposal | Connect Apply → `submitProposal` | Freelancer Open jobs → Apply → amount + note → proposal appears for client |
| 3 | Client close posted jobs (mobile) | Connect **My jobs** + `closeNeedPost` | Client posts job → My jobs → Close → disappears from open marketplace |
| 4 | Invoice not fullscreen; paid sync | Fullscreen `ClientInvoiceDetailScreen` + reconcile | Client marks paid → freelancer Paid / unconfirmed stream updates |
| 5 | Hub Command Centre pills dead; cramped `go` | Wired Pay/Review/Reply + `push` | Hub pills navigate; system back returns to Hub |
| 6 | Contracts merge/signed/read-only/web missing | Merge prefers signed; locked banner; `/app/contracts` | Propose → list updates; sign → read-only both sides; web Contracts nav works |
| 7 | Notifications duplicate on login | Push bootstrap skip + badge excludes `kind=message` | Login with unread history → no flood of local alerts |
| 8 | Go-back broken | `AppShell` pops stack before exit dialog | Open Hub → Contracts → Android back → Hub (not exit) |
| 9 | Web messages new chat per message | Peer-thread grouping in `MessagesThreadView` | Multiple messages with same peer → one conversation |
| 10 | Started working → in_progress | `project_time_service.start` | Start timer on not_started project → status becomes in_progress + CRM push |
| 11 | Time mobile → web; hourly earnings | `pushTimeEntry` + LiveTimer rate/project | Stop timer on mobile → row in web Timesheets; earnings use hourly_rate |
| 12 | Hourly vs fixed | Project form pricing type + CRM sync | Create hourly project → web/mobile show pricing_type |
| 13 | Team broken | Web project-required invite + Accept/Decline | Invite with project → peer Accept → status accepted |
| 14 | Block/unblock | `chat_blocks` RLS + web Block button | Block peer in Messages → cannot message; Unblock restores |
| 15 | Tasks web read-only | `TasksClient` status actions + nav | Freelancer updates task status on `/app/tasks` |
| 16 | Dashboard Recent Activity | Removed from freelancer/client dashboards; analytics collapsible | Dashboard earnings expanded; Analytics activity collapses |
| 17 | Profile image inconsistency | Mobile upload → `profiles.avatar_url` | Change photo on mobile → appears on web account |
| 18 | Client top nav / account | Contracts/Tasks/Alerts nav; profileHref `/app/account` | Client sidebar + mobile Alerts; avatar opens Account |
| 19 | Connect client parity | Talent / My jobs / Inbox | Client Connect tabs match manage flow |
| 20 | Reviews settings dead link | Reviews page settings section | Review Settings no longer dead-ends |

## SQL applied remotely
- `client_invite_freelancer` + `require_message_link` bypass flag
- `chat_blocks` RLS policies
- `crm_time_entries (owner_uid, local_id)` unique index

## Out of scope this wave / follow-ups
- Full Connect mobile visual redesign polish beyond My jobs + Apply
- Deep project detail route `/app/projects/[id]` (list + CRM sync improved; detail page still thin)
- APK version bump (hold at 3.8.1+81 until QA sign-off)
