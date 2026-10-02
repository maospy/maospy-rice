#!/usr/bin/env bash

set -e

EXT_DIR="$HOME/.local/share/gnome-shell/extensions/tilingshell@ferrarodomenico.com"
SCHEMA_DIR="$EXT_DIR/schemas"
SCHEMA="org.gnome.shell.extensions.tilingshell"

echo "======================================"
echo "       MAOSPY RICE - TILING"
echo "======================================"

if [[ ! -f "$SCHEMA_DIR/gschemas.compiled" ]]; then
    echo "ERROR: No se encontró el esquema compilado de Tiling Shell."
    exit 1
fi

export GSETTINGS_SCHEMA_DIR="$SCHEMA_DIR"

if ! gsettings list-schemas | grep -Fxq "$SCHEMA"; then
    echo "ERROR: No se encontró el esquema:"
    echo "$SCHEMA"
    exit 1
fi

echo
echo "Configurando Tiling Shell..."

# Sistema tiling principal
gsettings set "$SCHEMA" enable-tiling-system true
gsettings set "$SCHEMA" enable-snap-assist true
gsettings set "$SCHEMA" active-screen-edges true

# No usar autotiling agresivo
gsettings set "$SCHEMA" enable-autotiling false

# Espaciado
gsettings set "$SCHEMA" inner-gaps 12
gsettings set "$SCHEMA" outer-gaps 8

# Movimiento con Super + flechas
gsettings set "$SCHEMA" enable-move-keybindings true
gsettings set "$SCHEMA" move-window-left "['<Super>Left']"
gsettings set "$SCHEMA" move-window-right "['<Super>Right']"
gsettings set "$SCHEMA" move-window-up "['<Super>Up']"
gsettings set "$SCHEMA" move-window-down "['<Super>Down']"

# Comportamiento
gsettings set "$SCHEMA" enable-span-multiple-tiles true
gsettings set "$SCHEMA" resize-complementing-windows true
gsettings set "$SCHEMA" restore-window-original-size true
gsettings set "$SCHEMA" override-window-menu true

# Navegación
gsettings set "$SCHEMA" enable-wraparound-focus true

# Navegación entre ventanas estilo tiling WM
gsettings set "$SCHEMA" focus-window-left "['<Super>h']"
gsettings set "$SCHEMA" focus-window-down "['<Super>j']"
gsettings set "$SCHEMA" focus-window-up "['<Super>k']"
gsettings set "$SCHEMA" focus-window-right "['<Super>l']"

gsettings set "$SCHEMA" enable-directional-focus-tiled-only true


# Apariencia
gsettings set "$SCHEMA" enable-smart-window-border-radius true
gsettings set "$SCHEMA" enable-window-border false

# Indicador de layouts
gsettings set "$SCHEMA" show-indicator true

# Snap Assistant
gsettings set "$SCHEMA" snap-assistant-threshold 54
gsettings set "$SCHEMA" snap-assistant-animation-time 180
gsettings set "$SCHEMA" tile-preview-animation-time 100

echo
echo "Tiling Shell configurado correctamente."
echo
echo "Atajos principales:"
echo "  Super + ←  mover/encajar izquierda"
echo "  Super + →  mover/encajar derecha"
echo "  Super + ↑  mover/encajar arriba"
echo "  Super + ↓  mover/encajar abajo"
