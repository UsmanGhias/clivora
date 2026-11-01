#!/usr/bin/env python3
"""Generate editable Word documents for Odoo Manufacturing credentials deck."""

from docx import Document
from docx.shared import Pt, Inches, RGBColor, Cm
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_LINE_SPACING
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml.ns import qn
from docx.oxml import OxmlElement


NAVY = RGBColor(0x1A, 0x27, 0x44)
STEEL = RGBColor(0x4A, 0x6F, 0xA5)
ACCENT = RGBColor(0x3D, 0x5A, 0x80)
TEXT = RGBColor(0x2D, 0x37, 0x48)
MUTED = RGBColor(0x5A, 0x65, 0x78)
WHITE = RGBColor(0xFF, 0xFF, 0xFF)


def set_cell_shading(cell, hex_color: str):
    shading = OxmlElement('w:shd')
    shading.set(qn('w:fill'), hex_color)
    shading.set(qn('w:val'), 'clear')
    cell._tc.get_or_add_tcPr().append(shading)


def set_cell_margins(cell, top=80, bottom=80, left=120, right=120):
    tc = cell._tc
    tcPr = tc.get_or_add_tcPr()
    tcMar = OxmlElement('w:tcMar')
    for side, val in [('top', top), ('bottom', bottom), ('start', left), ('end', right)]:
        node = OxmlElement(f'w:{side}')
        node.set(qn('w:w'), str(val))
        node.set(qn('w:type'), 'dxa')
        tcMar.append(node)
    tcPr.append(tcMar)


def add_page_break(doc):
    doc.add_page_break()


def style_paragraph(p, size=11, bold=False, italic=False, color=TEXT, align=None, space_after=6, space_before=0):
    p.paragraph_format.space_after = Pt(space_after)
    p.paragraph_format.space_before = Pt(space_before)
    p.paragraph_format.line_spacing_rule = WD_LINE_SPACING.MULTIPLE
    p.paragraph_format.line_spacing = 1.15
    if align is not None:
        p.alignment = align
    if p.runs:
        run = p.runs[0]
    else:
        run = p.add_run()
    run.font.size = Pt(size)
    run.font.bold = bold
    run.font.italic = italic
    run.font.color.rgb = color
    run.font.name = 'Calibri'
    return run


def add_heading(doc, text, level=1):
    p = doc.add_paragraph()
    if level == 1:
        run = p.add_run(text)
        run.font.size = Pt(16)
        run.font.bold = True
        run.font.color.rgb = NAVY
        run.font.name = 'Georgia'
        p.paragraph_format.space_before = Pt(18)
        p.paragraph_format.space_after = Pt(8)
        # bottom border effect via spacing
    elif level == 2:
        run = p.add_run(text)
        run.font.size = Pt(12)
        run.font.bold = True
        run.font.color.rgb = ACCENT
        run.font.name = 'Georgia'
        p.paragraph_format.space_before = Pt(12)
        p.paragraph_format.space_after = Pt(4)
    else:
        run = p.add_run(text)
        run.font.size = Pt(11)
        run.font.bold = True
        run.font.color.rgb = NAVY
        run.font.name = 'Calibri'
        p.paragraph_format.space_before = Pt(8)
        p.paragraph_format.space_after = Pt(4)
    return p


def add_body(doc, text, italic=False, muted=False):
    p = doc.add_paragraph()
    run = p.add_run(text)
    run.font.size = Pt(11)
    run.font.name = 'Calibri'
    run.font.italic = italic
    run.font.color.rgb = MUTED if muted else TEXT
    p.paragraph_format.space_after = Pt(6)
    p.paragraph_format.line_spacing_rule = WD_LINE_SPACING.MULTIPLE
    p.paragraph_format.line_spacing = 1.15
    return p


def add_bullet(doc, text, bold_prefix=None):
    p = doc.add_paragraph(style='List Bullet')
    p.paragraph_format.space_after = Pt(3)
    p.paragraph_format.left_indent = Cm(0.5)
    if bold_prefix:
        r1 = p.add_run(bold_prefix)
        r1.bold = True
        r1.font.size = Pt(11)
        r1.font.name = 'Calibri'
        r1.font.color.rgb = TEXT
        r2 = p.add_run(text)
        r2.font.size = Pt(11)
        r2.font.name = 'Calibri'
        r2.font.color.rgb = TEXT
    else:
        run = p.add_run(text)
        run.font.size = Pt(11)
        run.font.name = 'Calibri'
        run.font.color.rgb = TEXT
    return p


def add_numbered(doc, text):
    p = doc.add_paragraph(style='List Number')
    p.paragraph_format.space_after = Pt(4)
    run = p.add_run(text)
    run.font.size = Pt(11)
    run.font.name = 'Calibri'
    run.font.color.rgb = TEXT
    return p


