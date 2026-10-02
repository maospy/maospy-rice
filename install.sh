#!/usr/bin/env bash

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "======================================"
echo "        MAOSPY RICE INSTALLER"
echo "======================================"
echo

echo "[1/7] Paquetes base..."
"$BASE_DIR/modules/packages.sh"

echo
echo "[2/7] Extensiones GNOME..."
"$BASE_DIR/modules/extensions.sh"

echo
echo "[3/7] Dash to Dock..."
"$BASE_DIR/modules/dock.sh"

echo
echo "[4/7] Tiling Shell..."
"$BASE_DIR/modules/tiling.sh"

echo
echo "[5/7] Blur my Shell..."
"$BASE_DIR/modules/blur.sh"

echo
echo "[6/7] Tema..."
"$BASE_DIR/modules/theme.sh"

echo
echo "[7/7] GNOME..."
"$BASE_DIR/modules/gnome.sh"

echo
echo "======================================"
echo "     MAOSPY RICE INSTALADO"
echo "======================================"
echo
echo "Puede ser necesario cerrar sesión"
echo "y volver a entrar para aplicar todos"
echo "los cambios visuales."
