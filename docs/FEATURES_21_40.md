# CLIVORA — Features 21–40 (research + this release)

Built on top of Connect / Hub / Play Billing work. Focus: Play policy, monetization UX, security, visual polish.

| # | Feature | Why | Status |
|---|---------|-----|--------|
| 21 | **Play Billing only in-app** | Play policy: digital subscriptions must use Play Billing; no in-app web checkout links | Implemented |
| 22 | **Pro Plus Play product IDs** | `clivora_pro_plus_*_monthly` for freelancer + client | Implemented |
| 23 | **In-app Pro purchase** | Upgrade screen buys Pro via Google Play | Implemented |
| 24 | **In-app Pro Plus purchase** | Upgrade screen buys Plus via Google Play | Implemented |
| 25 | **Cancel / manage subscription** | Opens Play subscriptions deep link | Implemented |
| 26 | **Restore purchases** | Re-sync Play entitlements | Implemented |
| 27 | **Verify maps to pro_plus** | Edge function sets `profiles.subscription_plan` from product id | Implemented |
| 28 | **Web /pro Play-safe copy** | Website checkout kept for marketing/admin; not linked from app | Implemented |
| 29 | **Hub title consistency** | Screen titled Hub (matches nav) | Implemented |
| 30 | **Remove duplicate Connect tile** | Single Connect hero on Hub | Implemented |
| 31 | **Connect inbox filters** | All / Pending / Accepted / Declined | Implemented |
| 32 | **Role-aware Connect tabs** | Talent / My needs vs Browse / Open needs | Implemented |
| 33 | **Salted local password hashes** | `v2:salt:hash` with legacy upgrade on login | Implemented |
| 34 | **Subscription status on Upgrade** | Shows renew/active until date | Implemented |
| 35 | **Play price display** | Live Play Catalog prices when products exist | Implemented |
| 36 | **Admin Pro Plus access** | Admins treated as Plus for Connect | Implemented (prior) |
| 37 | **Mutual accept → CRM client** | Add partner to workspace | Implemented (prior) |
| 38 | **Cloud backup reminder** | Hub nudge when overdue | Implemented (prior) |
| 39 | **Web Connect moderation** | Approve / verify / hide from admin | Implemented (prior) |
| 40 | **Solid navy Hub profile card** | Pre-2.6.7 look restored | Implemented (prior) |

## Play Console checklist (required for purchases to work)
Create these **subscription** products (monthly, auto-renewing) under `org.codcrafters.clivora`:

1. `clivora_pro_freelancer_monthly`
2. `clivora_pro_client_monthly`
3. `clivora_pro_plus_freelancer_monthly`
4. `clivora_pro_plus_client_monthly`

Until products exist in Play Console, the app shows a clear error instead of opening web checkout.

## Policy note
Google Play Payments policy requires Play Billing for digital in-app subscriptions on Play-distributed apps. External web payment links inside the app were removed. Website `/pro` remains for non-app / admin-assisted flows only.