def add_table(doc, headers, rows, col_widths=None):
    table = doc.add_table(rows=1 + len(rows), cols=len(headers))
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    table.style = 'Table Grid'

    hdr_cells = table.rows[0].cells
    for i, h in enumerate(headers):
        hdr_cells[i].text = ''
        p = hdr_cells[i].paragraphs[0]
        run = p.add_run(h)
        run.bold = True
        run.font.size = Pt(9.5)
        run.font.color.rgb = WHITE
        run.font.name = 'Calibri'
        set_cell_shading(hdr_cells[i], '1A2744')
        set_cell_margins(hdr_cells[i])

    for ri, row in enumerate(rows):
        cells = table.rows[ri + 1].cells
        for ci, val in enumerate(row):
            cells[ci].text = ''
            p = cells[ci].paragraphs[0]
            run = p.add_run(str(val))
            run.font.size = Pt(9.5)
            run.font.name = 'Calibri'
            run.font.color.rgb = TEXT
            set_cell_margins(cells[ci])
            if ri % 2 == 1:
                set_cell_shading(cells[ci], 'F7F9FC')

    if col_widths:
        for row in table.rows:
            for i, w in enumerate(col_widths):
                row.cells[i].width = Inches(w)

    doc.add_paragraph()
    return table


def add_highlight_box(doc, title, bullets):
    p = doc.add_paragraph()
    run = p.add_run(title)
    run.bold = True
    run.font.size = Pt(11)
    run.font.color.rgb = NAVY
    run.font.name = 'Calibri'
    p.paragraph_format.space_after = Pt(4)
    for b in bullets:
        add_bullet(doc, b)


def add_case_study(doc, title, tag, challenge, solution, outcome):
    add_heading(doc, title, 2)
    p = doc.add_paragraph()
    r = p.add_run(f'  [{tag}]')
    r.italic = True
    r.font.size = Pt(9)
    r.font.color.rgb = STEEL
    r.font.name = 'Calibri'

    add_heading(doc, 'Challenge', 3)
    add_body(doc, challenge)
    add_heading(doc, 'Solution', 3)
    add_body(doc, solution)
    add_heading(doc, 'Outcome', 3)
    add_body(doc, outcome)
    doc.add_paragraph()


def add_engagement(doc, title, meta, body, bullets, relevance):
    add_heading(doc, title, 2)
    add_body(doc, meta, muted=True)
    add_body(doc, body)
    for b in bullets:
        add_bullet(doc, b)
    p = doc.add_paragraph()
    r1 = p.add_run('Relevance: ')
    r1.bold = True
    r1.italic = True
    r1.font.size = Pt(10)
    r1.font.color.rgb = ACCENT
    r1.font.name = 'Calibri'
    r2 = p.add_run(relevance)
    r2.italic = True
    r2.font.size = Pt(10)
    r2.font.color.rgb = ACCENT
    r2.font.name = 'Calibri'
    doc.add_paragraph()


def setup_document():
    doc = Document()
    for section in doc.sections:
        section.top_margin = Cm(2.0)
        section.bottom_margin = Cm(2.0)
        section.left_margin = Cm(2.0)
        section.right_margin = Cm(2.0)
    return doc


