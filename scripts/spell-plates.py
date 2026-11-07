"""Publish print-ready card PNGs and rebuild a named set's Typst index (Pillow)."""
import argparse
import fcntl
import json
import re
import shutil
from pathlib import Path
from tempfile import NamedTemporaryFile

from PIL import Image, ImageDraw, PngImagePlugin

ROOT = Path(__file__).resolve().parents[1] / "resources" / "illustrations"
WIDTH, HEIGHT = 200 / 3 + 4, 287 / 3 + 4  # Finished card plus 2 mm bleed.
CROP = "book-crop"
SCHEME = "color-scheme"
SCENE = "scene-prompt"
COLOR_ROLES = {"title", "stats", "rules", "divider", "content-fill"}


def color_scheme(value):
    if not isinstance(value, dict) or value.keys() - COLOR_ROLES:
        raise ValueError(f"Expected color roles from {sorted(COLOR_ROLES)}")
    for role, color in value.items():
        if not isinstance(color, str) or not re.fullmatch(r"#[0-9a-fA-F]{6}", color):
            raise ValueError(f"{role}: expected #RRGGBB")
    return value


def vignette(source, target, width_mm, body_scale=None, scheme=None, scene=None):
    # Keep the source at native resolution. Physical size determines canvas pixels.
    source.load()
    px = source.width / width_mm
    w, h = round(WIDTH * px), round(HEIGHT * px)
    palette = source.getpalette() if source.mode == "P" else None
    colors = {tuple(palette[i:i + 3]) for i in range(0, len(palette), 3)} if palette else set()
    if palette and "transparency" not in source.info and (
        len(palette) <= 254 * 3 or {(255, 255, 255), (0, 0, 0)} <= colors
    ):
        plate = Image.new("P", (w, h))
        plate.putpalette(palette)
    else:
        source = source.convert("RGBA")
        plate = Image.new("RGBA", (w, h))
    draw = ImageDraw.Draw(plate)
    draw.rectangle((0, 0, w, h), fill="white")
    inset, radius = round(7 * px), round(1.8 * px)
    x1, y1 = w - inset, h - inset
    stroke = max(1, round(0.5 * 25.4 / 72 * px))
    for y in (inset, y1):
        draw.line((inset + radius, y, x1 - radius, y), fill="black", width=stroke)
    for x in (inset, x1):
        draw.line((x, inset + radius, x, y1 - radius), fill="black", width=stroke)
    for x, y, angle in ((inset, inset, 0), (x1, inset, 90),
                        (x1, y1, 180), (inset, y1, 270)):
        draw.arc((x-radius, y-radius, x+radius, y+radius), angle, angle+90,
                 fill="black", width=stroke)
    x, y = (w - source.width) // 2, h - round(9 * px) - source.height
    if y < inset:
        raise ValueError("Vignette exceeds the card's content area")
    plate.paste(source, (x, y))
    info = PngImagePlugin.PngInfo()
    if body_scale is not None:
        info.add_text("body-scale", str(body_scale))
    if scheme:
        info.add_text(SCHEME, json.dumps(scheme))
    if scene:
        info.add_itxt(SCENE, scene)
    info.add_text(CROP, json.dumps([x, y, source.width, source.height]))
    plate.save(target, format="PNG", pnginfo=info)


def write_index(path, data):
    with NamedTemporaryFile("w", dir=path.parent, delete=False) as temp:
        json.dump(data, temp, indent=2)
        temp.write("\n")
    Path(temp.name).replace(path)


