# Plans and entitlements (canonical draft)

Status: **needs owner confirmation** — published materials currently conflict on Connect credits.

## Locked CRM free caps (verified product baseline)

| Cap | Free | Pro | Pro Plus |
| --- | --- | --- | --- |
| Clients | 3 | Unlimited | Unlimited |
| Projects | 5 | Unlimited | Unlimited |
| Invoices / month | 10 | Unlimited | Unlimited |

## Subscription source of truth

- Column: `profiles.subscription_plan`
- Values: `free` | `pro` | `pro_plus` (aliases may exist in UI helpers; normalize server-side)
- Web and Android **must** read the same field

## Connect (interim rule until credits reconciled)

Until a single credit table is approved:

- **Browse** Connect: available as documented for signed-in users (subject to blocked account rules)
- **Publish listing / post need or job / contact / proposals**: require **Pro Plus** + credit checks as enforced by current RPCs (`connect_publish_*`, `connect_send_request`, `connect_submit_proposal`)
- Contact emails stay private until mutual accept
- Freelancer: “Post a need” · Client: “Post a job”
- Freelancers: at most **one open need** at a time (web enforcement)

## Conflict to resolve (do not invent numbers)

Sources disagree on monthly Connect credit allowances (e.g. 5/30/100 vs 1–3 credit costs vs Pro Plus-only posting). Owner must pick one canonical policy; then update:

1. Supabase RPCs / credit tables  
2. Web `plan-gates` / Connect UI copy  
3. Android gates  
4. Public docs + release notes  

## Platform fee positioning

- CLIVORA Pro Plus monthly subscription fee is the platform charge (currently marketed ~$20/mo).
- Client→freelancer invoice amounts are intended to settle directly; off-platform solicitation to avoid fees is against policy.
