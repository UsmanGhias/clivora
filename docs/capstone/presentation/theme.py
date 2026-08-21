#!/usr/bin/env python3
"""CLIVORA Capstone deck — design system.

Colours, type scale, layout grid and the shape primitives every slide is built
from. Palette is sampled directly from the CLIVORA Premium Campaign V2 artwork
so the deck, the Play Store listing and the social creatives share one identity.
"""
from __future__ import annotations

from pathlib import Path

from pptx.dml.color import RGBColor
from pptx.enum.shapes import MSO_SHAPE
from pptx.enum.text import MSO_ANCHOR, PP_ALIGN
from pptx.oxml.ns import qn
from pptx.oxml.xmlchemy import OxmlElement
from pptx.util import Emu, Inches, Pt

# ---------------------------------------------------------------- palette ----

INK = RGBColor(0x05, 0x0F, 0x1E)      # deepest navy, slide base
NAVY = RGBColor(0x0A, 0x1B, 0x30)     # primary background
NAVY2 = RGBColor(0x0D, 0x25, 0x3E)    # background gradient end
SURF = RGBColor(0x10, 0x2B, 0x46)     # card surface
SURF2 = RGBColor(0x16, 0x39, 0x5B)    # raised surface
LINE = RGBColor(0x1E, 0x44, 0x63)     # hairline / card border

TEAL = RGBColor(0x28, 0xD2, 0xCB)
CYAN = RGBColor(0x22, 0xD3, 0xEE)
BLUE = RGBColor(0x3B, 0x82, 0xF6)
VIOLET = RGBColor(0x71, 0x62, 0xFC)

WHITE = RGBColor(0xFF, 0xFF, 0xFF)
DIM = RGBColor(0xAD, 0xC4, 0xD9)      # body copy on dark
MUTE = RGBColor(0x71, 0x8F, 0xAB)     # captions, footers
GREEN = RGBColor(0x34, 0xD3, 0x99)
AMBER = RGBColor(0xFB, 0xBF, 0x24)
ROSE = RGBColor(0xFB, 0x71, 0x85)

ACCENTS = (TEAL, CYAN, BLUE, VIOLET)

# ------------------------------------------------------------------- type ----

DISPLAY = "Inter Display"
BODY = "Inter"

# --------------------------------------------------------------- geometry ----

SW = 13.3333          # slide width, inches
SH = 7.5              # slide height, inches
M = 0.62              # page margin
CW = SW - 2 * M       # content width

Y_KICKER = 0.46
Y_TITLE = 0.76
Y_LEDE = 1.66
Y_BODY = 2.24
Y_BODY_END = 6.82
Y_FOOTER = 7.03

ROOT = Path(__file__).resolve().parent
VISUALS = ROOT / "visuals"


def V(name: str) -> str:
    return str(VISUALS / name)


# ------------------------------------------------------------ xml helpers ----

def alpha(shape, transparency: float) -> None:
    """Apply fill transparency. 0.0 = opaque, 1.0 = invisible."""
    solid = shape._element.spPr.find(qn("a:solidFill"))
    if solid is None:
        return
    clr = solid.find(qn("a:srgbClr"))
    if clr is None:
        return
    node = OxmlElement("a:alpha")
    node.set("val", str(int(max(0.0, 1.0 - transparency) * 100000)))
    clr.append(node)


def tracking(run, points: float) -> None:
    """Letter-spacing in points (used for the small caps kickers)."""
    run.font._rPr.set("spc", str(int(points * 100)))


def gradient(shape, c1: RGBColor, c2: RGBColor, angle: int = 90) -> None:
    fill = shape.fill
    fill.gradient()
    stops = fill.gradient_stops
    stops[0].color.rgb = c1
    stops[0].position = 0.0
    last = len(stops) - 1
    stops[last].color.rgb = c2
    stops[last].position = 1.0
    for i in range(1, last):
        t = i / last
        stops[i].color.rgb = RGBColor(
            int(c1[0] + (c2[0] - c1[0]) * t),
            int(c1[1] + (c2[1] - c1[1]) * t),
            int(c1[2] + (c2[2] - c1[2]) * t),
        )
        stops[i].position = t
    fill.gradient_angle = angle


def no_line(shape) -> None:
    shape.line.fill.background()


