#!/usr/bin/env python3
"""Build the CLIVORA Quantic MSSE Capstone speaker deck.

    python3 prep_visuals.py     # once, to build ./visuals
    python3 build_pptx.py       # writes CLIVORA-MSSE-Capstone.pptx

40 slides, 16:9, dark premium theme sampled from CLIVORA Premium Campaign V2.
Every claim maps to something in docs/capstone/ or the live product. Speaker
notes carry the script and the pacing target for each slide.
"""
from __future__ import annotations

from pathlib import Path

from pptx import Presentation
from pptx.enum.text import MSO_ANCHOR, PP_ALIGN
from pptx.util import Inches, Pt

from theme import (  # noqa: F401
    ACCENTS, AMBER, BLUE, CW, CYAN, DIM, DISPLAY, GREEN, INK, LINE, M, MUTE,
    NAVY, NAVY2, ROSE, SH, SURF, SURF2, SW, TEAL, VIOLET, WHITE, Y_BODY,
    Y_BODY_END, Y_FOOTER, Y_KICKER, Y_LEDE, Y_TITLE, accent_rule, alpha,
    arrow_d, arrow_r, background, brandbar, bullets, card, flow, footer,
    V, framed_pic, glow, gradient, kicker, kv_rows, lede, node, notes, oval,
    pic_h, pic_w, pill, rail_label, rect, round_rect, solid, stat, text, title,
)

OUT = Path(__file__).resolve().parent / "CLIVORA-MSSE-Capstone.pptx"
TOTAL = 40

LIVE = "clivora.io"
REPO = "github.com/UsmanGhias/clivora"


# ------------------------------------------------------------------ frame ----

class Deck:
    def __init__(self):
        self.prs = Presentation()
        self.prs.slide_width = Inches(SW)
        self.prs.slide_height = Inches(SH)
        self.n = 0

    def blank(self):
        return self.prs.slides.add_slide(self.prs.slide_layouts[6])

    def page(self, chrome=True, art=None):
        """Standard content slide: background, brand bar, footer."""
        self.n += 1
        s = self.blank()
        background(s)
        if chrome:
            brandbar(s, self.n, TOTAL)
            footer(s, f"CLIVORA · Quantic MSSE Capstone · {LIVE}", REPO)
        return s

    def bare(self):
        self.n += 1
        s = self.blank()
        background(s)
        return s

    def save(self):
        self.prs.save(OUT)
        return OUT


D = Deck()


def head(s, kick, head_line, sub=None, kcolor=TEAL, tsize=31):
    kicker(s, kick, kcolor, y=1.02)
    title(s, head_line, size=tsize, y=1.32)
    if sub:
        lede(s, sub, y=Y_LEDE + 0.58)


BODY_TOP = 2.72


# --------------------------------------------------------------- 01 cover ----

def s01_cover():
    s = D.bare()
    glow(s, 10.6, 2.0, 8.0, TEAL, 0.88)
    glow(s, 12.4, 6.6, 6.0, VIOLET, 0.88)

    pic_h(s, "app-client-portal.png", 9.35, 1.55, 5.35, rot=7)
    pic_h(s, "app-freelancer-home.png", 7.05, 0.95, 6.15, rot=-7)

    s.shapes.add_picture(V("clivora_logo_on_dark.png"), Inches(M), Inches(0.62),
                         height=Inches(0.44))
    kicker(s, "Quantic MSSE · Capstone presentation", TEAL, y=1.56)
    title(s, "Freelance work.\nOne connected\nsystem.", size=46, y=1.90, w=7.0)
    accent_rule(s, M, 4.34, 1.35, 0.06)
    text(s, M, 4.62, 6.3, 0.98,
         "The AI-assisted operating system where independent professionals\n"
         "find work, run the delivery and get paid — in one place.\n"
         "Solo Capstone · three sprints · web and Android, one shared record.",
         size=12.5, color=DIM, spacing=1.36)

    for i, (label, col) in enumerate([
        ("Web · live at clivora.io", TEAL), ("Android · Google Play", CYAN),
    ]):
        pill(s, M + i * 3.06, 5.86, 2.90, 0.36, label, WHITE, SURF2, col, size=8.5)

    hr = rect(s, M, 6.48, 6.3, 0.012, LINE)
    alpha(hr, 0.5)
    text(s, M, 6.64, 6.4, 0.62,
         "Usman Ghias — Product Owner, Scrum Master and sole engineer · CODCrafters\n"
         f"{REPO}",
         size=10, color=MUTE, spacing=1.30)

    notes(s, """
[0:00–1:00] Photo ID to camera now, then say your full name and programme.
"My name is Usman Ghias. This is my Quantic MSSE Capstone presentation for CLIVORA,
the freelance operating system. The web app is live at clivora.io and the Android app
is on Google Play. I am the sole engineer, and I acted as Product Owner and Scrum
Master across three sprints."
Hold the ID up for a full five seconds. Do not skip this — it is a grading requirement.
""")


# -------------------------------------------------------------- 02 agenda ----

def s02_agenda():
    s = D.page()
    head(s, "How this session runs", "Agenda",
         "Product first, then the engineering behind it, then the agile record, then a live demo.")

    items = [
        ("01", "The problem", "Why independent work fragments across tools", TEAL),
        ("02", "The product", "Web and Android walkthrough with real screens", CYAN),
        ("03", "Engineering", "Architecture, patterns, security, AI, tests, CI/CD", BLUE),
        ("04", "Agile process", "Baseline vs Capstone, three sprints, the board", VIOLET),
        ("05", "Live demo", "Job → accept → project → invoice → paid", TEAL),
        ("06", "Close", "Results, submission links, next roadmap", CYAN),
    ]
    cw = (CW - 2 * 0.34) / 3
    for i, (num, name, sub, col) in enumerate(items):
        col_i, row_i = i % 3, i // 3
        card(s, M + col_i * (cw + 0.34), BODY_TOP + row_i * 2.10, cw, 1.86,
             name, sub, accent=col, index=num, heading_size=15, body_size=10.5)

    notes(s, """
[1:00–1:40] "Here is the shape of the next eighteen minutes."
Read the six headings only. Do not read the sub-lines. Move on quickly — the value
is in sections 2, 3 and 5.
""")


# --------------------------------------------------------- 03 roles/scope ----

def s03_scope():
    s = D.page()
    head(s, "Team, roles and honest scope",
         "One person, three roles, and a clear line around the grading",
         tsize=30)

    card(s, M, BODY_TOP, 3.85, 2.05, "Product Owner",
         "Wrote and ranked the user stories, accepted or rejected each sprint increment, "
         "owned the release call.", TEAL, index="ROLE")
    card(s, M + 4.13, BODY_TOP, 3.85, 2.05, "Scrum Master",
         "Ran sprint planning, kept the GitHub board honest, enforced the definition "
         "of done and the timebox.", CYAN, index="ROLE")
    card(s, M + 8.26, BODY_TOP, 3.85, 2.05, "Engineer",
         "All Flutter, Next.js, SQL, CI and release work. Every commit in the repo is "
         "attributable to me.", VIOLET, index="ROLE")

    y = BODY_TOP + 2.34
    box = round_rect(s, M, y, CW, 1.72, SURF, GREEN, radius=0.05, lw=1.0)
    alpha(box, 0.14)
    rect(s, M, y, 0.055, 1.72, GREEN)
    text(s, M + 0.34, y + 0.24, 3.4, 0.36, "Scope statement", size=13, bold=True,
         color=GREEN, font=DISPLAY, track=0.6)
    text(s, M + 0.34, y + 0.66, CW - 0.68, 0.92,
         "CLIVORA already existed before this Capstone. The baseline product — CRM, invoicing, "
         "Connect, offline sync, billing — shipped earlier and I do not present it as sprint work.\n"
         "The three sprints being graded are a new increment: test and CI hardening, turning Ask AI "
         "into a real retrieval-augmented system, and one reliable hire-to-invoice demo loop.",
         size=11.5, color=DIM, spacing=1.32)

    notes(s, """
[1:40–2:40] This slide protects your grade. Say it plainly:
"I want to be precise about scope. CLIVORA was already live before this Capstone. I am
not claiming the whole product as three sprints of work. What Quantic is grading is a
new increment on top of a real production system: testing and CI, an AI retrieval layer,
and one end-to-end demo loop. Everything else I show is labelled baseline."
Graders reward this honesty. Do not rush it.
""")


# ------------------------------------------------------------- dividers -----

def divider(num, label, headline, campaign_line, art, accent=TEAL):
    s = D.bare()
    glow(s, 2.0, 6.8, 7.0, accent, 0.88)
    brandbar(s, D.n, TOTAL)

    text(s, M, 1.62, 4.0, 1.6, num, size=112, bold=True, color=accent, font=DISPLAY,
         spacing=0.9)
    accent_rule(s, M, 3.32, 1.35, 0.06, accent, VIOLET)
    kicker(s, label, accent, y=3.58)
    title(s, headline, size=34, y=3.90, w=7.2)
    text(s, M, 4.76, 6.9, 0.9, campaign_line, size=13, color=DIM, spacing=1.34)

    plate = round_rect(s, 8.30, 1.02, 4.42, 5.48, SURF, LINE, radius=0.035, lw=1.0)
    alpha(plate, 0.30)
    framed_pic(s, art, 8.41, 1.13, 4.20)
    text(s, 8.41, 6.62, 4.20, 0.26, "CLIVORA Premium Campaign V2", size=8,
         color=MUTE, track=1.2, caps=True)
    footer(s, f"CLIVORA · Quantic MSSE Capstone · {LIVE}", REPO)
    return s


# ---------------------------------------------------------- 05 problem -----

