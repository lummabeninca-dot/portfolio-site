#!/usr/bin/env python3
import os, subprocess

BASE = os.path.dirname(os.path.abspath(__file__))
FFMPEG = "/opt/homebrew/bin/ffmpeg"

albums = [
    "mitta", "nowdays", "boma", "bruno-fagundes", "syon-trio",
    "zeze-motta", "bruna-tavares", "roomservice", "spfw", "departamento",
    "menina", "tyler", "marmomac", "kenzo", "lezalez", "provador", "music", "plus"
]

print("=" * 50)
print("  LUMA BENINCÁ — Conversor de Vídeos")
print("=" * 50)

total = 0
for slug in albums:
    folder = os.path.join(BASE, "images", "albums", slug)
    if not os.path.isdir(folder):
        continue

    movs = [f for f in os.listdir(folder) if f.lower().endswith(".mov")]
    if not movs:
        continue

    print(f"\n📁 {slug}/")
    for mov in sorted(movs):
        src = os.path.join(folder, mov)
        dst = os.path.join(folder, os.path.splitext(mov)[0] + ".mp4")

        if os.path.isfile(dst):
            print(f"  — {mov} já convertido, pulando.")
            continue

        print(f"  ⏳ Convertendo {mov} ...", flush=True)
        result = subprocess.run(
            [FFMPEG, "-i", src, "-crf", "18", "-preset", "slow",
             "-vcodec", "libx264", "-acodec", "aac", dst, "-y"],
            capture_output=True
        )
        if result.returncode == 0:
            orig_mb = os.path.getsize(src) / 1_000_000
            new_mb  = os.path.getsize(dst) / 1_000_000
            print(f"  ✓ {mov} → {os.path.basename(dst)}  ({orig_mb:.1f}MB → {new_mb:.1f}MB)")
            total += 1
        else:
            print(f"  ✗ Erro ao converter {mov}")
            print(result.stderr.decode()[-300:])

if total == 0:
    print("\nNenhum .mov novo encontrado.")
else:
    print(f"\n✅ {total} vídeo(s) convertido(s).")

print("\nPronto! Pode fechar esta janela.")
input()
