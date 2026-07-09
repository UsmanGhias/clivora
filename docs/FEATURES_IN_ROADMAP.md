# CLIVORA CRM roadmap (Invoice Ninja–inspired, native)

Research source: Invoice Ninja v5 domain concepts (products, quotes, recurring, vendors, POs, credits, aging).  
Implementation: **native CLIVORA** Flutter + Drift + Supabase. No Invoice Ninja UI, assets, or code vendored.

| Module | CLIVORA routes / entry | Status |
|--------|------------------------|--------|
| Connect bottom tab (Pro Plus) | `/connect` in shell · badge on pending inbox | Done |
| Products / services catalog | `/products` · Hub · invoice form picker | Done |
| Quotes → invoice + PDF | `/quotes` · Share PDF · Convert | Done |
| Recurring invoices | `/recurring-invoices` · bootstrap + automation | Done |
| Vendors | `/vendors` | Done |
| Billable expenses | Expense form vendor + billable → Bill→Invoice | Done |
| Purchase orders (lite) | `/purchase-orders` | Done |
| Credits apply to invoice | `/credits` | Done |
| Partial payments | `/payments` + `InvoicePayments` | Done |
| Billable time/tasks → invoice | Hub “Bill → Invoice” | Done |
| Invoice aging on Billing | Invoice list aging buckets | Done |
| P&L, aging, tax, expense reports | `/reports` · CSV export | Done |
| 30-day revenue sparkline | Dashboard | Done |

## Nav (freelancer)

- Free/Pro: Home · Clients · Work · Billing · Hub  
- Pro Plus: Home · Clients · Connect · Billing · Hub (Work via Hub)

## Nav (client Pro Plus)

- Home · Messages · Connect · Invoices · Account