def s05_problem():
    s = D.page()
    head(s, "Section 01 · the problem",
         "Independent work is not hard because of the work. It is hard because of the seams.",
         tsize=27)

    pains = [
        ("Discovery is walled off", "Marketplaces own the client relationship and take a cut of every deal.", TEAL),
        ("Delivery is scattered", "Chat in one app, tasks in another, files in a third, hours in a spreadsheet.", CYAN),
        ("Money leaks", "Invoices are rebuilt by hand, follow-ups are forgotten, revenue is invisible.", BLUE),
        ("Clients are left guessing", "No shared place to see progress, approve work or pay against a record.", VIOLET),
    ]
    cw = (CW - 3 * 0.28) / 4
    for i, (h, b, c) in enumerate(pains):
        card(s, M + i * (cw + 0.28), BODY_TOP, cw, 2.12, h, b, accent=c,
             index=f"0{i+1}", heading_size=13, body_size=10)

    y = BODY_TOP + 2.42
    stats = [
        ("2 sides", "One product has to serve the freelancer and the client, or the seam stays", TEAL),
        ("$0", "Platform fee CLIVORA takes on a negotiated Connect deal", GREEN),
        ("Offline", "Mobile work happens on bad networks — the app cannot assume a connection", CYAN),
        ("1 record", "Brief, delivery and invoice must resolve to one auditable trail", VIOLET),
    ]
    sw_ = (CW - 3 * 0.28) / 4
    for i, (v, l, c) in enumerate(stats):
        stat(s, M + i * (sw_ + 0.28), y, sw_, v, l, accent=c, value_size=26, h=1.42)

    notes(s, """
[2:40–4:00] Four seams, then four constraints. Keep it concrete:
"Every freelancer I talked to had the same four problems. Discovery is walled off inside
marketplaces that own the client. Delivery is scattered across four or five apps. Money
leaks because invoicing is manual. And the client has nowhere to look."
Then point at the bottom row: "Those problems set four hard constraints on the design —
two-sided, zero platform fee, offline-capable, and one auditable record."
""")


def s06_users():
    s = D.page()
    head(s, "Users and the alternatives", "Who it is for, and why the existing options do not fit",
         tsize=28)

    personas = [
        ("Solo freelancer", "Needs one place for clients, projects, hours and invoices — on a phone, "
         "often offline.", TEAL, "app-freelancer-home.png"),
        ("Independent team / agency", "Needs shared projects, task assignment, roles and a single "
         "revenue picture.", CYAN, "app-command-1.png"),
        ("The client", "Needs to see progress, approve work, message once and pay against a real "
         "invoice.", VIOLET, "app-client-portal.png"),
    ]
    cw = (CW - 2 * 0.30) / 3
    for i, (h, b, c, _img) in enumerate(personas):
        card(s, M + i * (cw + 0.30), BODY_TOP, cw, 1.72, h, b, accent=c,
             index=f"USER 0{i+1}", heading_size=14, body_size=10.5)

    y = BODY_TOP + 2.02
    rail_label(s, M, y, 5.0, "Why not just use what exists", MUTE)
    rows = [
        ("Freelance marketplaces", "Own the client relationship and charge a percentage of each deal"),
        ("Generic project tools", "No invoicing, no client portal, no concept of a freelance plan"),
        ("Accounting apps", "Invoice-only; nothing about delivery, tasks or the client conversation"),
        ("Spreadsheets + chat", "Zero automation, no offline guarantees, no shared client view"),
    ]
    kv_rows(s, M, y + 0.44, CW, rows, key_w=3.6, size=11.5, gap=0.50)

    notes(s, """
[4:00–5:00] Three users, then the gap.
"Three users, one product. The freelancer, the independent team, and — this is the part
most tools miss — the client, who gets a real account, not a shared link."
Then the table: "None of the four existing categories covers this. Marketplaces own the
client. Project tools do not invoice. Accounting apps do not do delivery. Spreadsheets do
not do anything automatically."
""")


# --------------------------------------------------------- 08 module map ----

def s08_modules():
    s = D.page()
    head(s, "Section 02 · the product",
         "One workspace, five connected surfaces", tsize=29,
         sub="Everything below writes to the same Postgres record, so nothing has to be re-entered.")

    cx = SW / 2
    mods = [
        ("Connect", "Jobs, talent, proposals,\nmutual accept before contact", TEAL),
        ("CRM", "Clients, projects, tasks,\nfiles, meetings", CYAN),
        ("Money", "Quotes, invoices, expenses,\ntimesheets, recurring", BLUE),
        ("Client hub", "Shared projects, approvals,\nmessages, payments", VIOLET),
    ]
    mw = (CW - 3 * 0.30) / 4
    top_y = 2.94
    for i, (name, sub, col) in enumerate(mods):
        x = M + i * (mw + 0.30)
        b = round_rect(s, x, top_y, mw, 1.10, SURF, col, radius=0.09, lw=1.0)
        alpha(b, 0.16)
        text(s, x + 0.16, top_y + 0.16, mw - 0.32, 0.30, name, size=13, bold=True,
             color=col, font=DISPLAY, align=PP_ALIGN.CENTER)
        text(s, x + 0.12, top_y + 0.52, mw - 0.24, 0.50, sub, size=9, color=DIM,
             align=PP_ALIGN.CENTER, spacing=1.20)
        rect(s, x + mw / 2 - 0.006, top_y + 1.10, 0.012, 0.26, col)

    bus = rect(s, M + mw / 2, top_y + 1.35, CW - mw, 0.022, TEAL)
    gradient(bus, TEAL, VIOLET, angle=0)
    arrow_d(s, cx - 0.085, top_y + 1.37, 0.17, 0.30, TEAL, 0.30)

    core_y = top_y + 1.74
    core = round_rect(s, cx - 2.30, core_y, 4.60, 1.08, SURF2, TEAL, radius=0.10, lw=1.5)
    alpha(core, 0.08)
    text(s, cx - 2.15, core_y + 0.16, 4.30, 0.34, "One record in Supabase Postgres",
         size=15, bold=True, color=WHITE, font=DISPLAY, align=PP_ALIGN.CENTER)
    text(s, cx - 2.15, core_y + 0.58, 4.30, 0.34,
         "Row-level security scopes every row to its owner",
         size=9.5, color=TEAL, align=PP_ALIGN.CENTER, track=0.6)

    ai_y = core_y + 1.42
    arrow_d(s, cx - 0.085, core_y + 1.10, 0.17, 0.28, GREEN, 0.30)
    ai = round_rect(s, cx - 3.55, ai_y, 7.10, 0.86, SURF, GREEN, radius=0.09, lw=1.0)
    alpha(ai, 0.16)
    text(s, cx - 3.40, ai_y + 0.13, 6.80, 0.30, "Ask AI", size=13, bold=True,
         color=GREEN, font=DISPLAY, align=PP_ALIGN.CENTER)
    text(s, cx - 3.40, ai_y + 0.47, 6.80, 0.30,
         "Reads that record, cites what it used, and never acts without a human",
         size=9, color=DIM, align=PP_ALIGN.CENTER)

    notes(s, """
[5:00–5:45] Trace the flow with your cursor: Connect → CRM → Money → Client hub.
"Five surfaces, one record. A job accepted in Connect becomes a client and a project in
CRM. That project's hours become a timesheet and an invoice in Money. The client sees the
same objects in their own hub. Nothing is re-entered, because there is only one row."
Ask AI sits underneath and reads that record — I come back to it in section three.
""")


def s09_web():
    s = D.page()
    kicker(s, "Web · live at clivora.io", TEAL, y=1.02)
    title(s, "The freelancer workspace", size=27, y=1.32, w=4.0)
    text(s, M, 2.22, 3.62, 3.4,
         "The web app is a Next.js 15 App Router product deployed as a Node process on "
         "Hostinger. Server Components load the profile and gate every route before the "
         "browser renders anything.\n\n"
         "This is the surface a freelancer opens in the morning: what needs attention, what "
         "is in flight, and what has not been paid.",
         size=11.5, color=DIM, spacing=1.36)
    bullets(s, M, 5.28, 3.62, [
        "Server-gated routes, no client-side auth",
        "Same Postgres rows as the Android app",
        "Public invoice share links at /i/[token]",
    ], size=10.5, gap=0.40, accent=TEAL)
    framed_pic(s, "catalogue-1.png", 4.62, 1.06, 8.10, pad=0.075)
    footer(s, f"CLIVORA · Quantic MSSE Capstone · {LIVE}", REPO)

    notes(s, """
[5:45–6:15] "This is the live web workspace at clivora.io. Next.js 15, App Router,
deployed as a Node process — not a static export, because routes are gated on the server
before anything renders."
Fast pass. The real depth comes in the demo.
""")


def s10_loop():
    s = D.page()
    kicker(s, "The daily loop", TEAL, y=1.02)
    title(s, "From daily priority\nto final invoice", size=26, y=1.32, w=4.0)
    text(s, M, 2.62, 3.62, 3.0,
         "Six steps cover almost everything a freelancer does in a day. CLIVORA is designed "
         "so each step hands off to the next without an export, a copy-paste or a second tool.",
         size=11.5, color=DIM, spacing=1.36)
    steps = ["Start the day", "Organise the work", "Keep clients close",
             "Discover opportunities", "Track the time", "Send the invoice"]
    y = 4.02
    for i, st in enumerate(steps):
        col = ACCENTS[i % 4]
        oval(s, M, y + 0.055, 0.20, 0.20, col)
        text(s, M + 0.12, y + 0.045, 0.20, 0.22, f"{i+1}", size=7, bold=True,
             color=INK, align=PP_ALIGN.CENTER)
        text(s, M + 0.34, y, 3.3, 0.32, st, size=11, bold=True, color=WHITE)
        y += 0.42
    framed_pic(s, "catalogue-5.png", 4.62, 1.06, 8.10, pad=0.075)
    footer(s, f"CLIVORA · Quantic MSSE Capstone · {LIVE}", REPO)

    notes(s, """
[6:15–6:45] "Six steps, and the point is the hand-offs. Step five, tracked time, becomes
step six, the invoice line — automatically. That is the whole thesis of the product."
""")