def build_credentials_doc():
    doc = setup_document()

    # COVER
    for _ in range(4):
        doc.add_paragraph()
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run('CODCRAFTERS')
    r.font.size = Pt(10)
    r.font.bold = True
    r.font.color.rgb = STEEL
    r.font.name = 'Calibri'

    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run('Muhammad Usman Khan')
    r.font.size = Pt(26)
    r.font.bold = True
    r.font.color.rgb = NAVY
    r.font.name = 'Georgia'

    for line in ['Odoo Certified Developer', 'Manufacturing ERP Implementation Specialist']:
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p.add_run(line)
        r.font.size = Pt(13)
        r.font.color.rgb = ACCENT
        r.font.name = 'Calibri'

    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run('Discovery-Led Odoo MRP for Multi-Stage Fabrication')
    r.font.size = Pt(11)
    r.font.italic = True
    r.font.color.rgb = MUTED
    r.font.name = 'Calibri'

    doc.add_paragraph()
    for line in [
        'iusmanghias@gmail.com  |  +92 312 691 2440',
        'usmanghias.co.uk  |  github.com/UsmanGhias',
        'Samundri, Punjab, Pakistan  |  Remote Worldwide',
    ]:
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p.add_run(line)
        r.font.size = Pt(10)
        r.font.color.rgb = MUTED
        r.font.name = 'Calibri'

    doc.add_paragraph()
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run('Prepared for')
    r.font.size = Pt(10)
    r.font.color.rgb = MUTED
    r.font.name = 'Calibri'
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run('[Client Company Name]')
    r.font.size = Pt(12)
    r.font.bold = True
    r.font.color.rgb = NAVY
    r.font.name = 'Calibri'

    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run('July 2026')
    r.font.size = Pt(10)
    r.font.color.rgb = MUTED
    r.font.name = 'Calibri'

    add_page_break(doc)

    # EXECUTIVE SUMMARY
    add_heading(doc, 'Executive Summary', 1)
    add_body(doc, 'This document presents my credentials, relevant experience, and proposed approach for your steel container manufacturing Odoo ERP engagement — structured discovery first, configuration second.', muted=True)
    add_body(doc, 'Your operation spans multiple interconnected production stages — material preparation, machining, welding, painting, and assembly — serving waste, construction, and municipal customers with roll-off containers, dumpsters, and custom builds. Replacing manual and spreadsheet-based tracking with Odoo requires more than module installation: it requires accurately translating real shop-floor operations into work centers, routings, BOMs, work orders, and quality checkpoints that your production team will actually use.')
    add_body(doc, 'I specialize in exactly this type of engagement. My approach begins with structured discovery interviews alongside supervisors, machine leads, and administrative staff — documenting workstations, shifts, order flow, and stage-by-stage handoffs before any Odoo configuration begins.')
    add_highlight_box(doc, 'Alignment With Your Project Structure', [
        'Phase 1 — Discovery: Structured interviews, process mapping, and a documented Odoo module/data plan validated against your internal discovery framework.',
        'Phase 2 — Configuration & Rollout: MRP, Inventory, Purchase, Quality, Maintenance, Timesheets, and Barcode setup; data migration; testing; training; and go-live support with realistic adoption planning.',
    ])
    add_table(doc, ['Metric', 'Value'], [
        ['Odoo Implementations', '91+'],
        ['Years Experience', '6+'],
        ['Global Clients', '70+'],
        ['Client Rating', '5.0 / 5.0'],
    ], col_widths=[2.5, 1.5])
    add_body(doc, 'Odoo Certified Developer  |  Upwork Top Rated  |  100% Job Success  |  MSSE @ Quantic, USA', muted=True)

    add_page_break(doc)

    # WHY THIS ENGAGEMENT FITS
    add_heading(doc, 'Why This Engagement Fits', 1)
    add_body(doc, 'Direct mapping of your stated requirements to demonstrated capabilities and deliverables.', muted=True)
    add_table(doc, ['Your Requirement', 'My Evidence & Approach'], [
        ['Structured discovery with production supervisors', '4-week discovery framework; PM experience at Cavi Consulting; personally lead all stakeholder interviews'],
        ['Work centers, routings, BOMs, work orders', 'Partsnord Europe AB (automotive parts); MRP II solution patterns; Product Configurator with dynamic BOM generation'],
        ['Quality checkpoints at production stages', 'Odoo QMS, LIMS, and Batch Manufacturing & Traceability module expertise'],
        ['Maintenance module for equipment', 'CMMS, Predictive Maintenance, and Equipment Rental maintenance tracking implementations'],
        ['Barcode scanning on shop floor', 'Warehouse Automation Suite; Inventory Mastery Suite (13 custom inventory modules)'],
        ['Flexible material consumption (leftover sheet metal reuse)', 'Batch Production, Multi-Warehouse Replenishment, scrap/leftover location rules, alternative component handling'],
        ['KPI dashboards and reporting', 'Plectar engagement: 413+ hours building Odoo Spreadsheet reports; cycle time, utilization, and delivery KPIs'],
        ['Production status pipeline mirroring real stages', 'Car Repair Workshop System — multi-stage job tracking pipeline; direct parallel to your Pending → Shipped workflow'],
        ['Phase 2: second business unit (servicing/upfits)', 'Multi-Company Consolidation; Odoo_Base_Multi_Company module; parallel routing templates'],
        ['Odoo Studio custom fields (gauge, dimensions, weight)', '90+ Odoo custom module builds; OWL, XML, Python — minimal customization principle'],
    ], col_widths=[2.2, 4.3])

    add_heading(doc, 'Implementation Methodology', 2)
    add_body(doc, 'Discovery Interviews  →  Process Map & Odoo Data Plan  →  MRP, Inventory, Purchase, Quality  →  Pilot & UAT  →  Training & Go-Live  →  Post-Live Optimization')

    add_page_break(doc)

    # PROFESSIONAL PROFILE
    add_heading(doc, 'Professional Profile', 1)
    add_body(doc, 'I am a Senior Odoo Developer and ERP Implementation Specialist with 6+ years of experience delivering production-grade Odoo solutions for clients across 25+ countries. As CEO and Founder of CODCrafters, I lead a team that ships enterprise ERP transformations, custom module development, and business process automation.')
    add_body(doc, 'Odoo is my core specialty — 91+ dedicated Odoo projects across versions 15 through 19, spanning Manufacturing (MRP), Inventory, Purchase, Quality, Maintenance, Timesheets, Barcode, Accounting, and custom reporting via Odoo Spreadsheets.')
    add_table(doc, ['Metric', 'Count'], [
        ['Total Projects', '185+'],
        ['Odoo Builds', '91+'],
        ['GitHub Repos', '192'],
        ['Countries Served', '25+'],
    ], col_widths=[2.5, 1.5])
    add_table(doc, ['Credential', 'Details'], [
        ['Odoo Certified Developer', 'Official Odoo certification — custom modules, enterprise implementations, OWL framework'],
        ['Upwork Top Rated', '100% Job Success Score, 5.0/5.0 overall rating across 70+ clients'],
        ['MSSE — Quantic School of Business & Technology', 'Master of Software Systems Engineering, Washington D.C., USA (in progress)'],
        ['CEO & Founder — CODCrafters', 'Software agency delivering Odoo ERP, full-stack, and AI-powered solutions globally'],
        ['GitHub — 192 Public Repositories', 'github.com/UsmanGhias — Odoo modules, integrations, and open-source contributions'],
    ], col_widths=[2.0, 4.5])
    add_heading(doc, 'Core Competencies', 2)
    for b in [
        'Odoo Manufacturing (MRP) — work centers, routings, BOMs, work orders',
        'Inventory & warehouse management with barcode operations',
        'Quality management — inspection points, NC tracking, CAPA workflows',
        'Maintenance (CMMS) — preventive schedules, downtime tracking',
        'Business process discovery and documentation',
        'Odoo Spreadsheets — dynamic KPI dashboards and reporting',
        'Python, PostgreSQL, XML, OWL, JavaScript, REST/XML-RPC APIs',
        'ERP integrations — QuickBooks, DocuSign, n8n automation',
    ]:
        add_bullet(doc, b)

    add_page_break(doc)

    # CURRENT ENGAGEMENTS
    add_heading(doc, 'Current & Recent Engagements', 1)
    add_body(doc, 'Named client references demonstrating active, relevant Odoo manufacturing and reporting experience.', muted=True)

    add_engagement(doc, 'Partsnord Europe AB — Senior Odoo Developer',
        'October 2025 – Present  |  Europe (Remote)  |  Full-time',
        'Senior Odoo Developer specializing in enterprise-level implementations and custom module development for the automotive parts industry.',
        ['Leading enterprise-level Odoo implementations for discrete manufacturing environments',
         'Developing custom Odoo modules tailored to automotive parts production workflows',
         'Managing technical architecture and coordinating development teams'],
        'Discrete manufacturing, parts inventory, production-adjacent ERP — directly applicable to your multi-stage fabrication environment.')

    add_engagement(doc, 'Plectar — Odoo Spreadsheet Reporting Expert',
        'December 2025 – Present  |  Remote  |  413+ hours delivered at $24/hr',
        'Long-running engagement building dynamic, data-driven reporting on top of the Odoo Spreadsheet module.',
        ['Designed advanced data models and complex logic for reusable KPI reports',
         'Built management dashboards for operational decision-making inside Odoo',
         'Consistently rated 5.0/5.0 for technical proficiency, communication, and efficiency'],
        'Direct match to your KPI dashboard requirements — on-time delivery, cycle time, utilization, and material usage reporting.')

    add_engagement(doc, 'Hunter — Odoo Expert',
        'December 2025 – Present  |  Remote  |  Contract',
        'Providing expert Odoo consultation and development services. Specializing in ERP customization, business process optimization, and system integration.',
        [],
        'ERP customization and process optimization across varied manufacturing and operations contexts.')

    add_engagement(doc, 'Cavi Consulting — Odoo Project Manager & Developer',
        'August 2025 – Present  |  Austria (Remote)  |  Part-time',
        'Senior Odoo Project Manager and Developer managing enterprise Odoo implementations with AI integration.',
        ['Managing enterprise Odoo implementations with AI integration',
         'Leading development teams in AI-powered Odoo solutions',
         'Coordinating project delivery, stakeholder communication, and rollout planning'],
        'Project management and enterprise rollout experience — critical for your phased discovery-to-go-live engagement.')

    add_engagement(doc, 'Sisters Code — Odoo Web Development',
        'October 2025  |  United States (Remote)  |  Freelance',
        'Complete Odoo implementation from start to finish with custom Odoo web modules.',
        ['End-to-end Odoo implementation — discovery through go-live',
         'Custom Odoo web module development using OWL framework',
         'Full stakeholder engagement and training delivery'],
        'Demonstrates ability to own full implementation lifecycle independently.')

    add_highlight_box(doc, 'Engagement Model', [
        'Solo lead: I personally conduct all discovery interviews and lead configuration.',
        'CODCrafters bench: Additional developers available for parallel configuration or data migration if scope expands.',
    ])

    add_page_break(doc)

    # CASE STUDIES
    add_heading(doc, 'Manufacturing-Relevant Case Studies', 1)
    add_body(doc, 'Selected engagements demonstrating discrete manufacturing, job-shop tracking, and operational reporting capabilities.', muted=True)

    add_case_study(doc, 'Automotive Parts — Discrete Manufacturing', 'Partsnord Europe AB',
        'A European automotive parts manufacturer needed to coordinate multi-SKU parts production, maintain inventory accuracy across warehouses, and replace fragmented manual tracking with a centralized ERP system.',
        'Led Odoo MRP-adjacent configuration including work center setup, production routings, purchase and inventory integration, and custom module development tailored to automotive parts workflows.',
        'Centralized production visibility across the operation. Reduced reliance on manual tracking and spreadsheet-based coordination. Established a scalable Odoo architecture supporting ongoing module expansion.')

    add_case_study(doc, 'Car Repair Workshop System', 'Automotive · Job-Shop',
        'An automotive repair chain was losing revenue to manual job card tracking, incorrect billing, and slow customer communication. No real-time visibility into job status across multiple service bays.',
        'Delivered a custom Odoo workshop module with real-time job card tracking, multi-stage status pipeline, automated invoicing, and customer SMS notifications.',
        'Significantly faster invoice processing with near-elimination of manual billing errors. Direct parallel to your production pipeline: Pending → stage transitions → Ready to Ship → Shipped.')

    add_case_study(doc, 'Odoo Spreadsheet KPI Reporting', 'Plectar',
        'Management relied on reporting systems outside Odoo, resulting in inconsistent KPIs, delayed decision-making, and duplicated data entry.',
        'Built dynamic Odoo Spreadsheet reports with advanced data models. Migrated the client\'s entire internal reporting infrastructure into Odoo.',
        'Management dashboards now live inside Odoo with real-time data. Client consistently rates engagement 5.0/5.0 across 413+ delivered hours.')

    add_heading(doc, 'Supporting Module Expertise', 2)
    add_table(doc, ['Module / Solution', 'Capability'], [
        ['Material Requirements Planning (MRP II)', 'Capacity planning, master scheduling, demand forecasting'],
        ['Warehouse Automation Suite', 'Barcode scanning, automated picking, smart routing'],
        ['Quality Management System (QMS)', 'ISO compliance, non-conformance handling, CAPA workflows'],
        ['Maintenance Management (CMMS)', 'Preventive maintenance, spare parts tracking, downtime analysis'],
        ['Batch Manufacturing & Traceability', 'Batch genealogy, quality hold management, scrap tracking'],
        ['Product Configurator', 'Dynamic BOM generation from product options'],
        ['Inventory Mastery Suite', '13 custom modules: real-time tracking, warehouse control'],
        ['Job Costing Management', 'Make-to-order job costing, material and labor allocation'],
        ['Material Purchase Requisition', 'Material requisition workflows from shop floor to purchasing'],
    ], col_widths=[2.8, 3.7])

    add_page_break(doc)

    # DISCOVERY METHODOLOGY
    add_heading(doc, 'Discovery Methodology', 1)
    add_body(doc, 'My approach to running discovery with non-technical shop floor staff — structured, respectful of operational expertise, and designed to produce actionable Odoo configuration blueprints.', muted=True)
    add_table(doc, ['Week', 'Activities', 'Stakeholders', 'Deliverable'], [
        ['1', 'Facility walkthrough, order-to-ship shadowing', 'Production supervisors, shift leads', 'Current-state process swimlanes'],
        ['2', 'Workstation interviews — one session per production stage', 'Machine leads, welders, paint crew, assembly', 'Work center map with capacity per station'],
        ['3', 'BOM and material deep dive; purchasing workflows; QC points', 'Admin staff, purchasing, QC team', 'BOM structure + consumption rules (incl. leftover sheet reuse)'],
        ['4', 'Reporting requirements workshop; adoption planning; pilot selection', 'Management, floor representatives', 'Odoo data model blueprint + phased rollout plan'],
    ], col_widths=[0.5, 2.2, 1.8, 2.0])

    add_heading(doc, 'Interview Principles', 2)
    for b in [
        'Shop-floor language first — document how supervisors describe their work; translate to Odoo afterward',
        'Photo and sketch workstations during walkthroughs to anchor work center definitions',
        'Validate with a pilot product line before configuring all routings and BOMs',
        'Document exceptions explicitly — leftover sheet metal reuse, rush orders, rework loops',
        'Sign-off gate — no MRP configuration begins until discovery documentation is approved',
        'Respect existing workflows — gradual adoption rather than overnight process overhaul',
    ]:
        add_bullet(doc, b)

    add_heading(doc, 'Your Production Stage Mapping', 2)
    add_body(doc, 'Pending → Preparing Material → Machineshop → Building → Prep & Coating → Ready to Ship → Shipped')
    add_body(doc, '+ Accounting status: Open Balance / Released  |  + Delivery confirmation status', muted=True)
    add_body(doc, 'Odoo mapping: Each stage becomes a routing operation on the manufacturing order, with assigned work centers, expected duration, quality checkpoints, barcode scan events, and labor time recording via timesheets.')

    add_page_break(doc)

    # TECHNICAL APPROACH
    add_heading(doc, 'Proposed Technical Approach', 1)
    add_body(doc, 'Configuration plan tailored to steel container manufacturing — roll-off containers, dumpsters, and custom builds.', muted=True)

    add_heading(doc, 'Manufacturing (MRP)', 2)
    for b in [
        'Work centers defined per real station — material prep, CNC/machining, welding bays, paint booth, assembly',
        'Routings per product family: standard roll-off, dumpster, and custom build',
        'BOMs structured by material type: steel sheets (with gauge tracking), structural parts, purchased hardware, consumables',
        'Flexible consumption rules for leftover sheet metal — scrap/leftover locations, alternative component rules',
        'Capacity planning per work center with shift-aware scheduling',
    ]:
        add_bullet(doc, b)

    add_heading(doc, 'Inventory & Warehouse', 2)
    for b in [
        'Multi-location warehouse: raw steel, WIP per stage, finished goods, scrap/leftover inventory',
        'Barcode operations for material issue, WO start/stop, inter-stage transfers, shipping',
        'Lot tracking for steel batches and traceability through production stages',
        'Automated replenishment rules for consumables and purchased hardware',
    ]:
        add_bullet(doc, b)

    add_heading(doc, 'Quality, Maintenance & Labor', 2)
    for b in [
        'Quality checkpoints at weld inspection, coating test, and final assembly — with NC tracking',
        'Maintenance module — equipment registry tied to work centers, PM schedules, downtime recording',
        'Timesheets — labor cost allocation per work order and work center',
    ]:
        add_bullet(doc, b)

    add_heading(doc, 'Custom Fields (Odoo Studio)', 2)
    for b in [
        'Steel gauge, dimensions (L×W×H), weight per job — via Studio with minimal customization',
        'Use standard Odoo fields wherever possible; Studio only for industry-specific attributes',
    ]:
        add_bullet(doc, b)

    add_heading(doc, 'Reporting & Dashboards', 2)
    for b in [
        'On-time delivery performance', 'Cycle time per production stage', 'Work center utilization rates',
        'Scrap and defect rates by stage', 'Labor efficiency per work order', 'Material usage vs. BOM variance',
    ]:
        add_bullet(doc, b)

    add_heading(doc, 'Phase 2 — Second Business Unit', 2)
    for b in [
        'Parallel routing template for equipment servicing, upfits, and warranty work',
        'Diagnostic fee tracking and warranty coverage rules',
        'Approval workflows for warranty claims and service authorizations',
        'Multi-company structure for operational separation with consolidated reporting',
    ]:
        add_bullet(doc, b)

    add_heading(doc, 'Rollout & Change Management', 2)
    for b in [
        'Pilot first: One product line, one shift, full workflow before expanding',
        'Champions per stage: One supervisor per production stage as Odoo advocate',
        'Barcode gradually: Start with shipping and material issue; expand to all stage transfers',
        'Parallel run: Keep existing tracking alongside Odoo for 2–4 weeks during pilot',
        'Weekly floor check-ins: First month post-go-live to resolve friction points',
    ]:
        add_bullet(doc, b)

    add_page_break(doc)

    # MODULE & TECH EXPERTISE
    add_heading(doc, 'Module & Technology Expertise', 1)
    add_table(doc, ['Odoo Module', 'Scope'], [
        ['Manufacturing (MRP)', 'Work orders, routings, BOMs, capacity planning'],
        ['Inventory', 'Multi-location, lot tracking, replenishment'],
        ['Purchase', 'RFQs, vendor management, procurement workflows'],
        ['Quality', 'Inspection points, checklists, NC tracking'],
        ['Maintenance', 'Equipment records, PM schedules, downtime'],
        ['Timesheets', 'Labor costing, WO time recording'],
        ['Barcode', 'Floor scanning, material movement, WO tracking'],
        ['Accounting', 'Integration with production costing and invoicing'],
        ['Odoo Studio', 'Custom fields without over-engineering'],
    ], col_widths=[2.0, 4.5])

    add_table(doc, ['Category', 'Technologies'], [
        ['Languages', 'Python, JavaScript, TypeScript, XML, SQL'],
        ['Frameworks', 'Odoo OWL, QWeb, PostgreSQL, Django REST'],
        ['APIs', 'REST, XML-RPC, GraphQL, Odoo JSON-RPC'],
        ['Odoo Versions', '15, 16, 17, 18, 19 — Community and Enterprise'],
        ['DevOps', 'Docker, CI/CD, AWS, Odoo.sh deployment'],
    ], col_widths=[1.5, 5.0])

    add_heading(doc, 'Selected GitHub Repositories', 2)
    for b in [
        'job_costing_managment — job costing for make-to-order',
        'Material_Purchase_Requistion — material requisition workflows',
        'Multi_Location_Odoo_17 — multi-location inventory',
        'Odoo_Base_Multi_Company — multi-entity setups',
        'cc_kpi — KPI reporting module',
        'custom-invoice-report — operational reporting',
        'odoo-n8n — Odoo automation integration',
    ]:
        add_bullet(doc, b)

    add_page_break(doc)

    # ENGAGEMENT TERMS
    add_heading(doc, 'Engagement Model & Commercials', 1)
    add_table(doc, ['Item', 'Details'], [
        ['Discovery Lead', 'Muhammad Usman Khan — personally conducts all supervisor interviews'],
        ['Team Capacity', 'CODCrafters bench available for parallel work if needed'],
        ['Discovery Phase Rate', '$22/hour (reduced rate for initial phase)'],
        ['Standard Rate', '$24/hour'],
        ['Availability', 'Immediate — remote worldwide, flexible timezone overlap'],
        ['Communication', 'Weekly demos, milestone updates, staging access, progress reports'],
    ], col_widths=[1.8, 4.7])

    add_table(doc, ['Phase', 'Scope', 'Deliverable'], [
        ['Phase 1 — Discovery', '4-week interviews, process mapping, BOM analysis', 'Documented process map and Odoo data plan'],
        ['Phase 2 — Configuration', 'MRP, Inventory, Purchase, Quality, Maintenance, Barcode', 'Configured Odoo with pilot product line'],
        ['Phase 3 — Rollout', 'Migration, UAT, training, go-live support', 'Live system with trained team and documentation'],
    ], col_widths=[1.5, 2.5, 2.5])

    add_heading(doc, 'Client Testimonial', 2)
    p = doc.add_paragraph()
    r = p.add_run('"Working with Usman and the CODCrafters team was seamless from start to finish. Their Odoo expertise transformed our operations, and the custom modules they built were exactly what we needed. Professional, reliable, and highly skilled."')
    r.italic = True
    r.font.size = Pt(11)
    r.font.name = 'Calibri'
    r.font.color.rgb = NAVY
    p = doc.add_paragraph()
    r = p.add_run('— Marlo Renchor, Business Owner, USA  |  6-month engagement  |  100% Job Success')
    r.font.size = Pt(9.5)
    r.font.name = 'Calibri'
    r.font.color.rgb = MUTED

    add_page_break(doc)

    # NEXT STEPS
    add_heading(doc, 'Recommended Next Steps', 1)
    for step in [
        'Share your internal discovery framework — I will review and align my 4-week discovery plan within 48 hours',
        'Confirm engagement terms — budget model (hourly vs. fixed), hours per week, target go-live date',
        'Schedule Week 1 activities — facility walkthrough and initial supervisor interviews',
        'Identify pilot product line — select one product family for first routing, BOM, and work center configuration',
        'Confirm Odoo environment — edition, hosting, and existing data sources for migration',
    ]:
        add_numbered(doc, step)

    add_heading(doc, 'Resources & References', 2)
    for line in [
        'Portfolio: https://usmanghias.co.uk',
        'GitHub: https://github.com/UsmanGhias (192 public repositories)',
        'Problem Solution Document: https://docs.google.com/document/d/1TJdZYc7oMWCBv7C6QjMgILOPizTDw1OA2e5i_LCvS4M/edit',
        'Video Overview: https://www.loom.com/share/f1858a28f08843d9aa7da86c82bc2721',
        'Agency: https://codcrafters.org',
    ]:
        add_bullet(doc, line)

    doc.add_paragraph()
    p = doc.add_paragraph()
    r = p.add_run('Muhammad Usman Khan\nOdoo Certified Developer | Manufacturing ERP Implementation Specialist\nCEO & Founder, CODCrafters\niusmanghias@gmail.com  |  +92 312 691 2440')
    r.font.size = Pt(11)
    r.font.bold = True
    r.font.color.rgb = NAVY
    r.font.name = 'Calibri'

    out = '/home/usmanghias/Projects/clivora/Clivora/docs/meeting/Usman_Khan_Odoo_Manufacturing_Credentials.docx'
    doc.save(out)
    print(f'Saved: {out}')
    return out


