#!/usr/bin/env bash

set -e

echo "======================================"
echo "      MAOSPY RICE - PAQUETES BASE"
echo "======================================"

if [[ "$EUID" -eq 0 ]]; then
    echo "No ejecutes este script como root."
    exit 1
fi

echo
echo "[1/2] Actualizando metadatos..."
sudo dnf makecache

echo
echo "[2/2] Instalando paquetes base..."

sudo dnf install -y \
    git \
    curl \
    wget \
    jq \
    unzip \
    tree \
    gnome-tweaks \
    gnome-extensions-app \
    dconf-editor

echo
echo "Paquetes base instalados correctamente."
