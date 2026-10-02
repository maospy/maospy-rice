#!/usr/bin/env bash

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_DIR="$HOME/.local/state/maospy-rice"
STATE_FILE="$STATE_DIR/extensions-ready"

mkdir -p "$STATE_DIR"

echo "======================================"
echo "        MAOSPY RICE INSTALLER"
echo "======================================"
echo

echo "[1/7] Paquetes base..."
"$BASE_DIR/modules/packages.sh"

echo
echo "[2/7] Extensiones GNOME..."

BEFORE="$(
    gnome-extensions list 2>/dev/null | sort || true
)"

"$BASE_DIR/modules/extensions.sh"

AFTER="$(
    gnome-extensions list 2>/dev/null | sort || true
)"

if [[ "$BEFORE" != "$AFTER" && ! -f "$STATE_FILE" ]]; then
    touch "$STATE_FILE"

    echo
    echo "======================================"
    echo "   EXTENSIONES NUEVAS INSTALADAS"
    echo "======================================"
    echo
    echo "GNOME necesita recargar las extensiones."
    echo
    echo "Cerrá sesión y volvé a entrar."
    echo
    echo "Después ejecutá nuevamente:"
    echo
    echo "    ./install.sh"
    echo
    exit 0
fi

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
echo "[6/7] Apariencia..."
"$BASE_DIR/modules/theme.sh"

echo
echo "[7/7] GNOME..."
"$BASE_DIR/modules/gnome.sh"

rm -f "$STATE_FILE"

echo
echo "======================================"
echo "       MAOSPY RICE INSTALADO"
echo "======================================"
echo
echo "Instalación completada correctamente."
echo
echo "Recomendado:"
echo "cerrar sesión y volver a entrar"
echo "para asegurar que GNOME recargue todo."