def s11_connect():
    s = D.page()
    kicker(s, "CLIVORA Connect · not another marketplace", TEAL, y=1.02)
    title(s, "Find the work.\nKeep the relationship.", size=26, y=1.32, w=4.0)
    text(s, M, 2.72, 3.62, 2.4,
         "Connect is a private marketplace. Contact details stay hidden until both sides "
         "accept, and CLIVORA takes no percentage of the negotiated deal.",
         size=11.5, color=DIM, spacing=1.36)
    for i, (h, b, c) in enumerate([
        ("Mutual accept", "Emails are revealed only after both parties agree", TEAL),
        ("$0 platform fee", "Revenue comes from subscriptions, not from your deal", GREEN),
        ("Pro Plus to act", "Browsing is free; posting and contacting is an entitlement", VIOLET),
    ]):
        y = 3.98 + i * 0.94
        rect(s, M, y, 0.045, 0.74, c)
        text(s, M + 0.26, y, 3.4, 0.30, h, size=11.5, bold=True, color=WHITE)
        text(s, M + 0.26, y + 0.30, 3.4, 0.44, b, size=9.5, color=DIM, spacing=1.20)
    framed_pic(s, "catalogue-2.png", 4.62, 1.06, 8.10, pad=0.075)
    footer(s, f"CLIVORA · Quantic MSSE Capstone · {LIVE}", REPO)

    notes(s, """
[6:45–7:20] This is the differentiator — say it clearly.
"Connect is where the work is discovered, but it is deliberately not a marketplace that
owns you. Contact details unlock only on mutual accept, and CLIVORA charges zero platform
fee on the deal. We monetise the subscription, not your invoice."
""")


def s12_client():
    s = D.page()
    kicker(s, "Built for clients", VIOLET, y=1.02)
    title(s, "The client is a\nfirst-class user", size=26, y=1.32, w=4.0)
    text(s, M, 2.72, 3.62, 2.6,
         "Clients get a real account, not a share link. They see the projects that were "
         "explicitly shared with them, approve work, message once, and pay against an "
         "invoice that already exists in the system.",
         size=11.5, color=DIM, spacing=1.36)
    bullets(s, M, 4.42, 3.62, [
        "Shared projects with live progress",
        "Client actions queue: jobs, proposals, approvals",
        "Invoices and contracts in one hub",
        "One thread per relationship",
    ], size=11, gap=0.46, accent=VIOLET)
    framed_pic(s, "catalogue-4.png", 4.62, 1.06, 8.10, pad=0.075)
    footer(s, f"CLIVORA · Quantic MSSE Capstone · {LIVE}", REPO)

    notes(s, """
[7:20–7:50] "Most freelance tools treat the client as a read-only link. In CLIVORA the
client signs in, sees only what was shared with them — enforced in Postgres, not in the UI —
and acts from their own queue."
""")


# ------------------------------------------------- 13-15 android triptychs ----

def triptych(kick, headline, phones, kcolor=TEAL, script=""):
    """Three framed device screenshots on the left, numbered notes on the right."""
    s = D.page()
    kicker(s, kick, kcolor, y=1.00)
    title(s, headline, size=26, y=1.30, w=7.4)

    ph = 4.60
    xs = (0.30, 2.42, 4.54)
    for (name, _h, _b), x in zip(phones, xs):
        pic_h(s, name, x, 2.06, ph)

    for i, (_name, h, b) in enumerate(phones):
        y = 2.14 + i * 1.50
        col = ACCENTS[i % 4]
        box = round_rect(s, 7.40, y, 5.32, 1.32, SURF, LINE, radius=0.05)
        alpha(box, 0.12)
        rect(s, 7.40, y, 0.045, 1.32, col)
        text(s, 7.66, y + 0.16, 0.7, 0.26, f"0{i+1}", size=9.5, bold=True, color=col,
             font=DISPLAY, track=1.0)
        text(s, 8.26, y + 0.14, 4.30, 0.32, h, size=12.5, bold=True, color=WHITE,
             font=DISPLAY)
        text(s, 7.66, y + 0.54, 4.86, 0.66, b, size=10, color=DIM, spacing=1.26)

    text(s, 0.85, 6.56, 6.2, 0.24,
         "Unretouched screenshots from the released Android build",
         size=8.5, color=MUTE, track=1.0, caps=True)
    if script:
        notes(s, script)
    return s


def s13_android_a():
    triptych("Android · Flutter · Google Play", "The freelancer's phone, unretouched",
             [("app-freelancer-home.png", "Work queue first",
               "Unanswered client messages, accepted work and today's tasks before anything else."),
              ("app-dashboard.png", "The business at a glance",
               "Invoiced total, active customers, unread messages, success score and 30-day revenue."),
              ("app-command-1.png", "Command Center",
               "Every module reachable in two taps — tasks, calendar, campaigns, automations, AI.")],
             TEAL, """
[7:50–8:30] Emphasise that these are real screenshots, not mockups.
"These are unretouched screenshots from the build that is on Google Play. Note the phone
status bar. Screen one is the work queue — the app opens on what needs a response, not on
a marketing dashboard. Screen two is the business summary. Screen three is Command Center,
which is how you reach the other thirty modules."
""")


def s14_android_b():
    triptych("Android · Connect and money", "Discovery and getting paid",
             [("app-connect-jobs.png", "Open jobs",
               "Live Connect listings with budget bands and skills. Browsing is free on every plan."),
              ("app-connect-talent.png", "Verified talent",
               "The other side of the same marketplace — verified profiles, rates and history."),
              ("app-invoice-paid.png", "Paid, with a branded PDF",
               "A real invoice moved to PAID, with a generated branded PDF the client can keep.")],
             CYAN, """
[8:30–9:10] "Connect on mobile — jobs on one side, talent on the other, same private
marketplace. And the end of the loop: a real invoice marked paid, with a branded PDF
generated from the record. That invoice number is from my own account."
""")


def s15_android_c():
    triptych("Android · the client side", "The client's phone is a different app",
             [("app-client-portal.png", "Client portal",
               "A client signs in and sees their action queue and only the projects shared with them."),
              ("app-client-chat.png", "One thread per relationship",
               "Invitations, updates and replies in a single conversation, synced to the web app."),
              ("app-client-hub.png", "Client hub",
               "Quotes, payments, credits, recurring and invoices — the money view for the buyer.")],
             VIOLET, """
[9:10–9:45] "Same binary, different experience. When the account type is client, the app
renders the portal instead of the workspace. The client sees one shared project here —
enforced by row-level security in Postgres, which I will come back to."
""")


def s16_automation():
    s = D.page()
    kicker(s, "Automation engine", AMBER, y=1.02)
    title(s, "Rules that run on the device", size=27, y=1.32, w=7.2)
    lede(s, "Automations fire locally when a customer or invoice is saved, so follow-ups happen "
            "even when the network does not.", y=2.06, w=7.2)

    pipeline = [
        ("Invoice overdue", "Create task + notify", ROSE),
        ("New customer", "Welcome note + onboarding", TEAL),
        ("Every 7 days", "Revenue summary note", CYAN),
        ("Task assigned", "Send client message", BLUE),
        ("Contract signed", "Project → in progress", GREEN),
        ("Client inactive 7+ days", "Create follow-up task", VIOLET),
    ]
    for i, (trigger, action, col) in enumerate(pipeline):
        col_i, row_i = i % 2, i // 2
        x = M + col_i * 3.72
        y = 2.92 + row_i * 1.14
        b = round_rect(s, x, y, 1.72, 0.86, SURF2, col, radius=0.08, lw=1.0)
        alpha(b, 0.18)
        text(s, x + 0.10, y, 1.52, 0.86, trigger, size=9.5, bold=True, color=WHITE,
             align=PP_ALIGN.CENTER, anchor=MSO_ANCHOR.MIDDLE, spacing=1.14)
        arrow_r(s, x + 1.78, y + 0.345, 0.30, 0.17, col, 0.35)
        b2 = round_rect(s, x + 2.12, y, 1.42, 0.86, SURF, LINE, radius=0.08)
        alpha(b2, 0.20)
        text(s, x + 2.20, y, 1.26, 0.86, action, size=9, color=DIM,
             align=PP_ALIGN.CENTER, anchor=MSO_ANCHOR.MIDDLE, spacing=1.14)

    pic_h(s, "app-workflows.png", 9.05, 1.32, 5.55)
    footer(s, f"CLIVORA · Quantic MSSE Capstone · {LIVE}", REPO)

    notes(s, """
[9:45–10:15] "Six trigger-action rules ship with the app, and they execute on the device
when you save a customer or an invoice. That matters offline: an overdue invoice still
creates a follow-up task on a train with no signal, and the resulting rows sync later
through the outbox."
""")


def s17_one_account():
    s = D.page()
    kicker(s, "One account, two clients", CYAN, y=1.02)
    title(s, "The same product,\nnot a port", size=26, y=1.32, w=4.0)
    cols = [
        ("Shared source of truth",
         "Both clients read and write the same Postgres rows. There is no sync layer "
         "between two databases, because there is only one.", TEAL),
        ("Shared business rules",
         "plan-gates.ts on the web and PlanLimits in Flutter are mirrored, and both "
         "are unit-tested.", CYAN),
        ("Different strengths",
         "Web gets server-rendered route gating. Android gets offline-first storage "
         "and on-device automation.", VIOLET),
    ]
    y = 2.52
    for hh, bb, cc in cols:
        rect(s, M, y, 0.045, 1.28, cc)
        text(s, M + 0.26, y, 3.55, 0.30, hh, size=11.5, bold=True, color=WHITE,
             font=DISPLAY)
        text(s, M + 0.26, y + 0.34, 3.55, 0.92, bb, size=10, color=DIM, spacing=1.26)
        y += 1.44
    framed_pic(s, "catalogue-3.png", 4.62, 1.06, 8.10, pad=0.075)
    footer(s, f"CLIVORA · Quantic MSSE Capstone · {LIVE}", REPO)

    notes(s, """
[10:15–10:40] "One account works on both. This is the Google Play feature graphic, and the
important claim is underneath it: this is not a web app wrapped in a shell. Two native
clients, one contract, one database, mirrored business rules that are unit-tested on both
sides."
That is the bridge into the engineering section.
""")


