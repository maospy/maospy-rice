#!/usr/bin/env bash

set -e

echo "======================================"
echo "     MAOSPY RICE - WALLPAPER"
echo "======================================"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WALLPAPER="$BASE_DIR/assets/wallpapers/maospy-nord.png"

if [[ ! -f "$WALLPAPER" ]]; then
    echo "ERROR: No se encontró el wallpaper esperado:"
    echo "$WALLPAPER"
    echo
    echo "Copiá un archivo con ese nombre dentro de:"
    echo "$BASE_DIR/assets/wallpapers/"
    exit 1
fi

URI="file://$WALLPAPER"

echo
echo "Aplicando wallpaper..."

gsettings set org.gnome.desktop.background picture-uri "$URI"
gsettings set org.gnome.desktop.background picture-uri-dark "$URI"
gsettings set org.gnome.desktop.background picture-options 'zoom'

echo
echo "Wallpaper aplicado correctamente."
echo "$WALLPAPER"
