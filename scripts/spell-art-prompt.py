"""Compose an image-generation prompt from the selected project profiles."""

import argparse
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
PROFILES = ROOT / "docs" / "illustrations" / "profiles"


def profile_path(axis, name):
    return PROFILES / axis / name / (name + ".md")


def prompt_block(path):
    blocks = re.findall(r"^```prompt\n(.*?)\n```$", path.read_text(encoding="utf-8"), re.M | re.S)
    if len(blocks) != 1:
        raise ValueError(f"Expected one prompt block in {path}")
    return blocks[0]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("spell_id")
    for option, folder in (("layout", "layouts"), ("story", "stories"), ("style", "styles")):
        choices = sorted(p.name for p in (PROFILES / folder).iterdir() if profile_path(folder, p.name).is_file())
        parser.add_argument("--" + option, required=True, choices=choices)
    scene_input = parser.add_mutually_exclusive_group(required=True)
    scene_input.add_argument("--scene", help="Reviewed scene brief")
    scene_input.add_argument("--scene-from", type=Path, help="Read the scene-prompt from a finished PNG (Pillow)")
    parser.add_argument("--mask", type=Path, help="Exported spatial guide for this spell")
    args = parser.parse_args()

    catalogue = json.loads((ROOT / "resources/data/spellbook.json").read_text(encoding="utf-8"))
    spell = next((entry for entry in catalogue if entry["id"] == args.spell_id), None)
    if spell is None:
        parser.error(f"Unknown catalogue ID: {args.spell_id}")

    layout = prompt_block(profile_path("layouts", args.layout))
    if "{mask}" in layout:
        if args.mask is None or not args.mask.is_file():
            parser.error(f"{args.layout} requires --mask pointing to an existing spatial guide")
        layout = layout.replace("{mask}", str(args.mask))
    elif args.mask is not None:
        parser.error(f"{args.layout} takes no spatial guide")

    scene = args.scene
    if args.scene_from:
        from PIL import Image
        try:
            with Image.open(args.scene_from) as plate:
                scene = plate.info.get("scene-prompt")
        except OSError as error:
            parser.error(str(error))
        if not scene:
            parser.error(f"No scene-prompt in {args.scene_from}")
    print(f"Generate one illustration for {spell['name']} ({args.spell_id}).", layout,
          prompt_block(PROFILES / "scale.md"),
          prompt_block(profile_path("stories", args.story)),
          prompt_block(profile_path("styles", args.style)),
          "Scene: " + scene, sep="\n\n")


if __name__ == "__main__":
    main()
