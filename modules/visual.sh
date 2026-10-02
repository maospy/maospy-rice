#!/usr/bin/env bash

set -e

echo "======================================"
echo "       MAOSPY RICE - VISUAL"
echo "======================================"

THEME="Nordic"

USER_THEME_DIR="$HOME/.local/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com"
USER_THEME_SCHEMA="$USER_THEME_DIR/schemas"

ROUNDED_DIR="$HOME/.local/share/gnome-shell/extensions/rounded-window-corners@fxgn"
ROUNDED_SCHEMA_DIR="$ROUNDED_DIR/schemas"

DOCK_DIR="$HOME/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"
DOCK_SCHEMA_DIR="$DOCK_DIR/schemas"

BLUR_DIR="$HOME/.local/share/gnome-shell/extensions/blur-my-shell@aunetx"
BLUR_SCHEMA_DIR="$BLUR_DIR/schemas"

TILING_DIR="$HOME/.local/share/gnome-shell/extensions/tilingshell@ferrarodomenico.com"
TILING_SCHEMA_DIR="$TILING_DIR/schemas"

echo
echo "[1/6] Aplicando tema Nordic..."

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme "$THEME"
gsettings set org.gnome.desktop.wm.preferences theme "$THEME"


echo
echo "[2/6] Tema GNOME Shell..."

if [[ -f "$USER_THEME_SCHEMA/gschemas.compiled" ]]; then
    GSETTINGS_SCHEMA_DIR="$USER_THEME_SCHEMA" \
    gsettings set org.gnome.shell.extensions.user-theme name "$THEME"

    echo "GNOME Shell -> $THEME"
else
    echo "ADVERTENCIA: esquema de User Themes no encontrado."
fi


echo
echo "[3/6] Ventanas redondeadas..."

if [[ -f "$ROUNDED_SCHEMA_DIR/gschemas.compiled" ]]; then

    export GSETTINGS_SCHEMA_DIR="$ROUNDED_SCHEMA_DIR"

    # Aplicar también a aplicaciones modernas libadwaita
    gsettings set \
      org.gnome.shell.extensions.rounded-window-corners-reborn \
      skip-libadwaita-app false

    # Borde sutil
    gsettings set \
      org.gnome.shell.extensions.rounded-window-corners-reborn \
      border-width 1

    # Mantener sombra limpia
    gsettings set \
      org.gnome.shell.extensions.rounded-window-corners-reborn \
      keep-shadow-for-maximized-fullscreen false

    echo "Rounded Window Corners configurado."
fi


echo
echo "[4/6] Dock flotante..."

if [[ -f "$DOCK_SCHEMA_DIR/gschemas.compiled" ]]; then

    export GSETTINGS_SCHEMA_DIR="$DOCK_SCHEMA_DIR"

    SCHEMA="org.gnome.shell.extensions.dash-to-dock"

    gsettings set "$SCHEMA" dock-position 'BOTTOM'
    gsettings set "$SCHEMA" extend-height false
    gsettings set "$SCHEMA" dash-max-icon-size 38

    gsettings set "$SCHEMA" autohide true
    gsettings set "$SCHEMA" intellihide true

    gsettings set "$SCHEMA" transparency-mode 'DYNAMIC'
    gsettings set "$SCHEMA" running-indicator-style 'DOTS'

    gsettings set "$SCHEMA" show-trash false
    gsettings set "$SCHEMA" show-mounts false

    echo "Dock flotante configurado."
fi


echo
echo "[5/6] Blur..."

if [[ -f "$BLUR_SCHEMA_DIR/gschemas.compiled" ]]; then

    export GSETTINGS_SCHEMA_DIR="$BLUR_SCHEMA_DIR"

    BASE="org.gnome.shell.extensions.blur-my-shell"

    # Panel superior
    gsettings set "$BASE.panel" blur true
    gsettings set "$BASE.panel" brightness 0.55
    gsettings set "$BASE.panel" sigma 35
    gsettings set "$BASE.panel" override-background true
    gsettings set "$BASE.panel" static-blur true

    # Dock
    gsettings set "$BASE.dash-to-dock" blur true
    gsettings set "$BASE.dash-to-dock" brightness 0.55
    gsettings set "$BASE.dash-to-dock" sigma 35
    gsettings set "$BASE.dash-to-dock" corner-radius 20
    gsettings set "$BASE.dash-to-dock" override-background true
    gsettings set "$BASE.dash-to-dock" static-blur true
    gsettings set "$BASE.dash-to-dock" pipeline 'pipeline_default_rounded'

    # Overview
    gsettings set "$BASE.overview" blur true
    gsettings set "$BASE.overview" brightness 0.55
    gsettings set "$BASE.overview" sigma 35

    echo "Blur reforzado."
fi


echo
echo "[6/6] Gaps y tiling..."

if [[ -f "$TILING_SCHEMA_DIR/gschemas.compiled" ]]; then

    export GSETTINGS_SCHEMA_DIR="$TILING_SCHEMA_DIR"

    SCHEMA="org.gnome.shell.extensions.tilingshell"

    gsettings set "$SCHEMA" inner-gaps 14
    gsettings set "$SCHEMA" outer-gaps 10
    gsettings set "$SCHEMA" enable-smart-window-border-radius true
    gsettings set "$SCHEMA" enable-tiling-system true
    gsettings set "$SCHEMA" enable-snap-assist true

    echo "Gaps visuales aplicados."
fi


echo
echo "======================================"
echo "     MAOSPY RICE VISUAL APLICADO"
echo "======================================"
echo
echo "Tema:             Nordic"
echo "Shell:            Nordic"
echo "Dock:             flotante / 38 px"
echo "Blur:             35"
echo "Gaps internos:    14"
echo "Gaps externos:    10"
echo "Ventanas:         redondeadas"
echo
echo "Cerrá sesión y volvé a entrar si algún"
echo "cambio del GNOME Shell no aparece aún."
