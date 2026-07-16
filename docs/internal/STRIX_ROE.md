# Strix Rules of Engagement (draft) — CLIVORA

**Owner:** Usman Ghias / CODCrafters  
**Product:** CLIVORA  
**Date:** 16 July 2026  

## Authorization

I authorize Strix (or equivalent security testing) against the targets listed below, which I own or operate.

## In scope (fill before production)

- [ ] Local: `http://127.0.0.1:3000` and Flutter debug builds  
- [ ] Staging / Vercel preview: `________________`  
- [ ] GitHub source: `https://github.com/UsmanGhias/clivora`  
- [ ] Production: `https://clivora.codcrafters.org` — **only after staging sign-off**

## Out of scope

- Third-party systems (Google Play, Supabase managed infra abuse, Stripe if dormant)  
- Denial-of-service / load testing that harms availability  
- Social engineering of staff or customers  
- Accessing real end-user PII beyond dedicated test accounts  

## Test accounts (create dedicated ones)

| Role | Email | Notes |
|------|-------|-------|
| Freelancer Free | | |
| Freelancer Pro Plus | | |
| Client | | |
| Admin + MFA | | |

## Success criteria

Validated findings with reproduction steps; remediations prioritized P0 → P1; retest after fixes.

## Sign-off

Owner signature / date: ________________
