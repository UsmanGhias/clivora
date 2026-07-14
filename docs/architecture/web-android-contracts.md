# Web ↔ Android contracts

## Shared truths

- Auth: Supabase Auth  
- Profile / plan: `profiles` row for `auth.uid()`  
- Cloud CRM: `crm_*` tables  
- Connect: `connect_*` tables + RPCs  
- Messages: `client_messages` (and related)  

## Android offline

SQLite is a **cache/outbox**, not a second source of truth. Queue writes; sync after auth/connectivity; never silently discard newer cloud data.

## Wording

- Freelancer: **Post a need**  
- Client: **Post a job**  

## Deep links / public links

Preserve existing invoice share links, auth redirects, and Connect apply URLs when changing routes.
