#!/usr/bin/env bash

set -e

echo "======================================"
echo "     MAOSPY RICE - UNINSTALLER"
echo "======================================"
echo
echo "Este proceso quitará la personalización"
echo "visual de Maospy Rice."
echo
echo "NO eliminará:"
echo "  • Google Chrome"
echo "  • Visual Studio Code"
echo "  • Spotify"
echo "  • Node.js / npm"
echo "  • Claude Code"
echo "  • Codex"
echo "  • Docker"
echo "  • Docker Compose"
echo "  • XAMPP"
echo "  • tus proyectos y archivos personales"
echo

read -r -p "¿Continuar con la desinstalación? [s/N]: " ANSWER

case "$ANSWER" in
    s|S|si|SI|sí|Sí|y|Y)
        ;;
    *)
        echo
        echo "Desinstalación cancelada."
        exit 0
        ;;
esac


echo
echo "[1/7] Deshabilitando extensiones..."

EXTENSIONS=(
    "tilingshell@ferrarodomenico.com"
    "blur-my-shell@aunetx"
    "dash-to-dock@micxgx.gmail.com"
    "user-theme@gnome-shell-extensions.gcampax.github.com"
    "rounded-window-corners@fxgn"
)

for extension in "${EXTENSIONS[@]}"; do

    if gnome-extensions list 2>/dev/null | grep -Fxq "$extension"; then
        gnome-extensions disable "$extension" 2>/dev/null || true
        echo "[OK] $extension"
    fi

done


echo
echo "[2/7] Restaurando apariencia GNOME..."

gsettings reset org.gnome.desktop.interface gtk-theme || true
gsettings reset org.gnome.desktop.interface icon-theme || true
gsettings reset org.gnome.desktop.interface color-scheme || true
gsettings reset org.gnome.desktop.interface font-name || true
gsettings reset org.gnome.desktop.interface document-font-name || true
gsettings reset org.gnome.desktop.interface monospace-font-name || true
gsettings reset org.gnome.desktop.interface cursor-theme || true

gsettings reset org.gnome.desktop.wm.preferences theme || true
gsettings reset org.gnome.desktop.wm.preferences titlebar-font || true
gsettings reset org.gnome.desktop.wm.preferences button-layout || true


echo
echo "[3/7] Restaurando comportamiento GNOME..."

gsettings reset org.gnome.mutter dynamic-workspaces || true
gsettings reset org.gnome.mutter center-new-windows || true

gsettings reset org.gnome.desktop.interface show-battery-percentage || true
gsettings reset org.gnome.desktop.interface clock-show-weekday || true
gsettings reset org.gnome.desktop.interface clock-show-seconds || true

gsettings reset org.gnome.desktop.wm.keybindings switch-applications || true
gsettings reset org.gnome.desktop.wm.keybindings switch-applications-backward || true

gsettings reset org.gnome.nautilus.preferences default-folder-viewer || true
gsettings reset org.gnome.nautilus.preferences show-create-link || true
gsettings reset org.gnome.nautilus.preferences show-delete-permanently || true
gsettings reset org.gnome.nautilus.preferences recursive-search || true

gsettings reset org.gnome.desktop.peripherals.mouse accel-profile || true

if gsettings list-schemas | grep -Fxq \
    org.gnome.desktop.peripherals.touchpad; then

    gsettings reset \
        org.gnome.desktop.peripherals.touchpad tap-to-click || true

    gsettings reset \
        org.gnome.desktop.peripherals.touchpad natural-scroll || true
fi


echo
echo "[4/7] Restaurando wallpaper..."

gsettings reset \
    org.gnome.desktop.background picture-uri || true

gsettings reset \
    org.gnome.desktop.background picture-uri-dark || true

gsettings reset \
    org.gnome.desktop.background picture-options || true


echo
echo "[5/7] Eliminando temas e iconos de Maospy Rice..."

rm -rf "$HOME/.themes/Nordic"

rm -rf "$HOME/.local/share/icons/Tela-circle-nord"
rm -rf "$HOME/.local/share/icons/Tela-circle-nord-dark"
rm -rf "$HOME/.local/share/icons/Tela-circle-nord-light"

echo "Temas e iconos eliminados."


echo
echo "[6/7] Eliminando extensiones instaladas por Maospy Rice..."

for extension in "${EXTENSIONS[@]}"; do

    EXT_DIR="$HOME/.local/share/gnome-shell/extensions/$extension"

    if [[ -d "$EXT_DIR" ]]; then
        rm -rf "$EXT_DIR"
        echo "[OK] Eliminada: $extension"
    fi

done


echo
echo "[7/7] Limpiando estado de Maospy Rice..."

rm -rf "$HOME/.local/state/maospy-rice"

echo
echo "======================================"
echo "     MAOSPY RICE DESINSTALADO"
echo "======================================"
echo
echo "La personalización fue eliminada."
echo
echo "Las aplicaciones y herramientas de"
echo "desarrollo fueron conservadas."
echo
echo "Cerrá sesión y volvé a entrar para"
echo "que GNOME recargue completamente."
