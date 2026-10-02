#!/usr/bin/env bash

set -e

echo "======================================"
echo "       MAOSPY RICE - ICONOS"
echo "======================================"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

cd "$TMP_DIR"

echo
echo "Descargando Tela Circle..."

git clone --depth=1 \
  https://github.com/vinceliuice/Tela-circle-icon-theme.git

cd Tela-circle-icon-theme

echo
echo "Instalando variante Nord..."

./install.sh nord

echo
echo "Aplicando tema de iconos..."

if [[ -d "$HOME/.local/share/icons/Tela-circle-nord" ]]; then
    gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-nord'
    echo "Tema aplicado: Tela-circle-nord"
else
    echo "ERROR: No se encontró Tela-circle-nord."
    exit 1
fi

echo
echo "Iconos configurados correctamente."
