#!/usr/bin/env bash

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

STATE_DIR="$HOME/.local/state/maospy-rice"
RELOGIN_FILE="$STATE_DIR/relogin-required"

mkdir -p "$STATE_DIR"

ask_yes_no() {
    local prompt="$1"
    local default="${2:-y}"
    local answer

    if [[ "$default" == "y" ]]; then
        read -r -p "$prompt [S/n]: " answer
        answer="${answer:-s}"
    else
        read -r -p "$prompt [s/N]: " answer
        answer="${answer:-n}"
    fi

    case "$answer" in
        s|S|si|SI|sí|Sí|y|Y)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

echo "======================================"
echo "        MAOSPY RICE INSTALLER"
echo "======================================"
echo

# =====================================
# 1. Paquetes base
# =====================================

echo "[1/10] Paquetes base..."
"$BASE_DIR/modules/packages.sh"


# =====================================
# 2. Extensiones GNOME
# =====================================

echo
echo "[2/10] Extensiones GNOME..."

"$BASE_DIR/modules/extensions.sh"

if [[ -f "$RELOGIN_FILE" ]]; then
    echo
    echo "======================================"
    echo "   REINICIO DE SESIÓN NECESARIO"
    echo "======================================"
    echo
    echo "Se instalaron nuevas extensiones de GNOME."
    echo
    echo "GNOME necesita recargar la sesión antes"
    echo "de poder habilitarlas correctamente."
    echo
    echo "Cerrá sesión y volvé a entrar."
    echo
    echo "Después ejecutá nuevamente:"
    echo
    echo "    ./install.sh"
    echo
    exit 0
fi


# =====================================
# 3. Dock
# =====================================

echo
echo "[3/10] Dash to Dock..."
"$BASE_DIR/modules/dock.sh"


# =====================================
# 4. Tiling
# =====================================

echo
echo "[4/10] Tiling Shell..."
"$BASE_DIR/modules/tiling.sh"


# =====================================
# 5. Blur
# =====================================

echo
echo "[5/10] Blur my Shell..."
"$BASE_DIR/modules/blur.sh"


# =====================================
# 6. Apariencia base
# =====================================

echo
echo "[6/10] Apariencia base..."
"$BASE_DIR/modules/theme.sh"


# =====================================
# 7. GNOME
# =====================================

echo
echo "[7/10] GNOME..."
"$BASE_DIR/modules/gnome.sh"


# =====================================
# 8. Identidad visual
# =====================================

echo
echo "[8/10] Identidad visual..."
"$BASE_DIR/modules/visual.sh"


# =====================================
# 9. Iconos
# =====================================

echo
echo "[9/10] Iconos..."
"$BASE_DIR/modules/icons.sh"


# =====================================
# 10. Wallpaper
# =====================================

echo
echo "[10/10] Wallpaper..."
"$BASE_DIR/modules/wallpaper.sh"


# =====================================
# Componentes opcionales
# =====================================

echo
echo "======================================"
echo "       COMPONENTES OPCIONALES"
echo "======================================"

echo
echo "--------------------------------------"
echo " APLICACIONES PRINCIPALES"
echo "--------------------------------------"
echo
echo "Se instalarán:"
echo
echo "  • Google Chrome Stable"
echo "  • Visual Studio Code"
echo "  • Node.js"
echo "  • npm"
echo "  • Spotify"
echo

if ask_yes_no "¿Instalar estas aplicaciones?" y; then
    "$BASE_DIR/modules/apps.sh"
else
    echo "Aplicaciones principales omitidas."
fi


echo
echo "--------------------------------------"
echo " HERRAMIENTAS DE DESARROLLO"
echo "--------------------------------------"
echo
echo "Se instalarán/configurarán:"
echo
echo "  • Claude Code CLI"
echo "  • Docker Engine"
echo "  • Docker Compose"
echo
echo "También se configurará:"
echo "  • servicio Docker"
echo "  • grupo docker para el usuario"
echo

if ask_yes_no "¿Instalar estas herramientas de desarrollo?" y; then
    "$BASE_DIR/modules/devtools.sh"
else
    echo "Herramientas de desarrollo omitidas."
fi


echo
echo "--------------------------------------"
echo " XAMPP"
echo "--------------------------------------"
echo
echo "Se instalará:"
echo
echo "  • XAMPP 8.2.12"
echo "  • Apache"
echo "  • PHP 8.2"
echo "  • MariaDB / MySQL"
echo "  • phpMyAdmin"
echo "  • ProFTPD"
echo
echo "También se instalarán las librerías"
echo "de compatibilidad necesarias para Fedora 44."
echo

if ask_yes_no "¿Instalar XAMPP?" n; then
    "$BASE_DIR/modules/xampp.sh"
else
    echo "XAMPP omitido."
fi


# =====================================
# Final
# =====================================

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
