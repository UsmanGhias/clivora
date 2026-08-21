# CLIVORA Capstone presentation pack

Everything needed to record the Quantic MSSE Capstone presentation for CLIVORA.

| File | What it is |
|---|---|
| `CLIVORA-MSSE-Capstone.pptx` | The deck. 40 slides, 16:9, speaker notes embedded per slide. |
| `CLIVORA-MSSE-Capstone.pdf` | Same deck with fonts embedded. Present from this if Inter is not installed. |
| `SPEAKER_NOTES.md` | Runtime plan, the four sentences that earn the marks, condensed script. |
| `SOCIAL_MEDIA.md` | CLIVORA social guidelines. **Not** a Quantic deliverable. |
| `build_pptx.py` | Generates the deck. |
| `theme.py` | Design system: palette, type scale, layout grid, shape primitives. |
| `prep_visuals.py` | Builds `visuals/` from the source PDFs, zips and device screenshots. |
| `visuals/` | 34 deck-ready images (generated — safe to delete and rebuild). |
| `fonts/` | Inter and Inter Display TTFs. Install these so the PPTX matches the PDF. |

> The **presentation** you submit to Quantic is the video link, not this deck. See
> `../WHAT_TO_SUBMIT.md`.

## Rebuild

```bash
cd docs/capstone/presentation
python3 -m pip install --user python-pptx pillow   # once
python3 prep_visuals.py                            # rebuilds visuals/
python3 build_pptx.py                              # writes the PPTX

# optional: PDF + per-slide PNGs for review
soffice --headless --convert-to pdf --outdir preview CLIVORA-MSSE-Capstone.pptx
pdftoppm -r 92 -png preview/CLIVORA-MSSE-Capstone.pdf preview/s
```

`prep_visuals.py` reads from `~/Downloads` (the Upwork catalogue PDF, the marketing launch
kit zip, the Premium Campaign V2 zip) and from the Cursor asset cache for the raw Android
screenshots. If those sources move, update the paths at the top of that file.

## Design system

The palette is sampled directly from the CLIVORA Premium Campaign V2 artwork, so the deck,
the Play Store listing and the social creatives are one identity.

| Token | Value | Use |
|---|---|---|
| Ink / Navy | `#050F1E` → `#0D253E` | Slide background gradient |
| Surface | `#102B46` / `#16395B` | Cards and diagram nodes |
| Teal | `#28D2CB` | Primary accent, section 01 and 05 |
| Cyan | `#22D3EE` | Section 02 |
| Blue | `#3B82F6` | Section 03 |
| Violet | `#7162FC` | Section 04, client-side surfaces |
| Green / Amber / Rose | `#34D399` / `#FBBF24` / `#FB7185` | Passing, caution, warning |

Type is Inter for body copy and Inter Display for headings. Kickers are 10.5 pt letter-spaced
caps; slide titles are 26–31 pt; body copy is 10–13 pt.

## Deck structure

**Open (1–3)** — cover with real device screens · agenda · team, roles and the honest scope
statement separating baseline from the graded increment.

**01 · The problem (4–6)** — the four seams in independent work, the four constraints they
create, the three users, and why marketplaces, project tools, accounting apps and
spreadsheets each fail.

**02 · The product (7–17)** — module map showing five surfaces resolving to one Postgres
record · web workspace · the six-step daily loop · Connect's mutual accept and $0 fee · the
client as a first-class user · three triptychs of unretouched Android screenshots · the
on-device automation engine · one account across web and Android.

**03 · Engineering (18–27)** — three-tier architecture · transactional outbox for offline
sync including its failure path · the three-layer security model · six named design patterns
with rationale · money correctness via expand/contract · Ask AI as a retrieval-augmented
system with a human-in-the-loop gate · the test pyramid plus all eight suites and what each
proves · the CI and CD pipelines · deployment options with relative cost and a
recommendation.

**04 · Agile process (28–32)** — baseline versus the Capstone increment with evidence ·
sprint timeline from 20 August to 14 November 2026 · what each sprint planned, delivered and
demonstrated · the board and the definition of done.

**05 · Demo and close (33–37)** — the six-step hire-to-invoice loop and its honest caveats ·
results with the open risks stated plainly · which Quantic button takes what · close.

**Appendix (38–40, not presented)** — roadmap ranked by risk removed · the go-to-market
artefacts already produced · the pre-recording checklist.

## Every diagram is vector

Nothing in the engineering section is a screenshot of a diagram. The architecture tiers,
sync-outbox chain, security layers, expand/contract migration, RAG pipeline, test pyramid,
CI/CD flows, sprint gantt and demo loop are all drawn with PowerPoint shapes, so they stay
sharp at any zoom and can be edited directly.

## Sources feeding the deck

- **Real Android screenshots** — 15 unretouched device captures, given rounded corners, a
  teal→violet bezel and a soft glow by `prep_visuals.py`
- **Upwork project catalogue** — six web dashboard mockup pages
- **Premium Campaign V2** — five editorial creatives, used on the section dividers
- **Marketing launch kit** — Play Store screenshots and the feature graphic