# ---------------------------------------------------------- engineering -----

def s19_architecture():
    s = D.page()
    head(s, "Section 03 · engineering", "System architecture", tsize=29,
         sub="Two untrusted clients, one trusted database. Authorisation lives in Postgres, not in the UI.")

    rail_label(s, M, 2.86, 1.9, "Clients", TEAL)
    node(s, 2.72, 2.74, 4.72, 1.04, "Next.js 15 · App Router",
         "React Server Components · clivora.io on Hostinger Node", TEAL)
    node(s, 7.86, 2.74, 4.72, 1.04, "Flutter · Android",
         "Google Play · org.codcrafters.clivora", CYAN)

    arrow_d(s, 5.00, 3.86, 0.17, 0.30, TEAL, 0.40)
    arrow_d(s, 10.14, 3.86, 0.17, 0.30, CYAN, 0.40)

    rail_label(s, M, 4.36, 1.9, "App layer", BLUE)
    node(s, 2.72, 4.24, 4.72, 1.04, "Backend-for-Frontend",
         "Server Components + Route Handlers · secrets never reach the browser", BLUE)
    node(s, 7.86, 4.24, 4.72, 1.04, "Repositories + Drift SQLite",
         "Offline-first cache and a transactional sync outbox", BLUE)

    arrow_d(s, 5.00, 5.36, 0.17, 0.30, BLUE, 0.40)
    arrow_d(s, 10.14, 5.36, 0.17, 0.30, BLUE, 0.40)

    rail_label(s, M, 5.86, 1.9, "Cloud", VIOLET)
    tiles = [("Postgres + RLS", "system of record"), ("Auth", "Google + email"),
             ("Storage", "vault + share links"), ("Edge Functions", "server-only jobs")]
    tw = (12.58 - 2.72 - 3 * 0.22) / 4
    for i, (t, sub) in enumerate(tiles):
        node(s, 2.72 + i * (tw + 0.22), 5.74, tw, 1.04, t, sub, VIOLET, sub_size=8)

    notes(s, """
[10:40–11:40] Walk it top to bottom, once.
"Three tiers. At the top, two clients — Next.js 15 on the web, Flutter on Android. In the
middle, each client has its own app layer: the web uses a backend-for-frontend so LLM keys
and service-role secrets never enter the browser bundle or the APK; Android has repositories
over a local Drift SQLite database with a sync outbox. At the bottom, Supabase.
The load-bearing decision is that both clients are untrusted. Authorisation is row-level
security in Postgres, so hiding a button is never the security control."
""")


def s20_outbox():
    s = D.page()
    head(s, "Pattern · transactional outbox on a mobile client",
         "Offline-first sync, and what happens when sync fails", tsize=27,
         sub="Freelancers work on bad networks. The Android app never blocks a write on connectivity.")

    flow(s, M, 3.12, CW, 1.18, [
        ("Edit offline", "user saves a client\nor an invoice"),
        ("Drift write", "local SQLite commits\nimmediately"),
        ("Outbox row", "sync_outbox_entries\nmarked pending"),
        ("Flush", "connectivity returns,\nqueue drains in order"),
        ("Postgres", "RLS-checked write,\ncloud is authoritative"),
    ], gap=0.40, accent=[TEAL, TEAL, CYAN, BLUE, VIOLET], heading_size=11.5)

    y = 4.86
    fail = round_rect(s, M, y, 5.9, 1.32, SURF, ROSE, radius=0.05, lw=1.0)
    alpha(fail, 0.16)
    rect(s, M, y, 0.045, 1.32, ROSE)
    text(s, M + 0.28, y + 0.18, 5.3, 0.30, "Failure path is explicit", size=12,
         bold=True, color=ROSE, font=DISPLAY)
    text(s, M + 0.28, y + 0.54, 5.3, 0.66,
         "Unknown operation kinds are marked permanently_failed and kept for diagnosis "
         "rather than silently dropped. Last-write-wins collisions write a conflict record.",
         size=10, color=DIM, spacing=1.26)

    why = round_rect(s, M + 6.20, y, 5.9, 1.32, SURF, GREEN, radius=0.05, lw=1.0)
    alpha(why, 0.16)
    rect(s, M + 6.20, y, 0.045, 1.32, GREEN)
    text(s, M + 6.48, y + 0.18, 5.3, 0.30, "Why this pattern", size=12, bold=True,
         color=GREEN, font=DISPLAY)
    text(s, M + 6.48, y + 0.54, 5.3, 0.66,
         "It is the transactional outbox from distributed systems, adapted to a phone. "
         "Tested with in-memory Drift in test/sync_outbox_service_test.dart.",
         size=10, color=DIM, spacing=1.26)

    notes(s, """
[11:40–12:30] This is your strongest engineering story. Slow down.
"The riskiest subsystem in the product is offline sync, so it uses a named pattern: the
transactional outbox, adapted to a mobile client. A save commits to local SQLite
immediately and writes a pending row to sync_outbox_entries. When connectivity returns the
queue drains in order into Postgres, where row-level security checks it again.
The failure path is deliberate: an operation kind the app does not understand is marked
permanently_failed and kept, because a silently dropped invoice is worse than a visible
error. That behaviour is covered by unit tests against an in-memory database."
""")


def s21_security():
    s = D.page()
    head(s, "Pattern · authorisation in the data layer",
         "Security model: the database is the last word", tsize=28,
         sub="Both a browser bundle and an APK can be read by an attacker, so neither can be the gate.")

    layers = [
        ("Client", "Flutter APK / browser bundle", "Assumed hostile. Hiding UI is a UX choice, never a control.", ROSE),
        ("Server", "Route handlers + Server Components", "Cookie sessions via @supabase/ssr. LLM keys and service role stay here.", AMBER),
        ("Database", "Postgres row-level security", "Every table policy-scoped to the owner. Triggers protect role, account type and plan flags from self-elevation.", GREEN),
    ]
    y = BODY_TOP + 0.26
    for name, sub, body, col in layers:
        b = round_rect(s, M, y, 7.55, 1.16, SURF, col, radius=0.06, lw=1.0)
        alpha(b, 0.16)
        rect(s, M, y, 0.05, 1.16, col)
        text(s, M + 0.30, y + 0.16, 2.5, 0.30, name, size=13, bold=True, color=col,
             font=DISPLAY)
        text(s, M + 0.30, y + 0.48, 3.2, 0.28, sub, size=9, color=MUTE, track=0.6, caps=True)
        text(s, M + 3.70, y + 0.18, 3.65, 0.86, body, size=10, color=DIM, spacing=1.24)
        y += 1.34

    x = M + 7.90
    box = round_rect(s, x, BODY_TOP + 0.26, 4.21, 3.68, SURF2, LINE, radius=0.05)
    alpha(box, 0.16)
    text(s, x + 0.28, BODY_TOP + 0.48, 3.6, 0.32, "Concrete controls", size=12.5,
         bold=True, color=WHITE, font=DISPLAY)
    bullets(s, x + 0.28, BODY_TOP + 0.92, 3.65, [
        "Connect emails hidden until mutual accept",
        "Vault share links resolve owner-scoped files, never a raw caller path",
        "Privileged profile columns guarded by DB triggers",
        "No service-role key in any shipped client",
        "Secrets, keystores and .env gitignored",
    ], size=10, gap=0.56, accent=GREEN)

    notes(s, """
[12:30–13:20] "Security is a three-layer story and the summary is that the database has
the last word. The client is assumed hostile — anyone can decompile the APK. The server
holds the session and the secrets. And Postgres row-level security scopes every table to
its owner, with triggers so a client cannot promote itself to Pro Plus or to admin by
writing its own profile row.
The concrete consequences are on the right. The one I care most about is that Connect
emails are unreachable until both sides accept — that is a policy in the database, not a
hidden field in the UI."
""")


def s22_patterns():
    s = D.page()
    head(s, "Design decisions", "Patterns used, and why each one was chosen", tsize=29)
    pats = [
        ("Feature-first modules", "lib/features/* and App Router areas.\nSprint slices map to folders, so invoices never bleed into Connect.", TEAL),
        ("Repository pattern", "CloudCrmRepository, CloudInvoiceRepository, web/src/lib/crm.\nOne place for queries, mapping and entitlement checks.", CYAN),
        ("Transactional outbox", "Offline writes queue and drain in order.\nChosen because mobile connectivity cannot be a precondition.", BLUE),
        ("Backend-for-Frontend", "Server Components and route handlers hold the session.\nKeeps secrets out of the browser bundle and the APK.", VIOLET),
        ("Policy objects", "plan-gates.ts and Flutter PlanLimits.\nProduct rules become testable functions, not UI copy.", GREEN),
        ("Expand / contract", "Money stored as major units and integer minor units.\nMigration without a flag-day cutover.", AMBER),
    ]
    cwid = (CW - 2 * 0.30) / 3
    for i, (h, b, c) in enumerate(pats):
        col_i, row_i = i % 3, i // 3
        card(s, M + col_i * (cwid + 0.30), BODY_TOP + row_i * 2.06, cwid, 1.82,
             h, b, accent=c, heading_size=13, body_size=9.5)

    notes(s, """
[13:20–14:00] Do not read all six. Pick three and say why.
"Six named patterns. I will call out three. Repository, so the same business rule holds on
web and Android. Policy objects, so a free-plan cap of three clients is a pure function I
can unit-test rather than a disabled button. And expand-contract for money, because invoice
amounts are stored both as major units and as integer minor units, which let me migrate
away from floating-point currency without a flag day."
""")