def build_prep_doc():
    doc = setup_document()

    add_heading(doc, 'Meeting Prep Sheet — Steel Container Manufacturing Odoo Engagement', 1)
    add_body(doc, 'Muhammad Usman Khan  |  July 2026  |  Internal use only', muted=True)

    add_heading(doc, '1-Page Leave-Behind Summary (Verbal Pitch)', 2)
    add_body(doc, 'This engagement is discovery first, software second. Your production spans material prep through shipping with real handoffs, leftover sheet reuse, and teams on spreadsheets and walkie-talkies. I will personally run structured interviews with your supervisors, map your stages into Odoo work centers and routings, and configure MRP, Inventory, Purchase, Quality, Maintenance, Timesheets, and Barcode — with KPI dashboards inside Odoo. Phase 1 produces a signed-off blueprint; Phase 2 configures and pilots one product line before full rollout.')

    add_table(doc, ['Your Need', 'My Proof'], [
        ['Discovery with shop floor', '4-week framework; I lead all interviews personally'],
        ['MRP / work centers / BOMs', 'Partsnord (automotive parts), MRP II patterns, Product Configurator'],
        ['Quality + Maintenance + Barcode', 'QMS, CMMS, Warehouse Automation Suite (13 inventory modules)'],
        ['Leftover sheet metal reuse', 'Flexible consumption rules, scrap locations, batch traceability'],
        ['KPI dashboards', 'Plectar: 413+ hrs, Odoo Spreadsheets, 5.0 rating'],
        ['Production status pipeline', 'Workshop job-shop parallel: Pending → stages → Shipped'],
        ['Phase 2 second business unit', 'Multi-company setup, parallel routing templates'],
    ], col_widths=[2.5, 4.0])

    add_heading(doc, 'Key Talking Points — Say These Out Loud', 2)
    for tp in [
        '"I\'ve done discovery before configuration on every manufacturing-adjacent project. Nothing gets built in Odoo until your supervisors sign off on the process map."',
        '"Your leftover sheet metal problem is an inventory rules problem, not an MRP limitation."',
        '"I will personally run supervisor interviews — not delegate to a junior."',
        '"My Plectar engagement proves I build the dashboards management actually uses — 413 hours, consistently rated 5.0."',
        '"Partsnord gives me live automotive/discrete manufacturing context right now."',
        '"We\'ll pilot one product line first before rolling out to your full product catalog."',
    ]:
        add_body(doc, tp)

    add_heading(doc, 'Questions to Ask Them', 2)
    for q in [
        'Which product line should be the pilot for Phase 1?',
        'Do you have existing BOMs in spreadsheets today?',
        'How many work centers and shifts per production stage?',
        'Is barcode hardware already in use, or starting from scratch?',
        'Odoo edition and hosting — Community vs. Enterprise? On-prem vs. Odoo.sh?',
        'Target go-live date and preferred budget model (hourly vs. fixed price)?',
        'Can you share your internal discovery framework before Week 1?',
        'Who are the key stakeholders per stage for Week 1–2 interviews?',
    ]:
        add_bullet(doc, q)

    add_heading(doc, 'Objection Handling', 2)
    add_table(doc, ['If they say...', 'Respond with...'], [
        ['"We\'ve tried ERP before and adoption failed"', '"That\'s why I start with discovery and a pilot product line. Champions per stage, not big-bang rollout."'],
        ['"Odoo can\'t handle our leftover sheet reuse"', '"Flexible consumption rules, scrap locations, and alternative components handle this."'],
        ['"We need someone local / on-site"', '"Discovery Week 1 benefits from on-site walkthrough. Ongoing config works effectively remote with weekly demos."'],
        ['"What\'s your rate?"', '"$22/hour discovery phase, $24/hour standard. Recommend capping Phase 1 hours for budget certainty."'],
        ['"Do you work solo or with a team?"', '"I personally lead discovery and configuration. CODCrafters bench available if scope needs acceleration."'],
    ], col_widths=[2.2, 4.3])

    add_heading(doc, 'Meeting Close — Propose These Next Steps', 2)
    for step in [
        'They share internal discovery framework → you review within 48 hours',
        'Confirm hourly vs. fixed budget and target go-live',
        'Schedule Week 1 facility walkthrough + supervisor interviews',
        'Agree on pilot product line for first routing/BOM',
    ]:
        add_numbered(doc, step)

    add_body(doc, 'Full credentials deck: Usman_Khan_Odoo_Manufacturing_Credentials.docx  |  iusmanghias@gmail.com  |  usmanghias.co.uk', muted=True)

    out = '/home/usmanghias/Projects/clivora/Clivora/docs/meeting/Meeting_Prep_Sheet.docx'
    doc.save(out)
    print(f'Saved: {out}')
    return out


if __name__ == '__main__':
    build_credentials_doc()
    build_prep_doc()