def index(directory):
    style_file = directory / "style.json"
    style = json.loads(style_file.read_text()) if style_file.exists() else {}
    defaults = {"title": style["title-color"]} if style.get("title-color") is not None else {}
    defaults.update(color_scheme(style.get(SCHEME, {})))
    color_scheme(defaults)
    family = style.get("font")
    if family is not None and (not isinstance(family, str) or not family.strip()):
        raise ValueError(f"{style_file}: expected a font family name")
    entries = {}
    for path in sorted(directory.glob("*.png")):
        with Image.open(path) as img:
            if abs(img.width / img.height - WIDTH / HEIGHT) > 0.002:
                raise ValueError(f"{path}: expected a card including 2 mm bleed")
            entry = {"font": family} if family else {}
            if "title-type" in style:
                entry["title-type"] = style["title-type"]
            scale = float(img.info.get("body-scale", 1))
            if not 0 < scale <= 1:
                raise ValueError(f"{path}: invalid body scale")
            if scale != 1:
                entry["body-scale"] = scale
            if CROP in img.info:
                x, y, w, h = json.loads(img.info[CROP])
                if not (0 <= x < x+w <= img.width and 0 <= y < y+h <= img.height):
                    raise ValueError(f"{path}: invalid book crop")
                entry["crop"] = [x/img.width, y/img.height, w/img.width, h/img.height]
                entry["text-end"] = y / img.height
            scheme = defaults | color_scheme(json.loads(img.info.get(SCHEME, "{}")))
            if scheme:
                entry[SCHEME] = scheme
            entries[path.stem] = entry
    write_index(directory / "index.json", entries)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("set")
    parser.add_argument("source", type=Path, nargs="?")
    parser.add_argument("--id")
    parser.add_argument("--vignette-width", type=float, metavar="MM")
    parser.add_argument("--body-scale", type=float, help="Use the same body scale as the generation mask")
    parser.add_argument("--color-scheme", type=Path, help="JSON file with optional face colors, including content-fill")
    parser.add_argument("--scene-file", type=Path, help="UTF-8 scene brief to embed in the plate")
    args = parser.parse_args()
    if args.scene_file is not None and args.source is None:
        parser.error("--scene-file requires a source")
    if args.color_scheme is not None and args.source is None:
        parser.error("--color-scheme requires a source")
    if args.body_scale is not None and (not args.source or not 0 < args.body_scale <= 1):
        parser.error("--body-scale requires a source and a value in (0, 1]")
    if args.source is None and (args.id or args.vignette_width is not None):
        parser.error("--id and --vignette-width require a source")
    for name in (args.set, args.id):
        if name is not None and (not name or Path(name).name != name or name in (".", "..")):
            parser.error("Use a single directory name or spell ID")
    folder = ROOT / args.set
    folder.mkdir(parents=True, exist_ok=True)
    scratch = ROOT.parents[1] / "build"
    scratch.mkdir(exist_ok=True)
    with (scratch / ".spell-plates.lock").open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        publish(folder, args, parser)


def publish(folder, args, parser):
    if args.source:
        target = folder / ((args.id or args.source.stem) + ".png")
        with NamedTemporaryFile(dir=folder, delete=False) as temp:
            staging = Path(temp.name)
        try:
            with Image.open(args.source) as img:
                scene = args.scene_file.read_text(encoding="utf-8").strip() if args.scene_file else img.info.get(SCENE)
                if args.scene_file and not scene:
                    parser.error("--scene-file is empty")
                raw_scheme = args.color_scheme.read_text() if args.color_scheme else img.info.get(SCHEME, "{}")
                scheme = color_scheme(json.loads(raw_scheme))
                if args.vignette_width is None:
                    if img.format != "PNG" or abs(img.width / img.height - WIDTH / HEIGHT) > 0.002:
                        parser.error("Expected a full card PNG with bleed")
                    if args.body_scale is None and args.color_scheme is None and args.scene_file is None:
                        shutil.copyfile(args.source, staging)
                    else:
                        info = PngImagePlugin.PngInfo()
                        for key, value in img.text.items():
                            if key not in (SCHEME, SCENE) and (key != "body-scale" or args.body_scale is None):
                                info.add_text(key, value)
                        if args.body_scale is not None:
                            info.add_text("body-scale", str(args.body_scale))
                        if scene:
                            info.add_itxt(SCENE, scene)
                        if scheme:
                            info.add_text(SCHEME, json.dumps(scheme))
                        img.save(staging, format="PNG", pnginfo=info)
                else:
                    if not 0 < args.vignette_width <= WIDTH - 14:
                        parser.error("Vignette width must fit inside the frame")
                    vignette(img, staging, args.vignette_width, args.body_scale, scheme, scene)
            staging.replace(target)
        finally:
            staging.unlink(missing_ok=True)
    index(folder)
    sets = sorted(path.parent.name for path in ROOT.glob("*/index.json"))
    write_index(ROOT / "sets.json", sets)


if __name__ == "__main__":
    main()