def s23_money():
    s = D.page()
    head(s, "Correctness where it hurts most", "Money is never a floating-point number",
         tsize=29,
         sub="An invoice that is a cent wrong destroys trust faster than any missing feature.")

    flow(s, M, 3.06, CW, 1.16, [
        ("Legacy shape", "amount stored as a\ndecimal number"),
        ("Expand", "add total_minor and\nsiblings, dual-write"),
        ("Backfill", "compute minor units\nfor historical rows"),
        ("Read minor", "all arithmetic moves to\ninteger minor units"),
        ("Contract", "retire the float path\nonce reads are clean"),
    ], gap=0.38, accent=[MUTE, AMBER, AMBER, GREEN, GREEN], heading_size=11)

    y = 4.78
    left = round_rect(s, M, y, 5.9, 1.52, SURF, GREEN, radius=0.05, lw=1.0)
    alpha(left, 0.16)
    text(s, M + 0.30, y + 0.20, 5.3, 0.30, "Proven by tests, not by inspection",
         size=12, bold=True, color=GREEN, font=DISPLAY)
    bullets(s, M + 0.30, y + 0.60, 5.3, [
        "web/src/lib/money.test.ts — conversion + dual-write fields",
        "Helpers are pure functions in web/src/lib/money.ts",
    ], size=10, gap=0.40, accent=GREEN)

    right = round_rect(s, M + 6.20, y, 5.9, 1.52, SURF, LINE, radius=0.05)
    alpha(right, 0.16)
    text(s, M + 6.50, y + 0.20, 5.3, 0.30, "Entitlements get the same treatment",
         size=12, bold=True, color=WHITE, font=DISPLAY)
    bullets(s, M + 6.50, y + 0.60, 5.3, [
        "Free caps: 3 clients · 5 projects · 10 invoices per UTC month",
        "plan.test.ts and plan-gates.test.ts pin the boundaries",
    ], size=10, gap=0.40, accent=CYAN)

    notes(s, """
[14:00–14:35] "Two places where a bug is unforgivable: money and plan limits.
Invoice amounts are stored as major units and as integer minor units at the same time, and
the migration follows expand-contract — dual-write, backfill, switch reads, then retire the
old path. No flag day. And the free-plan caps — three clients, five projects, ten invoices
per UTC month — are pure functions with tests pinning the boundary, including the month
rollover, because 'ten invoices this month' is ambiguous until you fix the timezone."
""")


def s24_ai():
    s = D.page()
    head(s, "AI engineering", "Ask AI: retrieval-augmented, grounded, and never autonomous",
         tsize=27,
         sub="Sprint 2 turned a generic assistant into a system that answers from the user's own records.")

    flow(s, M, 2.92, CW, 1.10, [
        ("Question", "asked inside the\nworkspace"),
        ("CRM context", "aggregates for the\nsigned-in owner"),
        ("Retrieve", "crm_embeddings:\nkeyword + recent"),
        ("Assemble", "prompt built from\nretrieved chunks"),
        ("Generate", "OpenAI or Anthropic,\nkey server-side only"),
        ("Grounded answer", "cites the invoice or\nclient it came from"),
    ], gap=0.30, accent=[TEAL, TEAL, CYAN, BLUE, VIOLET, GREEN], heading_size=10.5,
        sub_size=8)

    y = 4.42
    guard = round_rect(s, M, y, CW, 0.86, SURF, ROSE, radius=0.05, lw=1.0)
    alpha(guard, 0.16)
    rect(s, M, y, 0.05, 0.86, ROSE)
    text(s, M + 0.30, y + 0.14, 3.4, 0.30, "Human-in-the-loop gate", size=12,
         bold=True, color=ROSE, font=DISPLAY)
    text(s, M + 0.30, y + 0.46, CW - 0.60, 0.32,
         "Structured suggestions are feature-flagged and require review. auto_pay and "
         "auto_publish are forbidden — the model proposes, a person commits.",
         size=10.5, color=DIM)

    y2 = 5.52
    for i, (h, b, c) in enumerate([
        ("Fail open, honestly", "No key or no index? Ask AI falls back to CRM aggregates and "
         "honest offline tips rather than inventing an answer.", TEAL),
        ("Indexing is opt-in", "POST /api/ai/index-crm. Live invoice and client saves were left "
         "unchanged, so the AI work could not regress the money path.", CYAN),
        ("Evaluated, not vibes", "A written eval set of questions and expected citations lives in "
         "docs/capstone/ASK_AI_EVAL.md.", VIOLET),
    ]):
        cwid = (CW - 2 * 0.30) / 3
        x = M + i * (cwid + 0.30)
        rect(s, x, y2, 0.045, 1.16, c)
        text(s, x + 0.26, y2, cwid - 0.30, 0.30, h, size=11.5, bold=True, color=WHITE)
        text(s, x + 0.26, y2 + 0.32, cwid - 0.30, 0.82, b, size=9.5, color=DIM, spacing=1.24)

    notes(s, """
[14:35–15:40] This is the AI-engineering requirement. Be precise about what shipped.
"Before this Capstone, Ask AI was a thin wrapper: it loaded CRM aggregates and asked a
model. Aggregates are shallow — they cannot answer 'which client is slowest to pay'.
Sprint 2 made it a retrieval system. The question triggers retrieval over crm_embeddings
scoped to the signed-in owner, the prompt is assembled from those chunks, and the answer
cites the invoice or client it came from.
Three engineering decisions matter more than the model choice. It fails open — no key or
no index means honest aggregates instead of a hallucination. Indexing is opt-in through its
own endpoint, so the AI work could not regress the invoice save path. And there is a
written eval set, so 'it feels better' is not the evidence.
The red band is the governance answer: the model proposes, a human commits. Auto-pay and
auto-publish are explicitly forbidden."
""")


def s25_testing():
    s = D.page()
    head(s, "Verification", "Test strategy: cheap tests where the blast radius is largest",
         tsize=27,
         sub="Eight automated suites run in CI on every push and pull request to main and develop.")

    cx = 3.55
    tiers = [
        ("Manual release smoke", "Play install, Connect accept, public invoice link", 2.05, ROSE),
        ("Widget + routing", "App boots to splash · notification deep links", 3.35, AMBER),
        ("Unit — 8 suites", "Vitest (web) + flutter test · money, plans, RAG, outbox, Drift", 4.65, GREEN),
    ]
    y = 2.96
    for name, sub, w, col in tiers:
        b = round_rect(s, cx - w / 2, y, w, 1.00, SURF2, col, radius=0.06, lw=1.0)
        alpha(b, 0.16)
        text(s, cx - w / 2 + 0.12, y + 0.14, w - 0.24, 0.30, name, size=11.5, bold=True,
             color=col, font=DISPLAY, align=PP_ALIGN.CENTER)
        text(s, cx - w / 2 + 0.12, y + 0.46, w - 0.24, 0.46, sub, size=8.5, color=DIM,
             align=PP_ALIGN.CENTER, spacing=1.18)
        y += 1.14
    text(s, cx - 2.4, y + 0.06, 4.8, 0.30,
         "Fast, deterministic, no device or cloud credentials needed",
         size=9, color=MUTE, align=PP_ALIGN.CENTER, spacing=1.2)

    x = 6.35
    rail_label(s, x, 2.88, 5.8, "What each suite proves", CYAN)
    rows = [
        ("money.test.ts", "Minor-unit conversion and invoice dual-write fields"),
        ("plan-gates.test.ts", "Free-plan caps and UTC-month invoice counting"),
        ("crm-rag.test.ts", "Chunking, ilike sanitisation, no invented amounts"),
        ("plan.test.ts", "Pro / Pro Plus / client detection"),
        ("sync_outbox_service_test", "Pending vs permanently_failed, payload migration"),
        ("database_test.dart", "Drift insert/read and per-user invoice counts"),
        ("notification_deep_link", "Notifications route to the right screen"),
        ("widget_test.dart", "App boots to the CLIVORA splash"),
    ]
    kv_rows(s, x, 3.32, 5.98, rows, key_w=2.35, size=9.5, gap=0.42)

    notes(s, """
[15:40–16:30] "Testing follows one rule: put the cheap deterministic tests where the blast
radius is largest. That is money, plan gates, the RAG helpers and the sync outbox — all
pure functions or in-memory database tests, no device and no cloud credentials, so they
run in seconds in CI.
Above that, widget tests for boot and notification routing. Manual testing sits at the top
and is only a release smoke check — I do not count it as engineering evidence.
I will also be honest about the gap: web end-to-end coverage with Playwright is still an
open risk, tracked as QA-001. Sprint 1 closed the unit-test and CI gap; the journey tests
are still outstanding."
""")


def s26_cicd():
    s = D.page()
    head(s, "Delivery", "CI/CD: the same gates for the Capstone and for production",
         tsize=28,
         sub="GitHub Actions on main and develop. A test that does not run in CI is not evidence.")

    rail_label(s, M, 2.90, 4.0, "Continuous integration", TEAL)
    flow(s, M, 3.28, CW, 1.06, [
        ("Push / PR", "main or develop"),
        ("flutter analyze", "static analysis on lib/"),
        ("flutter test", "unit + widget suites"),
        ("typecheck + lint", "tsc --noEmit · eslint\n--max-warnings=0"),
        ("npm test", "Vitest suites"),
        ("next build", "production build must\ncompile"),
    ], gap=0.26, accent=[MUTE, TEAL, TEAL, CYAN, CYAN, BLUE], heading_size=10.5,
        sub_size=8)

    rail_label(s, M, 4.80, 4.0, "Continuous delivery", VIOLET)
    flow(s, M, 5.18, 6.0, 1.06, [
        ("Merge to main", "green build required"),
        ("Hostinger Node", "clivora.io serves the\nNext.js process"),
    ], gap=0.34, accent=[GREEN, GREEN], heading_size=10.5, sub_size=8)
    flow(s, M + 6.30, 5.18, 5.78, 1.06, [
        ("Tag vX.Y.Z-playstore", "re-runs analyze + test"),
        ("Signed APK / AAB", "Google Play release"),
    ], gap=0.34, accent=[VIOLET, VIOLET], heading_size=10.5, sub_size=8)

    notes(s, """
[16:30–17:00] "Three workflows. Continuous integration runs on every push and pull request
to main or develop: Flutter analyze and test, then the web typecheck, lint with zero
warnings allowed, the Vitest suites, and a production build.
Delivery splits by client. Web is a Node process on Hostinger, so a green merge to main is
what reaches clivora.io. Android is tag-driven — a release tag re-runs the analysis and
tests before it signs an APK and an app bundle for Play.
Adding npm test into that pipeline was a Sprint 1 story. Before it, the web tests existed
but nothing enforced them."
""")


