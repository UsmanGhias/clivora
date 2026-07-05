"""Generate CLIVORA Play Store graphics and app logo."""
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    import subprocess
    subprocess.check_call(["pip", "install", "pillow", "-q"])
    from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets" / "images"
PLAY = ROOT / "play-store"
GRAPHICS = PLAY / "graphics"
SCREENSHOTS = PLAY / "screenshots"

TEAL = (20, 184, 166)
NAVY = (15, 23, 42)
PURPLE = (108, 99, 255)
WHITE = (255, 255, 255)


def gradient(size, c1, c2):
    img = Image.new("RGB", size)
    draw = ImageDraw.Draw(img)
    for y in range(size[1]):
        t = y / max(size[1] - 1, 1)
        color = tuple(int(c1[i] + (c2[i] - c1[i]) * t) for i in range(3))
        draw.line([(0, y), (size[0], y)], fill=color)
    return img


def draw_logo(size: int) -> Image.Image:
    img = gradient((size, size), PURPLE, (79, 70, 229))
    draw = ImageDraw.Draw(img)
    margin = size // 8
    draw.rounded_rectangle([margin, margin, size - margin, size - margin], radius=size // 6, outline=WHITE, width=max(2, size // 64))
    try:
        font = ImageFont.truetype("arialbd.ttf", size=int(size * 0.42))
    except OSError:
        font = ImageFont.load_default()
    draw.text((size // 2, size // 2), "C", fill=WHITE, font=font, anchor="mm")
    return img


def save_icon():
    logo = draw_logo(512)
    ASSETS.mkdir(parents=True, exist_ok=True)
    GRAPHICS.mkdir(parents=True, exist_ok=True)
    logo.save(ASSETS / "clivora_logo.png")
    logo.save(GRAPHICS / "app-icon-512.png")
    for s in (192, 144, 96, 72, 48):
        draw_logo(s).save(GRAPHICS / f"app-icon-{s}.png")


def feature_graphic():
    w, h = 1024, 500
    img = gradient((w, h), NAVY, (19, 78, 74))
    draw = ImageDraw.Draw(img)
    try:
        title_font = ImageFont.truetype("arialbd.ttf", 56)
        sub_font = ImageFont.truetype("arial.ttf", 28)
    except OSError:
        title_font = sub_font = ImageFont.load_default()
    draw.rounded_rectangle([60, 120, 200, 380], radius=28, fill=PURPLE)
    draw.text((130, 250), "C", fill=WHITE, font=title_font, anchor="mm")
    draw.text((240, 180), "CLIVORA", fill=WHITE, font=title_font)
    draw.text((240, 250), "Your Business Operating System", fill=(148, 163, 184), font=sub_font)
    draw.text((240, 310), "Clients · Projects · Invoices · Tasks", fill=TEAL, font=sub_font)
    draw.rounded_rectangle([700, 140, 960, 360], radius=24, outline=(255, 255, 255, 80), width=3)
    draw.text((830, 220), "CRM for", fill=WHITE, font=sub_font, anchor="mm")
    draw.text((830, 270), "Freelancers", fill=TEAL, font=sub_font, anchor="mm")
    img.save(GRAPHICS / "feature-graphic-1024x500.png")


def screenshot_mock(title: str, lines: list[str], idx: int):
    w, h = 1080, 1920
    img = gradient((w, h), (248, 250, 252), WHITE)
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle([40, 80, w - 40, 320], radius=32, fill=NAVY)
    try:
        tf = ImageFont.truetype("arialbd.ttf", 48)
        bf = ImageFont.truetype("arial.ttf", 36)
    except OSError:
        tf = bf = ImageFont.load_default()
    draw.text((80, 160), "CLIVORA", fill=WHITE, font=tf)
    draw.text((80, 220), title, fill=TEAL, font=bf)
    y = 400
    for line in lines:
        draw.rounded_rectangle([60, y, w - 60, y + 120], radius=20, fill=WHITE, outline=(226, 232, 240))
        draw.text((100, y + 60), line, fill=NAVY, font=bf, anchor="lm")
        y += 150
    SCREENSHOTS.mkdir(parents=True, exist_ok=True)
    img.save(SCREENSHOTS / f"screenshot-0{idx}.png")


def main():
    save_icon()
    feature_graphic()
    screenshot_mock("Dashboard", ["Revenue overview", "Active projects", "Quick actions"], 1)
    screenshot_mock("Clients", ["Add & manage clients", "Contact details", "Search clients"], 2)
    screenshot_mock("Invoices", ["Create invoices", "PDF export", "Track payments"], 3)
    screenshot_mock("Workspace", ["Tasks & expenses", "Reports & calendar", "Pro features"], 4)
    print("Generated logo + Play Store assets in play-store/")


if __name__ == "__main__":
    main()
