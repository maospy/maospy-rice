#!/usr/bin/env bash

set -e

echo "======================================"
echo "       MAOSPY RICE - GNOME"
echo "======================================"

echo
echo "Configurando comportamiento de GNOME..."

# Workspaces dinámicos
gsettings set org.gnome.mutter dynamic-workspaces true

# Número de workspaces fijo queda ignorado mientras dynamic-workspaces=true
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4

# Centrar nuevas ventanas cuando sea posible
gsettings set org.gnome.mutter center-new-windows true

# Alt+Tab: solo aplicaciones
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Alt>Tab']"

# Mostrar porcentaje de batería
gsettings set org.gnome.desktop.interface show-battery-percentage true

# Nautilus
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.preferences show-create-link true
gsettings set org.gnome.nautilus.preferences show-delete-permanently true

# Papelera y unidades en escritorio no aplican al GNOME moderno sin extensión,
# pero dejamos Nautilus preparado.
gsettings set org.gnome.nautilus.preferences recursive-search 'always'

# Touchpad
if gsettings list-schemas | grep -Fxq org.gnome.desktop.peripherals.touchpad; then
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
fi

# Ratón
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'default'

echo
echo "GNOME configurado correctamente."
