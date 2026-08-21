#!/usr/bin/env python3
"""Prepare the CLIVORA Capstone deck image library.

Sources (read-only):
  * Upwork catalogue PDF          -> web dashboard mockups
  * CLIVORA Marketing Launch Kit  -> Play Store frames + feature graphic
  * Premium Graphic Campaign V2    -> editorial section-divider art
  * Cursor asset cache             -> real Android device screenshots

Outputs everything into ./visuals as deck-ready PNGs. Device screenshots get
rounded corners, a gradient bezel and a soft outer glow so they sit on the dark
slides without looking like pasted rectangles.
"""
from __future__ import annotations

import shutil
import subprocess
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent
VISUALS = ROOT / "visuals"
CATALOGUE = ROOT / "catalogue"

DOWNLOADS = Path("/home/usmanghias/Downloads")
CATALOGUE_PDF = DOWNLOADS / "Clivora_Upwork_Project_Catalogue.pdf"
KIT_ZIP = DOWNLOADS / "CLIVORA_Marketing_Launch_Kit_2026.zip"
V2_ZIP = DOWNLOADS / "CLIVORA_Premium_Graphic_Campaign_V2.zip"
CACHE = Path(
    "/home/usmanghias/.cursor/projects/home-usmanghias-Projects-clivora-Clivora/assets"
)
WORK = Path("/tmp/clivora-kit")

TEAL = (40, 210, 203)
VIOLET = (113, 98, 252)

# Real Android device screenshots -> deck names.
DEVICE_SHOTS = {
    "app-freelancer-home": "image-9b7d3dd8-30e4-4c6e-9b3b-c0a5ed989be7.png",
    "app-dashboard": "image-b4cbff2d-91e5-49f9-b948-063fe35b5ee7.png",
    "app-connect-jobs": "image-444e4eab-9cca-4735-a5d0-4b00624524a3.png",
    "app-new-invoice": "image-599a5ce9-a7f7-4ca2-921c-fc77ca61ca25.png",
    "app-command-1": "image-6f91a67b-571e-498c-81bb-eaeddeb1fe80.png",
    "app-command-2": "image-110f4084-ed92-4947-b24d-26c55116e834.png",
    "app-command-3": "image-6a484f2b-0830-46c0-85db-9c8c78d3d791.png",
    "app-client-portal": "image-42bea346-af31-4e16-bb1b-bc9dbcd300c1.png",
    "app-workflows": "image-8f1bd604-101b-4424-a3f6-3469e3c02bb3.png",
    "app-client-chat": "image-cf3acf12-30cf-47f9-9aa7-42c8f5179dc9.png",
    "app-client-home": "image-9e457acd-fc58-4902-9981-0149dedd64cb.png",
    "app-connect-talent": "image-fa760d89-13ae-4a34-b798-db605dc920bc.png",
    "app-invoice-paid": "image-c57a9dda-f90f-44b4-894f-6494d6089cf8.png",
    "app-account": "image-c5528f69-4bb1-4aad-b9b7-1fd71d04c2d0.png",
    "app-client-hub": "image-1a685c6d-bcd5-4eb4-a16c-dcf096f0f5c7.png",
}

V2_ART = {
    "v2-connected": "01_work_should_feel_connected_1080x1350.png",
    "v2-opportunity": "02_the_next_opportunity_1080x1350.png",
    "v2-brief-invoice": "03_from_first_brief_to_final_invoice_1080x1350.png",
    "v2-momentum": "04_own_the_momentum_1080x1350.png",
    "v2-not-marketplace": "05_not_another_marketplace_1080x1350.png",
}

PLAY = {
    "play-01": "05_Google_Play/CLIVORA_Play_Store_Screenshot_01_1080x1920.png",
    "play-02": "05_Google_Play/CLIVORA_Play_Store_Screenshot_02_1080x1920.png",
    "play-03": "05_Google_Play/CLIVORA_Play_Store_Screenshot_03_1080x1920.png",
    "play-04": "05_Google_Play/CLIVORA_Play_Store_Screenshot_04_1080x1920.png",
    "play-feature": "05_Google_Play/CLIVORA_Google_Play_Feature_Graphic_1024x500.png",
}


def log(msg: str) -> None:
    print(f"  {msg}")


def ensure_sources() -> None:
    WORK.mkdir(parents=True, exist_ok=True)
    kit_dir = WORK / "CLIVORA_Marketing_Launch_Kit_2026"
    if not kit_dir.exists() and KIT_ZIP.exists():
        log("extracting marketing launch kit")
        subprocess.run(["unzip", "-oq", str(KIT_ZIP), "-d", str(WORK)], check=True)
    v2_dir = WORK / "v2"
    if not v2_dir.exists() and V2_ZIP.exists():
        log("extracting premium campaign v2")
        v2_dir.mkdir(parents=True, exist_ok=True)
        subprocess.run(["unzip", "-oq", str(V2_ZIP), "-d", str(v2_dir)], check=True)
    if not CATALOGUE.exists() and CATALOGUE_PDF.exists():
        log("rasterising Upwork catalogue PDF")
        CATALOGUE.mkdir(parents=True, exist_ok=True)
        subprocess.run(
            ["pdftoppm", "-r", "170", "-png", str(CATALOGUE_PDF), str(CATALOGUE / "page")],
            check=True,
        )