def solid(shape, color: RGBColor, line: RGBColor | None = None, lw: float = 0.75) -> None:
    shape.fill.solid()
    shape.fill.fore_color.rgb = color
    shape.shadow.inherit = False
    if line is None:
        no_line(shape)
    else:
        shape.line.color.rgb = line
        shape.line.width = Pt(lw)


# --------------------------------------------------------------- text box ----

def text(
    slide,
    l: float,
    t: float,
    w: float,
    h: float,
    body: str,
    size: float = 13,
    color: RGBColor = DIM,
    bold: bool = False,
    font: str = BODY,
    align=PP_ALIGN.LEFT,
    anchor=MSO_ANCHOR.TOP,
    spacing: float = 1.22,
    space_after: float = 0.0,
    track: float | None = None,
    caps: bool = False,
):
    """Multi-paragraph text box. Split paragraphs with '\\n'."""
    box = slide.shapes.add_textbox(Inches(l), Inches(t), Inches(w), Inches(h))
    tf = box.text_frame
    tf.word_wrap = True
    for side in ("margin_left", "margin_right", "margin_top", "margin_bottom"):
        setattr(tf, side, Emu(0))
    tf.vertical_anchor = anchor
    lines = body.split("\n")
    for i, line in enumerate(lines):
        p = tf.paragraphs[0] if i == 0 else tf.add_paragraph()
        p.alignment = align
        p.line_spacing = spacing
        if space_after:
            p.space_after = Pt(space_after)
        run = p.add_run()
        run.text = line.upper() if caps else line
        f = run.font
        f.name = font
        f.size = Pt(size)
        f.bold = bold
        f.color.rgb = color
        if track is not None:
            tracking(run, track)
    return box


def rect(slide, l, t, w, h, color=SURF, line=None, lw=0.75):
    s = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, Inches(l), Inches(t), Inches(w), Inches(h))
    solid(s, color, line, lw)
    return s


def round_rect(slide, l, t, w, h, color=SURF, line=None, radius=0.10, lw=0.75):
    s = slide.shapes.add_shape(
        MSO_SHAPE.ROUNDED_RECTANGLE, Inches(l), Inches(t), Inches(w), Inches(h)
    )
    s.adjustments[0] = radius
    solid(s, color, line, lw)
    return s


def oval(slide, l, t, w, h, color=TEAL):
    s = slide.shapes.add_shape(MSO_SHAPE.OVAL, Inches(l), Inches(t), Inches(w), Inches(h))
    solid(s, color)
    return s


def glow(slide, cx, cy, size, color=TEAL, transparency=0.86):
    s = oval(slide, cx - size / 2, cy - size / 2, size, size, color)
    alpha(s, transparency)
    return s


# ------------------------------------------------------------- background ----

def background(slide, art: str | None = None, art_box: tuple | None = None):
    base = rect(slide, 0, 0, SW, SH, INK)
    gradient(base, RGBColor(0x06, 0x12, 0x24), RGBColor(0x0C, 0x24, 0x3C), angle=135)
    glow(slide, SW - 1.2, -0.4, 6.4, TEAL, 0.90)
    glow(slide, 1.0, SH + 0.6, 5.6, VIOLET, 0.92)
    if art and art_box:
        slide.shapes.add_picture(V(art), *[Inches(v) for v in art_box])
    return base


def brandbar(slide, page: int | None = None, total: int | None = None):
    """Logo lockup top-left, page counter top-right, hairline under both."""
    slide.shapes.add_picture(
        V("clivora_logo_on_dark.png"), Inches(M), Inches(0.30), height=Inches(0.30)
    )
    if page is not None:
        text(
            slide, SW - M - 2.2, 0.34, 2.2, 0.26, f"{page:02d} / {total:02d}",
            size=9.5, color=MUTE, font=BODY, align=PP_ALIGN.RIGHT, track=1.4,
        )
    hr = rect(slide, M, 0.735, CW, 0.012, LINE)
    alpha(hr, 0.45)


def kicker(slide, label: str, color: RGBColor = TEAL, y: float = Y_KICKER):
    return text(slide, M, y, CW, 0.26, label, size=10.5, bold=True, color=color,
                font=BODY, track=2.2, caps=True)


