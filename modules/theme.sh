#!/usr/bin/env bash

set -e

echo "======================================"
echo "       MAOSPY RICE - THEME"
echo "======================================"

echo
echo "Configurando apariencia de GNOME..."

# Modo oscuro
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Botones de ventana
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

# Fuente general
gsettings set org.gnome.desktop.interface font-name 'Adwaita Sans 11'
gsettings set org.gnome.desktop.interface document-font-name 'Adwaita Sans 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Adwaita Sans Bold 11'

# Fuente monoespaciada
gsettings set org.gnome.desktop.interface monospace-font-name 'Adwaita Mono 11'

# Animaciones
gsettings set org.gnome.desktop.interface enable-animations true

# Reloj
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-show-seconds false

# Tema de cursor
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'

echo
echo "Configuración base aplicada."
echo
echo "Modo oscuro:          activado"
echo "Minimizar/maximizar:  activados"
echo "Fuente:               Adwaita Sans"
echo "Terminal:             Adwaita Mono"
echo "Día de semana:        visible"