def s27_deploy():
    s = D.page()
    head(s, "Deployment recommendation", "Where this should run, and what it costs relatively",
         tsize=28)
    lede(s, "The handbook asks for a recommendation with relative cost. Mine is to stay on "
            "managed cloud — and the reason is architectural, not only financial.", y=2.16)

    opts = [
        ("Managed cloud", "Chosen",
         "Hostinger Node for Next.js · Supabase cloud · Google Play for Android distribution",
         "Low to moderate. No Kubernetes bill, no ops headcount. Already live.",
         "Recommended for the Capstone and early production.", GREEN),
        ("Heavier public cloud", "Deferred",
         "Same app on AWS or GCP — Cloud Run or ECS, RDS, S3, load balancers",
         "Higher monthly cost and materially higher ops time at this traffic level.",
         "Only once Hostinger or Supabase limits are actually reached.", AMBER),
        ("On-premises", "Not recommended",
         "Customer-hosted Postgres and Node, sideloaded or MDM-managed Android",
         "High: hardware, TLS, backups, 24/7 ops, Play enterprise distribution.",
         "Wrong fit — Connect is a two-sided network and needs a shared service.", ROSE),
    ]
    for label, x, w in [("Option", M + 0.30, 2.9), ("What it means", M + 3.40, 3.35),
                        ("Relative cost", M + 7.00, 2.55),
                        ("Recommendation", M + 9.80, 2.30)]:
        text(s, x, 2.94, w, 0.24, label, size=8.5, color=MUTE, track=1.4, caps=True)

    y = 3.24
    for name, verdict, what, cost, rec, col in opts:
        b = round_rect(s, M, y, CW, 1.14, SURF, col, radius=0.05, lw=1.0)
        alpha(b, 0.14)
        rect(s, M, y, 0.05, 1.14, col)
        text(s, M + 0.30, y + 0.16, 2.9, 0.32, name, size=13, bold=True, color=WHITE,
             font=DISPLAY)
        pill(s, M + 0.30, y + 0.58, 1.75, 0.30, verdict, col, SURF2, col, size=8)
        text(s, M + 3.40, y + 0.14, 3.35, 0.90, what, size=9.5, color=DIM, spacing=1.22)
        text(s, M + 7.00, y + 0.14, 2.55, 0.90, cost, size=9.5, color=DIM, spacing=1.22)
        text(s, M + 9.80, y + 0.14, 2.30, 0.90, rec, size=9.5, color=col, spacing=1.22)
        y += 1.26

    notes(s, """
[17:00–17:40] "The handbook asks for a deployment recommendation with relative cost, so
here are three options judged honestly.
Managed cloud is what CLIVORA runs on today and what I recommend keeping. A Node process
on Hostinger, Supabase for the database and auth, Google Play for distribution. Low to
moderate cost, and critically no ops headcount.
Moving to AWS or GCP would cost more in money and much more in operator time, and buys
nothing at this traffic level — so it is deferred, not rejected.
On-premises I actively recommend against, and the reason is architectural, not financial:
Connect is a two-sided network. A customer-hosted instance cannot match a freelancer in one
company with a client in another."
""")


# -------------------------------------------------------------- process -----

def s29_baseline():
    s = D.page()
    head(s, "Section 04 · agile process", "Baseline versus the Capstone increment",
         tsize=28,
         sub="This is the same boundary from slide three, now with the evidence attached.")

    x2 = M + 6.35
    rail_label(s, M, 2.82, 5.6, "Baseline — shipped before the Capstone", MUTE)
    b = round_rect(s, M, 3.24, 5.85, 3.52, SURF, LINE, radius=0.05)
    alpha(b, 0.16)
    bullets(s, M + 0.28, 3.46, 5.35, [
        "Freelancer and client accounts, Google sign-in",
        "CRM: clients, projects, invoices, expenses, quotes, timesheets",
        "Android offline CRM with the sync outbox",
        "Connect: jobs, talent, proposals, mutual accept",
        "Messaging, meetings, public invoice share pages",
        "Free / Pro / Pro Plus gates, Play Billing",
        "Admin console, feature flags, vault share links",
    ], size=10, gap=0.44, accent=MUTE)

    rail_label(s, x2, 2.82, 5.6, "Capstone increment — what Quantic grades", TEAL)
    sprints = [
        ("Sprint 1", "Grader-ready repo: docs, board, secrets hygiene, unit tests, npm test in CI", TEAL),
        ("Sprint 2", "Ask AI becomes retrieval-augmented, with an eval set and a human-review gate", CYAN),
        ("Sprint 3", "One reliable hire-to-invoice demo loop and this presentation", VIOLET),
    ]
    y = 3.24
    for name, body, col in sprints:
        bb = round_rect(s, x2, y, 5.85, 1.10, SURF, col, radius=0.05, lw=1.0)
        alpha(bb, 0.14)
        rect(s, x2, y, 0.045, 1.10, col)
        text(s, x2 + 0.28, y + 0.16, 2.2, 0.28, name, size=11.5, bold=True, color=col,
             font=DISPLAY, track=0.8, caps=True)
        text(s, x2 + 0.28, y + 0.48, 5.3, 0.54, body, size=10.5, color=DIM, spacing=1.24)
        y += 1.21

    notes(s, """
[17:40–18:10] "Left column: baseline, already in production, not claimed as sprint work.
Right column: the three sprints Quantic is grading. Sprint 1 made the repository
gradeable and closed the test and CI gap. Sprint 2 treated CLIVORA as an AI system. Sprint 3
is the demo loop and this presentation."
""")


def s30_timeline():
    s = D.page()
    head(s, "Cadence", "Three sprints, 20 August to 14 November 2026", tsize=29)
    lede(s, "Four weeks each, solo team, weekly timeboxed check-ins. Every sprint closes with a "
            "demo recorded for the Product Owner — accept or reject, then re-plan.", y=2.14)

    ax_l, ax_r = 2.70, 12.66
    span = ax_r - ax_l
    rect(s, ax_l, 3.28, span, 0.012, LINE)
    for i, mk in enumerate(["20 Aug", "17 Sep", "16 Oct", "14 Nov"]):
        x = ax_l + span * i / 3
        rect(s, x, 3.16, 0.012, 0.24, LINE)
        text(s, x - 0.55, 2.90, 1.10, 0.24, mk, size=9, color=MUTE,
             align=PP_ALIGN.CENTER, track=0.6)

    bar_w = span / 3 - 0.16
    rows = [
        ("Sprint 1", "Grader-ready repo", TEAL,
         "Exit demo — README links resolve, tests pass in CI"),
        ("Sprint 2", "Ask AI as an AI system", CYAN,
         "Exit demo — Ask AI answering from a real invoice"),
        ("Sprint 3", "The demo loop", VIOLET,
         "Exit demo — the Capstone video, ID on camera"),
    ]
    y = 3.58
    for i, (name, goal, col, exit_demo) in enumerate(rows):
        x = ax_l + span * i / 3 + 0.08
        text(s, M, y + 0.14, 1.95, 0.30, name, size=11.5, bold=True, color=col,
             font=DISPLAY, track=0.8, caps=True)
        bar = round_rect(s, x, y, bar_w, 0.58, col, radius=0.30)
        alpha(bar, 0.22)
        text(s, x + 0.22, y, bar_w - 0.44, 0.58, goal, size=10.5, bold=True, color=WHITE,
             anchor=MSO_ANCHOR.MIDDLE)
        oval(s, x + bar_w - 0.15, y + 0.17, 0.24, 0.24, col)
        text(s, x + 0.08, y + 0.62, min(bar_w + 1.4, SW - M - x - 0.08), 0.30,
             exit_demo, size=9, color=DIM)
        y += 1.10

    notes(s, """
[18:10–18:45] "Three sprints across twelve weeks, four weeks each, starting 20 August and
finishing 14 November. Each bar ends in a diamond, which is the sprint review — a screen
recording demonstrating the increment to the Product Owner.
I know I am both the developer and the Product Owner. I still ran the ceremony properly:
each increment was explicitly accepted or rejected before the next sprint was planned, and
the board reflects that."
""")