def title(slide, headline: str, size: float = 31, y: float = Y_TITLE, w: float = CW,
          color: RGBColor = WHITE):
    return text(slide, M, y, w, 1.05, headline, size=size, bold=True, color=color,
                font=DISPLAY, spacing=1.06)


def lede(slide, copy: str, y: float = Y_LEDE, w: float = CW, size: float = 14):
    return text(slide, M, y, w, 0.62, copy, size=size, color=DIM, spacing=1.30)


def footer(slide, left: str = "CLIVORA · Quantic MSSE Capstone", right: str = ""):
    hr = rect(slide, M, Y_FOOTER - 0.16, CW, 0.012, LINE)
    alpha(hr, 0.40)
    text(slide, M, Y_FOOTER, CW * 0.6, 0.24, left, size=8.5, color=MUTE, track=1.0)
    if right:
        text(slide, SW - M - 5.4, Y_FOOTER, 5.4, 0.24, right, size=8.5, color=MUTE,
             align=PP_ALIGN.RIGHT, track=1.0)


def notes(slide, script: str) -> None:
    slide.notes_slide.notes_text_frame.text = script.strip()


# ------------------------------------------------------------- components ----

def pill(slide, l, t, w, h, label, fg=WHITE, bg=SURF2, border=None, size=9.5,
         gradient_to=None):
    s = round_rect(slide, l, t, w, h, bg, border, radius=0.5)
    if gradient_to is not None:
        gradient(s, bg, gradient_to, angle=0)
    text(slide, l, t, w, h, label, size=size, bold=True, color=fg,
         align=PP_ALIGN.CENTER, anchor=MSO_ANCHOR.MIDDLE, track=1.2, caps=True)
    return s


def accent_rule(slide, l, t, w=1.05, h=0.055, c1=TEAL, c2=VIOLET):
    s = rect(slide, l, t, w, h, c1)
    gradient(s, c1, c2, angle=0)
    return s


def card(slide, l, t, w, h, heading, body="", accent=TEAL, index=None,
         heading_size=13.5, body_size=10.5):
    """Bordered surface card with a top accent tick."""
    box = round_rect(slide, l, t, w, h, SURF, LINE, radius=0.055)
    alpha(box, 0.12)
    rect(slide, l + 0.28, t, 0.62, 0.045, accent)
    y = t + 0.32
    if index is not None:
        text(slide, l + 0.28, y, 0.9, 0.3, index, size=11, bold=True, color=accent,
             font=DISPLAY, track=1.0)
        y += 0.34
    text(slide, l + 0.28, y, w - 0.56, 0.42, heading, size=heading_size, bold=True,
         color=WHITE, font=DISPLAY, spacing=1.10)
    if body:
        text(slide, l + 0.28, y + 0.46, w - 0.56, h - (y + 0.46 - t) - 0.24, body,
             size=body_size, color=DIM, spacing=1.30)
    return box


def stat(slide, l, t, w, value, label, accent=TEAL, value_size=30, h=1.42):
    box = round_rect(slide, l, t, w, h, SURF, LINE, radius=0.06)
    alpha(box, 0.10)
    text(slide, l + 0.24, t + 0.20, w - 0.48, 0.62, value, size=value_size, bold=True,
         color=accent, font=DISPLAY, spacing=1.0)
    text(slide, l + 0.24, t + 0.88, w - 0.48, 0.42, label, size=9.5, color=DIM,
         spacing=1.20)
    return box


def bullets(slide, l, t, w, items, size=12, gap=0.46, accent=TEAL, color=DIM,
            dot=0.075):
    """Rows of accent dot + text."""
    y = t
    for item in items:
        oval(slide, l, y + size / 200 + 0.045, dot, dot, accent)
        text(slide, l + 0.26, y, w - 0.26, gap, item, size=size, color=color,
             spacing=1.26)
        y += gap
    return y


def kv_rows(slide, l, t, w, rows, key_w=3.0, size=10.5, gap=0.42):
    """Two-column key/value list separated by hairlines."""
    y = t
    for k, v in rows:
        text(slide, l, y, key_w, gap, k, size=size, bold=True, color=WHITE)
        text(slide, l + key_w, y, w - key_w, gap, v, size=size, color=DIM)
        hr = rect(slide, l, y + gap - 0.10, w, 0.008, LINE)
        alpha(hr, 0.5)
        y += gap
    return y


