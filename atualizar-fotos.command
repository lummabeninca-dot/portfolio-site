#!/usr/bin/env python3
import os, re

BASE = os.path.dirname(os.path.abspath(__file__))

albums = [
    ("01", "mitta"),
    ("02", "nowdays"),
    ("03", "boma"),
    ("04", "bruno-fagundes"),
    ("05", "syon-trio"),
    ("06", "zeze-motta"),
    ("07", "bruna-tavares"),
    ("08", "roomservice"),
    ("09", "spfw"),
    ("10", "departamento"),
    ("11", "menina"),
    ("12", "tyler"),
    ("13", "marmomac"),
    ("14", "kenzo"),
    ("15", "lezalez"),
    ("16", "provador"),
    ("17", "music"),
    ("18", "plus"),
]

print("=" * 50)
print("  LUMA BENINCÁ — Atualizador de Fotos")
print("=" * 50)

covers_dir = os.path.join(BASE, "images", "covers")
print("\n📁 CAPAS (images/covers/):")
for num, slug in albums:
    fname = f"{num}-{slug}.jpg"
    exists = os.path.isfile(os.path.join(covers_dir, fname))
    status = "✓" if exists else "✗ FALTANDO"
    print(f"  {status}  {fname}")

print("\n📂 ÁLBUNS:")
updated = 0
for num, slug in albums:
    folder = os.path.join(BASE, "images", "albums", slug)
    html_path = os.path.join(BASE, "albums", f"{num}-{slug}.html")

    photos = sorted(
        f for f in os.listdir(folder)
        if f.lower().endswith((".jpg", ".mp4")) and not f.startswith(".")
    ) if os.path.isdir(folder) else []

    with open(html_path, "r", encoding="utf-8") as f:
        html = f.read()

    photos_js = "[\n" + "".join(f"  '{p}',\n" for p in photos) + "]"
    new_html = re.sub(
        r"const photos = \[.*?\];",
        f"const photos = {photos_js};",
        html,
        flags=re.DOTALL,
    )

    if new_html != html:
        with open(html_path, "w", encoding="utf-8") as f:
            f.write(new_html)
        updated += 1

    count = len(photos)
    label = f"{count} arquivo{'s' if count != 1 else ''}" if count else "vazio"
    print(f"  ({num}) {slug:<20} {label}")

print(f"\n✅ {updated} arquivo(s) atualizado(s).")
print("\nPronto! Pode fechar esta janela.")
input()