def s31_sprints():
    s = D.page()
    head(s, "Sprint detail", "What was planned, delivered and demonstrated", tsize=29)
    sprints = [
        ("Sprint 1", "20 Aug – 17 Sep", "Grader-ready engineering", TEAL, [
            "docs/capstone/ written: design and testing, stories, sprint plan",
            "GitHub Project and capstone-labelled issues",
            "Secrets, keystores and .env moved into .gitignore",
            "New unit suites: plan gates, money, outbox",
            "npm test wired into the CI workflow",
        ]),
        ("Sprint 2", "18 Sep – 16 Oct", "CLIVORA as an AI system", CYAN, [
            "Retrieval over crm_embeddings in the Ask AI route",
            "Opt-in indexing endpoint so saves stay untouched",
            "crm-rag unit tests: chunking, sanitisation, no invented amounts",
            "Written eval set in ASK_AI_EVAL.md",
            "Human-review gate: auto_pay and auto_publish forbidden",
        ]),
        ("Sprint 3", "17 Oct – 14 Nov", "One loop, end to end", VIOLET, [
            "Scripted hire → project → timesheet → invoice → paid",
            "Client-side verification on a second real account",
            "Demo script committed so the run is repeatable",
            "This deck, speaker notes and the recorded walkthrough",
            "Final submission package for Quantic",
        ]),
    ]
    cwid = (CW - 2 * 0.30) / 3
    for i, (name, dates, goal, col, items) in enumerate(sprints):
        x = M + i * (cwid + 0.30)
        b = round_rect(s, x, BODY_TOP, cwid, 4.10, SURF, col, radius=0.05, lw=1.0)
        alpha(b, 0.14)
        pill(s, x + 0.26, BODY_TOP + 0.24, 1.55, 0.30, name, INK, col, None, size=8.5)
        text(s, x + 1.92, BODY_TOP + 0.24, 1.9, 0.30, dates, size=8.5, color=MUTE,
             anchor=MSO_ANCHOR.MIDDLE, track=0.6)
        text(s, x + 0.26, BODY_TOP + 0.68, cwid - 0.52, 0.38, goal, size=13.5, bold=True,
             color=WHITE, font=DISPLAY)
        bullets(s, x + 0.26, BODY_TOP + 1.22, cwid - 0.52, items, size=9.5, gap=0.56,
                accent=col)

    notes(s, """
[18:45–19:20] Pick one item per sprint, not all fifteen.
"Sprint 1's most useful story was wiring npm test into CI — the web tests existed, but
nothing forced them to run, so they were decoration. Sprint 2's was the opt-in indexing
endpoint, because it let me add retrieval without touching the invoice save path. Sprint 3's
was committing the demo script, so the loop I am about to show is repeatable rather than
lucky."
""")


def s32_board():
    s = D.page()
    head(s, "Working agreement", "The board and the definition of done", tsize=29)

    rail_label(s, M, 2.78, 5.6, "Definition of done — every story", TEAL)
    b = round_rect(s, M, 3.20, 5.85, 3.20, SURF, TEAL, radius=0.05, lw=1.0)
    alpha(b, 0.14)
    bullets(s, M + 0.30, 3.46, 5.30, [
        "Code on main, or in a pull request into main",
        "Tests added or updated whenever the behaviour is testable",
        "Board card moved to Done — not left in progress",
        "No secrets committed, verified before push",
        "Baseline features never relabelled as new Capstone work",
    ], size=10.5, gap=0.56, accent=TEAL)

    x2 = M + 6.35
    rail_label(s, x2, 2.78, 5.6, "Collaborative tooling", VIOLET)
    tools = [
        ("GitHub Issues + Project", "Labels capstone, sprint-1/2/3. Public board for graders."),
        ("GitHub Actions", "CI on every push; tag-driven Android release jobs."),
        ("Hostinger", "Continuous delivery target for the web app."),
        ("Google Play Console", "Android distribution and release tracks."),
        ("Google Drive", "Final demo recording, shared with link access."),
    ]
    y = 3.20
    for name, desc in tools:
        bb = round_rect(s, x2, y, 5.85, 0.60, SURF, LINE, radius=0.04)
        alpha(bb, 0.18)
        text(s, x2 + 0.26, y + 0.08, 2.5, 0.26, name, size=10.5, bold=True, color=WHITE)
        text(s, x2 + 0.26, y + 0.32, 5.3, 0.24, desc, size=9, color=DIM)
        y += 0.68

    notes(s, """
[19:20–19:45] "The definition of done was written before Sprint 1 and did not move.
Two clauses are unusual and both are deliberate. 'No secrets committed' is a done criterion,
not a code review nicety, because this repository is public for grading. And the last one —
baseline features are never relabelled as Capstone work — is what stops a solo project from
quietly inflating its own scope."
""")


# ------------------------------------------------------------ demo, close ----

def s34_loop():
    s = D.page()
    head(s, "Section 05 · live demo", "The loop I am about to run", tsize=29,
         sub="One continuous path from a posted job to a paid invoice, across two real accounts.")

    steps = [
        ("Client posts", "a job on Connect", TEAL),
        ("Freelancer proposes", "browse, then send", CYAN),
        ("Mutual accept", "contact unlocked", BLUE),
        ("Project created", "tasks + timesheet", VIOLET),
        ("Invoice issued", "from tracked time", AMBER),
        ("Marked paid", "branded PDF, $0 fee", GREEN),
    ]
    n = len(steps)
    w = (CW - 0.30 * (n - 1)) / n
    for i, (h, sub, col) in enumerate(steps):
        x = M + i * (w + 0.30)
        b = round_rect(s, x, 3.10, w, 1.32, SURF2, col, radius=0.09, lw=1.0)
        alpha(b, 0.16)
        oval(s, x + w / 2 - 0.17, 3.28, 0.34, 0.34, col)
        text(s, x + w / 2 - 0.17, 3.335, 0.34, 0.26, f"{i+1}", size=10, bold=True,
             color=INK, align=PP_ALIGN.CENTER)
        text(s, x + 0.10, 3.74, w - 0.20, 0.32, h, size=11, bold=True, color=WHITE,
             font=DISPLAY, align=PP_ALIGN.CENTER, spacing=1.06)
        text(s, x + 0.08, 4.06, w - 0.16, 0.28, sub, size=8.5, color=DIM,
             align=PP_ALIGN.CENTER)
        if i < n - 1:
            arrow_r(s, x + w + 0.035, 3.685, 0.23, 0.17, col, 0.35)

    y = 4.82
    cols = [
        ("Two real accounts", "A freelancer account and a separate client account, both signed in. "
         "Nothing is faked with a demo flag.", TEAL),
        ("Both clients", "Part of the loop runs in the browser on clivora.io and part on the Android "
         "build, against the same rows.", CYAN),
        ("What I will not claim", "Payment is recorded, not processed. There is no live Stripe or "
         "escrow, and I will say so on screen.", ROSE),
    ]
    cwid = (CW - 2 * 0.32) / 3
    for i, (h, b, c) in enumerate(cols):
        x = M + i * (cwid + 0.32)
        box = round_rect(s, x, y, cwid, 1.42, SURF, c, radius=0.05, lw=1.0)
        alpha(box, 0.14)
        rect(s, x, y, 0.045, 1.42, c)
        text(s, x + 0.28, y + 0.20, cwid - 0.56, 0.30, h, size=12, bold=True, color=WHITE,
             font=DISPLAY)
        text(s, x + 0.28, y + 0.56, cwid - 0.56, 0.76, b, size=10, color=DIM, spacing=1.26)

    notes(s, """
[19:45–20:15] Set expectations before you share the screen.
"Six steps, two accounts, both clients. I will post a job as the client, propose as the
freelancer, accept from both sides so the contact unlocks, turn it into a project with
tracked time, raise the invoice from that time, and mark it paid.
One honest caveat, and I will repeat it on screen: payment here is recorded, not processed.
There is no live Stripe and no escrow in CLIVORA. Saying otherwise would be the easiest way
to lose credibility."
NOW SWITCH TO THE LIVE PRODUCT. Follow docs/capstone/DEMO_SCRIPT.md. Budget 5–6 minutes.
""")


def s35_results():
    s = D.page()
    head(s, "Where this landed", "Results and the evidence behind each claim", tsize=29)

    metrics = [
        ("8", "Automated suites running in CI", TEAL),
        ("2", "Native clients on one shared record", CYAN),
        ("3", "Sprints, planned and demonstrated", VIOLET),
        ("$0", "Platform fee on a Connect deal", GREEN),
    ]
    sw_ = (CW - 3 * 0.30) / 4
    for i, (v, l, c) in enumerate(metrics):
        stat(s, M + i * (sw_ + 0.30), BODY_TOP, sw_, v, l, accent=c, value_size=34, h=1.34)

    y = BODY_TOP + 1.64
    rail_label(s, M, y, 5.6, "Delivered in the increment", GREEN)
    bullets(s, M, y + 0.42, 5.85, [
        "Repository a grader can navigate: design and testing doc, stories, sprint plan",
        "CI enforcing web tests, not just building the app",
        "Ask AI grounded in the user's own CRM, with a written eval set",
        "A hire-to-invoice loop that runs from a committed script",
    ], size=10.5, gap=0.62, accent=GREEN)

    x2 = M + 6.35
    rail_label(s, x2, y, 5.6, "Open, and tracked honestly", AMBER)
    bullets(s, x2, y + 0.42, 5.85, [
        "QA-001: web end-to-end journeys still need Playwright coverage",
        "Outbox behaviour under process death and account switch is untested",
        "match_crm_embeddings SQL is in the repo, not yet applied in production",
        "Payments are recorded, not processed — no live gateway",
    ], size=10.5, gap=0.62, accent=AMBER)

    notes(s, """
[20:15–20:45] Claim the wins, then own the gaps. Graders trust the second list.
"Four numbers on top. Eight automated suites in CI, two native clients on one record, three
sprints demonstrated, and zero platform fee on a Connect deal.
On the left, what actually shipped. On the right, what is still open — and I want to be
explicit about these because they are in the repository, not hidden. Web end-to-end coverage
is my largest remaining risk. The outbox is untested under process death. The vector-match
SQL exists but has not been applied to production. And payments are recorded, not processed."
""")