# ----------------------------------------------------------- diagram parts ----

def node(slide, l, t, w, h, heading, sub="", accent=TEAL, fill=SURF2,
         heading_size=11.5, sub_size=8.5, radius=0.10):
    box = round_rect(slide, l, t, w, h, fill, accent, radius=radius, lw=1.0)
    alpha(box, 0.18)
    if sub:
        text(slide, l + 0.16, t + h / 2 - 0.34, w - 0.32, 0.34, heading,
             size=heading_size, bold=True, color=WHITE, font=DISPLAY,
             align=PP_ALIGN.CENTER, spacing=1.05)
        text(slide, l + 0.14, t + h / 2 + 0.02, w - 0.28, 0.42, sub, size=sub_size,
             color=DIM, align=PP_ALIGN.CENTER, spacing=1.16)
    else:
        text(slide, l + 0.14, t, w - 0.28, h, heading, size=heading_size, bold=True,
             color=WHITE, font=DISPLAY, align=PP_ALIGN.CENTER,
             anchor=MSO_ANCHOR.MIDDLE, spacing=1.10)
    return box


def arrow_r(slide, l, t, w=0.42, h=0.17, color=TEAL, transparency=0.25):
    s = slide.shapes.add_shape(MSO_SHAPE.RIGHT_ARROW, Inches(l), Inches(t),
                               Inches(w), Inches(h))
    solid(s, color)
    alpha(s, transparency)
    return s


def arrow_d(slide, l, t, w=0.17, h=0.36, color=TEAL, transparency=0.25):
    s = slide.shapes.add_shape(MSO_SHAPE.DOWN_ARROW, Inches(l), Inches(t),
                               Inches(w), Inches(h))
    solid(s, color)
    alpha(s, transparency)
    return s


def flow(slide, l, t, w, h, steps, gap=0.44, accent=TEAL, heading_size=11,
         sub_size=8.5):
    """Horizontal chain of nodes joined by arrows. steps = [(heading, sub), ...]"""
    n = len(steps)
    nw = (w - gap * (n - 1)) / n
    for i, (heading, sub) in enumerate(steps):
        x = l + i * (nw + gap)
        col = accent if not isinstance(accent, (list, tuple)) else accent[i % len(accent)]
        node(slide, x, t, nw, h, heading, sub, accent=col,
             heading_size=heading_size, sub_size=sub_size)
        if i < n - 1:
            arrow_r(slide, x + nw + 0.045, t + h / 2 - 0.085, gap - 0.09, 0.17, col)
    return nw


def pic_h(slide, name, l, t, h, rot=0):
    """Place a picture by height; returns (picture, computed_width_inches)."""
    from PIL import Image

    path = V(name)
    with Image.open(path) as im:
        w = h * im.width / im.height
    pic = slide.shapes.add_picture(path, Inches(l), Inches(t), height=Inches(h))
    if rot:
        pic.rotation = rot
    return pic, w


def pic_w(slide, name, l, t, w, rot=0):
    """Place a picture by width; returns (picture, computed_height_inches)."""
    from PIL import Image

    path = V(name)
    with Image.open(path) as im:
        h = w * im.height / im.width
    pic = slide.shapes.add_picture(path, Inches(l), Inches(t), width=Inches(w))
    if rot:
        pic.rotation = rot
    return pic, h


def framed_pic(slide, name, l, t, w, pad=0.0, border=LINE):
    """Picture inside a hairline frame, sized by width."""
    from PIL import Image

    path = V(name)
    with Image.open(path) as im:
        h = w * im.height / im.width
    if pad:
        plate = round_rect(slide, l - pad, t - pad, w + pad * 2, h + pad * 2, SURF,
                           border, radius=0.03)
        alpha(plate, 0.25)
    slide.shapes.add_picture(path, Inches(l), Inches(t), width=Inches(w))
    return h


def rail_label(slide, l, t, w, label, color=TEAL):
    accent_rule(slide, l, t + 0.10, 0.34, 0.05, color, color)
    text(slide, l + 0.46, t, w - 0.46, 0.30, label, size=9.5, bold=True, color=color,
         track=1.8, caps=True)
