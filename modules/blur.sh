#!/usr/bin/env bash

set -e

EXT_DIR="$HOME/.local/share/gnome-shell/extensions/blur-my-shell@aunetx"
SCHEMA_DIR="$EXT_DIR/schemas"

BASE="org.gnome.shell.extensions.blur-my-shell"
PANEL="$BASE.panel"
OVERVIEW="$BASE.overview"
DOCK="$BASE.dash-to-dock"
APPFOLDER="$BASE.appfolder"
LOCKSCREEN="$BASE.lockscreen"

echo "======================================"
echo "       MAOSPY RICE - BLUR"
echo "======================================"

if [[ ! -f "$SCHEMA_DIR/gschemas.compiled" ]]; then
    echo "ERROR: No se encontró el esquema compilado de Blur my Shell."
    exit 1
fi

export GSETTINGS_SCHEMA_DIR="$SCHEMA_DIR"

if ! gsettings list-schemas | grep -Fxq "$BASE"; then
    echo "ERROR: No se encontró el esquema de Blur my Shell."
    exit 1
fi

echo
echo "Configurando Blur my Shell..."

# Configuración general
gsettings set "$BASE" sigma 30
gsettings set "$BASE" brightness 0.60
gsettings set "$BASE" noise-amount 0.0

# Panel superior
gsettings set "$PANEL" blur true
gsettings set "$PANEL" static-blur true
gsettings set "$PANEL" override-background true
gsettings set "$PANEL" brightness 0.60
gsettings set "$PANEL" sigma 30
gsettings set "$PANEL" corner-radius 0

# Overview
gsettings set "$OVERVIEW" blur true
gsettings set "$OVERVIEW" brightness 0.60
gsettings set "$OVERVIEW" sigma 30

# Dash to Dock
gsettings set "$DOCK" blur true
gsettings set "$DOCK" static-blur true
gsettings set "$DOCK" override-background true
gsettings set "$DOCK" brightness 0.60
gsettings set "$DOCK" sigma 30
gsettings set "$DOCK" corner-radius 18
gsettings set "$DOCK" pipeline 'pipeline_default_rounded'

# Carpetas de aplicaciones
gsettings set "$APPFOLDER" blur true
gsettings set "$APPFOLDER" brightness 0.60
gsettings set "$APPFOLDER" sigma 30

# Pantalla de bloqueo
gsettings set "$LOCKSCREEN" blur true
gsettings set "$LOCKSCREEN" brightness 0.60
gsettings set "$LOCKSCREEN" sigma 30

echo
echo "Blur my Shell configurado correctamente."
echo
echo "Ajustes:"
echo "  Blur general:        30"
echo "  Brillo:              60%"
echo "  Panel superior:      activado"
echo "  Overview:            activado"
echo "  Dash to Dock:        activado"
echo "  Dock redondeado:     18 px"
echo "  App folders:         activado"
echo "  Lock screen:         activado"
