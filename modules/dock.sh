#!/usr/bin/env bash

set -e

EXT_DIR="$HOME/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"
SCHEMA_DIR="$EXT_DIR/schemas"
SCHEMA="org.gnome.shell.extensions.dash-to-dock"

echo "======================================"
echo "        MAOSPY RICE - DOCK"
echo "======================================"

if [[ ! -f "$SCHEMA_DIR/gschemas.compiled" ]]; then
    echo "ERROR: No se encontró gschemas.compiled"
    exit 1
fi

export GSETTINGS_SCHEMA_DIR="$SCHEMA_DIR"

echo
echo "Configurando Dash to Dock..."

gsettings set "$SCHEMA" dock-position 'BOTTOM'
gsettings set "$SCHEMA" extend-height false
gsettings set "$SCHEMA" dash-max-icon-size 40
gsettings set "$SCHEMA" autohide true
gsettings set "$SCHEMA" intellihide true
gsettings set "$SCHEMA" show-mounts false
gsettings set "$SCHEMA" show-trash false
gsettings set "$SCHEMA" show-show-apps-button true
gsettings set "$SCHEMA" transparency-mode 'DYNAMIC'
gsettings set "$SCHEMA" running-indicator-style 'DOTS'

echo
echo "Dash to Dock configurado correctamente."