def downscale(src: Path, dst: Path, max_w: int) -> None:
    im = Image.open(src)
    if im.mode not in ("RGB", "RGBA"):
        im = im.convert("RGB")
    if im.width > max_w:
        h = int(im.height * max_w / im.width)
        im = im.resize((max_w, h), Image.LANCZOS)
    im.save(dst, optimize=True)


def frame_device(src: Path, dst: Path, target_h: int = 1180) -> None:
    """Rounded corners + teal->violet bezel + soft glow, transparent background."""
    shot = Image.open(src).convert("RGBA")
    scale = target_h / shot.height
    shot = shot.resize((max(1, int(shot.width * scale)), target_h), Image.LANCZOS)
    w, h = shot.size

    radius = int(w * 0.085)
    bezel = max(6, int(w * 0.022))
    glow_pad = int(w * 0.28)

    # rounded screen
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, w - 1, h - 1], radius=radius, fill=255)
    screen = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    screen.paste(shot, (0, 0), mask)

    # bezel plate with vertical teal -> violet gradient
    bw, bh = w + bezel * 2, h + bezel * 2
    grad = Image.new("RGBA", (bw, bh))
    gpix = grad.load()
    for y in range(bh):
        t = y / max(1, bh - 1)
        gpix_row = (
            int(TEAL[0] + (VIOLET[0] - TEAL[0]) * t),
            int(TEAL[1] + (VIOLET[1] - TEAL[1]) * t),
            int(TEAL[2] + (VIOLET[2] - TEAL[2]) * t),
            255,
        )
        for x in range(bw):
            gpix[x, y] = gpix_row
    bmask = Image.new("L", (bw, bh), 0)
    ImageDraw.Draw(bmask).rounded_rectangle(
        [0, 0, bw - 1, bh - 1], radius=radius + bezel, fill=255
    )
    bezel_plate = Image.new("RGBA", (bw, bh), (0, 0, 0, 0))
    bezel_plate.paste(grad, (0, 0), bmask)

    # canvas with glow
    cw, ch = bw + glow_pad * 2, bh + glow_pad * 2
    canvas = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    glow = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    ImageDraw.Draw(glow).rounded_rectangle(
        [glow_pad, glow_pad + int(bh * 0.05), glow_pad + bw, glow_pad + bh],
        radius=radius + bezel,
        fill=(20, 190, 190, 120),
    )
    glow = glow.filter(ImageFilter.GaussianBlur(glow_pad * 0.45))
    canvas = Image.alpha_composite(canvas, glow)

    canvas.paste(bezel_plate, (glow_pad, glow_pad), bezel_plate)
    canvas.paste(screen, (glow_pad + bezel, glow_pad + bezel), screen)
    canvas.save(dst, optimize=True)


def main() -> int:
    if not CACHE.exists():
        print(f"! asset cache missing: {CACHE}", file=sys.stderr)
    ensure_sources()
    VISUALS.mkdir(parents=True, exist_ok=True)

    print("Campaign V2 editorial art")
    for name, fn in V2_ART.items():
        src = WORK / "v2" / fn
        if src.exists():
            downscale(src, VISUALS / f"{name}.png", 1400)
            log(f"{name}.png")

    print("Google Play assets")
    kit = WORK / "CLIVORA_Marketing_Launch_Kit_2026"
    for name, rel in PLAY.items():
        src = kit / rel
        if src.exists():
            downscale(src, VISUALS / f"{name}.png", 1200)
            log(f"{name}.png")

    print("Upwork catalogue web mockups")
    for i in range(1, 7):
        src = CATALOGUE / f"page-{i}.png"
        if src.exists():
            downscale(src, VISUALS / f"catalogue-{i}.png", 1900)
            log(f"catalogue-{i}.png")

    print("Real Android device screenshots (framed)")
    for name, fn in DEVICE_SHOTS.items():
        src = CACHE / fn
        if not src.exists():
            log(f"MISSING {fn}")
            continue
        frame_device(src, VISUALS / f"{name}.png")
        log(f"{name}.png")

    print("Brand marks")
    brand = ROOT.parents[2] / "assets" / "images"
    for fn in ("clivora_logo_on_dark.png", "clivora_mark_white.png", "clivora_logo_on_light.png"):
        src = brand / fn
        if src.exists():
            shutil.copyfile(src, VISUALS / fn)
            log(fn)

    total = sum(p.stat().st_size for p in VISUALS.glob("*.png"))
    print(f"\n{len(list(VISUALS.glob('*.png')))} assets · {total/1_048_576:.1f} MB in {VISUALS}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
