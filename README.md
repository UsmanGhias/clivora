<div align="center">
  <img src="assets/images/clivora_logo.png" alt="CLIVORA logo" width="112" />
  <h1>CLIVORA</h1>
  <p><strong>The open-source Freelancer OS for independent professionals, agencies, and clients.</strong></p>
  <p>Discover opportunities, manage client relationships, track projects, issue invoices, and synchronize operations across mobile and web.</p>

  [![Website](https://img.shields.io/badge/Website-clivora.io-0F172A.svg?logo=googlechrome&logoColor=white)](https://clivora.io)
  [![Google Play](https://img.shields.io/badge/Google_Play-v5.6.2-34A853.svg?logo=googleplay&logoColor=white)](https://play.google.com/store/apps/details?id=org.codcrafters.clivora)
  [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22843765.svg)](https://doi.org/10.5281/zenodo.22843765)
  [![Downloads](https://img.shields.io/badge/Downloads-100%2B-2563EB.svg?logo=android&logoColor=white)](https://clivora.io/download)
  [![Views](https://img.shields.io/badge/Views-100%2B-0284C7.svg)](https://clivora.io)
  [![GitHub Stars](https://img.shields.io/github/stars/UsmanGhias/clivora?style=flat&logo=github&color=0F766E)](https://github.com/UsmanGhias/clivora/stargazers)
  [![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-0F766E.svg)](LICENSE)
  [![Flutter](https://img.shields.io/badge/Flutter-Android_3.x-02569B.svg?logo=flutter)](https://flutter.dev)
  [![Next.js 15](https://img.shields.io/badge/Next.js-15-black.svg?logo=nextdotjs)](https://github.com/UsmanGhias/clivora-web)
  [![Supabase](https://img.shields.io/badge/Backend-Supabase_Postgres-3ECF8E.svg?logo=supabase)](https://supabase.com)

  <p>
    <a href="https://clivora.io">Official Website</a> &middot;
    <a href="https://clivora.io/app">Web App</a> &middot;
    <a href="https://play.google.com/store/apps/details?id=org.codcrafters.clivora">Google Play Store</a> &middot;
    <a href="https://clivora.io/download">Download Center</a> &middot;
    <a href="https://clivora.io/open-source">Open Source Hub</a> &middot;
    <a href="https://clivora.io/jobs">Remote Jobs (7,150+)</a> &middot;
    <a href="https://clivora.io/docs">Documentation</a> &middot;
    <a href="https://github.com/UsmanGhias/clivora-web">Web Repository</a>
  </p>
</div>

## Platform Traction and Community Metrics

| Metric | Verified Metric / Status | Source and Direct Links |
|---|---|---|
| **Downloads & Package Installs** | **100+** | [Google Play Store](https://play.google.com/store/apps/details?id=org.codcrafters.clivora) &amp; [Verified APK/AAB Builds](https://clivora.io/download) |
| **Community Views & Visitors** | **100+** | [Official Portal (clivora.io)](https://clivora.io) &amp; [Open Source Hub](https://clivora.io/open-source) |
| **GitHub Stars** | **★ 1+** (Growing) | [Star on GitHub](https://github.com/UsmanGhias/clivora/stargazers) |
| **Zenodo DOI Research Archive** | `10.5281/zenodo.22843765` | [Permanent Scientific Archive](https://doi.org/10.5281/zenodo.22843765) |
| **Deal Platform Fee** | **$0 (0% cut)** | Direct client-to-freelancer payments |
| **Indexed Tech Jobs** | **7,150+ listings** | [Remote Jobs Harvester](https://clivora.io/jobs) |

## Direct Platform Connections

Access live CLIVORA environments directly:

- **Official Web Portal**: [clivora.io](https://clivora.io)
- **Web Application**: [clivora.io/app](https://clivora.io/app)
- **Google Play Store Listing**: [CLIVORA on Google Play](https://play.google.com/store/apps/details?id=org.codcrafters.clivora)
- **Official Download Center**: [clivora.io/download](https://clivora.io/download)
- **Open Source Suite**: [clivora.io/open-source](https://clivora.io/open-source)
- **Remote Jobs Harvester**: [clivora.io/jobs](https://clivora.io/jobs)
- **Platform Documentation**: [clivora.io/docs](https://clivora.io/docs)

## Why CLIVORA exists

Independent professionals often navigate disjointed tools across client discovery, CRM, proposals, contracts, project delivery, time tracking, invoicing, and analytics. CLIVORA combines these workflows into a cohesive, open-source platform where users control their data.

- **Zero platform fees on direct work:** clients settle negotiated payments directly with freelancers.
- **Opportunities and daily operations:** unified discovery on CLIVORA Connect with full business management tools.
- **Privacy by default:** direct contact information remains private until mutual acceptance between parties.
- **Reliable offline synchronization:** mobile client persists state locally and synchronizes when connected.
- **Grounded AI assistance:** retrieval-augmented generation grounded in actual CRM data with strict human-in-the-loop review.
- **Multi-client parity:** unified data contracts between Flutter mobile and Next.js web clients.

## Architecture and repositories

The CLIVORA suite is organized across specialized repositories sharing unified PostgreSQL schemas and business contracts:

| Repository | Scope and role | Technology | Link |
|---|---|---|---|
| **CLIVORA Mobile** (this repo) | Mobile client, offline outbox engine, and local SQLite data store | Flutter, Dart, Drift | [UsmanGhias/clivora](https://github.com/UsmanGhias/clivora) |
| **CLIVORA Web** | Production web platform, authenticated dashboard, and public docs | Next.js 15, TypeScript, Tailwind | [UsmanGhias/clivora-web](https://github.com/UsmanGhias/clivora-web) |

### Core system modules

| Module | Core capabilities |
|---|---|
| **CLIVORA Connect** | Talent profiles, job listings, structured proposals, and direct mutual connections |
| **Business OS** | Contacts CRM, client workspaces, active projects, tasks, milestones, invoices, and expenses |
| **Productivity** | Time tracking, calendar scheduling, push notifications, and financial reports |
| **Collaboration** | Role-scoped team workspaces, authenticated messaging, and client portals |
| **Edge Sync Engine** | Offline-first Drift database, durable transactional outbox, and deterministic conflict resolution |
| **Data & Auth** | Supabase managed PostgreSQL, database triggers, Row Level Security, and encrypted file vault |

## Documentation and engineering specifications

Detailed system design and verification specifications:

- [System Architecture & Testing Specification](docs/architecture/DESIGN_AND_TESTING.md): details feature boundaries, transactional outbox design, RLS policies, and Vitest/Flutter test suites.
- [Security & Performance Audit](docs/audit/SECURITY_AUDIT_2026-08.md): comprehensive audit findings, RLS hardening, and catalog assertions.
- [Ask AI Evaluation Dataset](docs/ai/ASK_AI_EVAL.md): benchmark test cases verifying grounded answers and human-in-the-loop constraints.
- [Security Disclosure Policy](SECURITY.md): reporting protocol and vulnerability handling.

## Citation and research

CLIVORA's transactional outbox synchronization engine is documented in research archived on Zenodo:

```bibtex
@article{khan2026clivora,
  title={Durable Edge-Outbox Synchronization: Managing Relational Divergence in Intermittent Mobile Enterprise Workloads},
  author={Khan, Muhammad Usman},
  journal={Zenodo},
  year={2026},
  month={9},
  doi={10.5281/zenodo.22843765},
  url={https://doi.org/10.5281/zenodo.22843765}
}
```

If you reference CLIVORA or its synchronization architecture in academic or engineering work, please consult [CITATION.cff](CITATION.cff).

## Quick start

### Prerequisites

- Flutter SDK 3.x (compatible with Dart SDK constraints in [pubspec.yaml](pubspec.yaml))
- Android Studio or configured Android toolchain
- Supabase project for backend services

### Run locally

```bash
# Clone repository
git clone https://github.com/UsmanGhias/clivora.git
cd clivora

# Install dependencies and verify environment
flutter pub get
flutter analyze
flutter test

# Run application on connected device or emulator
flutter run
```

Never commit production credentials, keystores, or private signing keys. Copy `android/app/google-services.json.example` to `android/app/google-services.json` and provide your development credentials.

## Contributing

We welcome contributions from engineers, designers, and technical writers.

1. Review [CONTRIBUTING.md](CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
2. Open an issue before submitting large architectural changes.
3. Fork the repository and develop on a focused topic branch.
4. Verify all tests pass locally: `flutter analyze` and `flutter test`.
5. Open a pull request describing the change and testing evidence.

Key contribution areas include accessibility, localized translations, offline sync optimizations, integration testing, and documentation.

## Security

Report vulnerabilities responsibly to **contact@clivora.io** with subject `[SECURITY] CLIVORA` in accordance with [SECURITY.md](SECURITY.md). Do not submit security disclosures through public issues.

## License

Source code is released under the **GNU Affero General Public License v3.0 (AGPL-3.0)**. See [LICENSE](LICENSE) for terms.

Trademarks, product naming, and visual identity are governed separately under [TRADEMARKS.md](TRADEMARKS.md).

Curated and architected by [Usman Ghias](https://usmanghias.co.uk).