def s36_submission():
    s = D.page()
    head(s, "Submission", "What goes into Quantic, and in which of the two buttons",
         tsize=28,
         sub="The most common way to lose marks here is uploading the deck into the presentation slot.")

    left = round_rect(s, M, BODY_TOP, 5.85, 2.70, SURF, TEAL, radius=0.05, lw=1.0)
    alpha(left, 0.14)
    pill(s, M + 0.30, BODY_TOP + 0.24, 2.15, 0.32, "Button 1 · project", INK, TEAL, None, size=8.5)
    text(s, M + 0.30, BODY_TOP + 0.72, 5.25, 0.34, "Submit the working software",
         size=14, bold=True, color=WHITE, font=DISPLAY)
    bullets(s, M + 0.30, BODY_TOP + 1.16, 5.25, [
        f"Live product: https://{LIVE}",
        f"Repository: https://{REPO}",
        "Agile board: Issues filtered by the capstone label",
        "Design and testing: docs/capstone/DESIGN_AND_TESTING.md",
    ], size=10.5, gap=0.40, accent=TEAL)

    right = round_rect(s, M + 6.35, BODY_TOP, 5.85, 2.70, SURF, VIOLET, radius=0.05, lw=1.0)
    alpha(right, 0.14)
    pill(s, M + 6.65, BODY_TOP + 0.24, 2.55, 0.32, "Button 2 · presentation", INK, VIOLET,
         None, size=8.5)
    text(s, M + 6.65, BODY_TOP + 0.72, 5.25, 0.34, "Submit the video, not the slides",
         size=14, bold=True, color=WHITE, font=DISPLAY)
    bullets(s, M + 6.65, BODY_TOP + 1.16, 5.25, [
        "15–20 minute recording, photo ID shown on camera",
        "Uploaded to Google Drive with link access for anyone",
        "Group Project Agreement attached",
        "Share the repository with the grader account",
    ], size=10.5, gap=0.40, accent=VIOLET)

    y = BODY_TOP + 3.00
    warn = round_rect(s, M, y, CW, 0.80, SURF, ROSE, radius=0.05, lw=1.25)
    alpha(warn, 0.12)
    rect(s, M, y, 0.05, 0.80, ROSE)
    text(s, M + 0.30, y, CW - 0.60, 0.80,
         "Do not upload this PPTX, its PDF or a ZIP as the presentation. The presentation "
         "submission is the video link. This deck is a speaking aid only.",
         size=11.5, bold=True, color=ROSE, anchor=MSO_ANCHOR.MIDDLE)

    notes(s, """
[20:45–21:10] Read the red band out loud — it is a reminder to yourself as much as to the
grader. "Two buttons. The project button takes the live product, the repository, the board
and the design and testing document. The presentation button takes the video link, not
these slides."
Before you submit: confirm the Drive link opens in a private browser window, and confirm
the grader account has read access to the repository.
""")


def s37_close():
    s = D.bare()
    glow(s, 11.2, 5.8, 8.0, VIOLET, 0.88)
    glow(s, 1.6, 1.4, 6.0, TEAL, 0.90)
    brandbar(s, D.n, TOTAL)
    pic_h(s, "app-invoice-paid.png", 9.55, 1.55, 5.30, rot=6)

    kicker(s, "Thank you", TEAL, y=1.80)
    title(s, "Discover the work.\nDo the work.\nOwn the momentum.", size=40, y=2.16, w=7.4)
    accent_rule(s, M, 4.86, 1.35, 0.06)
    text(s, M, 5.12, 6.6, 0.66,
         "Usman Ghias · Product Owner, Scrum Master and engineer · CODCrafters\n"
         "Happy to take questions on the architecture, the sprint record or the open risks.",
         size=12, color=DIM, spacing=1.32)
    rows = [("Live", f"https://{LIVE}"), ("Repository", f"https://{REPO}"),
            ("Design + testing", "docs/capstone/DESIGN_AND_TESTING.md")]
    y = 6.02
    for k, v in rows:
        text(s, M, y, 1.7, 0.26, k, size=9, color=MUTE, track=1.0, caps=True)
        text(s, M + 1.80, y, 5.0, 0.26, v, size=10.5, bold=True, color=TEAL)
        y += 0.34

    notes(s, """
[21:10–21:30] Close on the campaign line, then stop talking.
"Discover the work. Do the work. Own the momentum. That is the product thesis and it is also
what these three sprints were for. Thank you — I am happy to take questions on the
architecture, the sprint record, or the open risks."
Do not add new content after this. End the recording.
""")


# ------------------------------------------------------------- appendix -----

def s38_roadmap():
    s = D.page()
    head(s, "Appendix · not presented", "Roadmap after the Capstone", tsize=29,
         sub="Ranked by the risk it removes, not by how impressive it demos.")
    items = [
        ("Next", "Playwright end-to-end suite", "Closes QA-001: login, Connect accept, invoice share.", GREEN),
        ("Next", "Outbox resilience tests", "Process death and account switch under Flutter integration tests.", GREEN),
        ("Then", "Apply match_crm_embeddings", "Vector search in a maintenance window, behind a flag.", CYAN),
        ("Then", "Ask AI citations in the UI", "Show the invoice or client each sentence came from.", CYAN),
        ("Later", "Payments", "A real gateway, only when it can be operated and supported properly.", VIOLET),
        ("Later", "iOS", "Same Flutter codebase, once Android retention justifies the review overhead.", VIOLET),
    ]
    cwid = (CW - 2 * 0.30) / 3
    for i, (when, h, b, c) in enumerate(items):
        col_i, row_i = i % 3, i // 3
        x = M + col_i * (cwid + 0.30)
        y = BODY_TOP + row_i * 2.06
        box = round_rect(s, x, y, cwid, 1.82, SURF, LINE, radius=0.05)
        alpha(box, 0.14)
        pill(s, x + 0.28, y + 0.24, 1.15, 0.28, when, INK, c, None, size=8)
        text(s, x + 0.28, y + 0.66, cwid - 0.56, 0.40, h, size=12.5, bold=True,
             color=WHITE, font=DISPLAY, spacing=1.10)
        text(s, x + 0.28, y + 1.12, cwid - 0.56, 0.58, b, size=10, color=DIM, spacing=1.26)
    notes(s, "Appendix. Only open this if a grader asks what comes next.")


def s39_gtm():
    s = D.page()
    head(s, "Appendix · not presented", "Go-to-market artefacts already produced", tsize=28,
         sub="Included because the handbook rewards a product, not only a repository.")
    framed_pic(s, "v2-momentum.png", M, 2.70, 2.55, pad=0.05)
    framed_pic(s, "play-02.png", M + 2.95, 2.70, 2.20, pad=0.05)

    x = M + 5.65
    rows = [
        ("Premium Campaign V2", "Five editorial creatives, a 20-second vertical film and an original 102 BPM soundtrack."),
        ("Marketing launch kit", "65 assets: square, portrait, story and landscape adaptations, paid-ad variants, WhatsApp statuses."),
        ("Google Play listing", "Feature graphic and four store screenshots, all generated from real product screens."),
        ("Keyword research", "126 ranked search terms across freelancer, CRM, invoicing and project-management intent."),
        ("Publishing calendar", "A seven-day launch sequence with per-platform captions and a fixed posting order."),
    ]
    kv_rows(s, x, 2.86, 12.10 - x + 0.62, rows, key_w=2.6, size=10, gap=0.72)
    notes(s, "Appendix. Evidence that CLIVORA is a product with a launch, not a class exercise.")


def s40_checklist():
    s = D.page()
    head(s, "Appendix · pre-recording checklist", "Run this list before you hit record",
         tsize=28)
    groups = [
        ("Before recording", [
            "Photo ID physically in hand",
            "1920x1080 screen, notifications silenced",
            "Freelancer and client accounts both signed in",
            "Demo data reset per DEMO_SCRIPT.md",
            "This deck open in presenter view with notes",
        ], TEAL),
        ("During recording", [
            "Show ID and say your full name in the first minute",
            "Say the word baseline when showing pre-Capstone features",
            "Never claim Stripe or escrow is live",
            "Run the whole loop without cutting the recording",
            "Stay inside 20 minutes",
        ], CYAN),
        ("After recording", [
            "Upload to Google Drive, anyone-with-link access",
            "Test the link in a private browser window",
            "Attach the Group Project Agreement",
            "Give the grader account read access to the repo",
            "Submit both buttons — project and presentation",
        ], VIOLET),
    ]
    cwid = (CW - 2 * 0.32) / 3
    for i, (name, items, col) in enumerate(groups):
        x = M + i * (cwid + 0.32)
        b = round_rect(s, x, BODY_TOP, cwid, 3.70, SURF, col, radius=0.05, lw=1.0)
        alpha(b, 0.14)
        rect(s, x, BODY_TOP, 0.045, 3.70, col)
        text(s, x + 0.30, BODY_TOP + 0.26, cwid - 0.60, 0.34, name, size=13.5, bold=True,
             color=col, font=DISPLAY)
        bullets(s, x + 0.30, BODY_TOP + 0.80, cwid - 0.60, items, size=10.5, gap=0.58,
                accent=col)
    notes(s, "Appendix. Read this immediately before recording. Do not present it.")


# ------------------------------------------------------------------ build ----

def main() -> int:
    s01_cover()
    s02_agenda()
    s03_scope()

    divider("01", "Section one", "The problem",
            "Not another marketplace. A connected way to move independent work forward.",
            "v2-not-marketplace.png", TEAL)
    s05_problem()
    s06_users()

    divider("02", "Section two", "The product",
            "Work should feel connected — for freelancers, independent teams and clients.",
            "v2-connected.png", CYAN)
    s08_modules()
    s09_web()
    s10_loop()
    s11_connect()
    s12_client()
    s13_android_a()
    s14_android_b()
    s15_android_c()
    s16_automation()
    s17_one_account()

    divider("03", "Section three", "Engineering",
            "From first brief to final invoice — one auditable record behind every screen.",
            "v2-brief-invoice.png", BLUE)
    s19_architecture()
    s20_outbox()
    s21_security()
    s22_patterns()
    s23_money()
    s24_ai()
    s25_testing()
    s26_cicd()
    s27_deploy()

    divider("04", "Section four", "Agile process",
            "Do the work. Own the momentum. Three sprints, planned and demonstrated.",
            "v2-momentum.png", VIOLET)
    s29_baseline()
    s30_timeline()
    s31_sprints()
    s32_board()

    divider("05", "Section five", "Live demo",
            "The next opportunity is the start — and the invoice is the proof.",
            "v2-opportunity.png", TEAL)
    s34_loop()
    s35_results()
    s36_submission()
    s37_close()

    s38_roadmap()
    s39_gtm()
    s40_checklist()

    out = D.save()
    print(f"{D.n} slides -> {out} ({out.stat().st_size/1_048_576:.1f} MB)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
