#!/usr/bin/env bash

set -e

echo "======================================"
echo "     MAOSPY RICE - EXTENSIONES"
echo "======================================"

GNOME_MAJOR="$(gnome-shell --version | grep -oE '[0-9]+' | head -1)"

STATE_DIR="$HOME/.local/state/maospy-rice"
RELOGIN_FILE="$STATE_DIR/relogin-required"

mkdir -p "$STATE_DIR"

declare -A EXTENSIONS

EXTENSIONS["tilingshell@ferrarodomenico.com"]="7065"
EXTENSIONS["blur-my-shell@aunetx"]="3193"
EXTENSIONS["dash-to-dock@micxgx.gmail.com"]="307"
EXTENSIONS["user-theme@gnome-shell-extensions.gcampax.github.com"]="19"
EXTENSIONS["rounded-window-corners@fxgn"]="7048"

TMP_DIR="$(mktemp -d)"
NEW_EXTENSIONS=false

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

install_extension() {
    local UUID="$1"
    local EXT_ID="$2"

    if [[ -d "$HOME/.local/share/gnome-shell/extensions/$UUID" ]]; then
        echo "[OK] $UUID ya está instalada"
        return
    fi

    echo
    echo "[INSTALANDO] $UUID"

    local INFO_URL
    local DOWNLOAD_URL
    local ZIP_FILE

    INFO_URL="https://extensions.gnome.org/extension-info/?pk=${EXT_ID}&shell_version=${GNOME_MAJOR}"

    DOWNLOAD_URL="$(
        curl -fsSL "$INFO_URL" |
        jq -r '.download_url // empty'
    )"

    if [[ -z "$DOWNLOAD_URL" ]]; then
        echo "ERROR: No existe versión compatible con GNOME $GNOME_MAJOR"
        echo "Extensión: $UUID"
        exit 1
    fi

    ZIP_FILE="$TMP_DIR/${EXT_ID}.zip"

    curl -fL \
        "https://extensions.gnome.org${DOWNLOAD_URL}" \
        -o "$ZIP_FILE"

    gnome-extensions install --force "$ZIP_FILE"

    NEW_EXTENSIONS=true

    echo "[OK] $UUID instalada"
}

echo
echo "GNOME detectado:"
gnome-shell --version

echo
echo "Comprobando extensiones..."

for UUID in "${!EXTENSIONS[@]}"; do
    install_extension "$UUID" "${EXTENSIONS[$UUID]}"
done

if [[ "$NEW_EXTENSIONS" == true ]]; then
    touch "$RELOGIN_FILE"

    echo
    echo "======================================"
    echo "     NUEVAS EXTENSIONES INSTALADAS"
    echo "======================================"
    echo
    echo "GNOME necesita recargar la sesión."
    echo
    echo "Cerrá sesión y volvé a entrar."
    echo
    echo "Luego ejecutá nuevamente:"
    echo
    echo "    ./install.sh"
    echo

    exit 0
fi

rm -f "$RELOGIN_FILE"

echo
echo "Habilitando extensiones..."

ENABLE_ERROR=false

for UUID in "${!EXTENSIONS[@]}"; do

    if gnome-extensions list | grep -Fxq "$UUID"; then

        if gnome-extensions enable "$UUID" 2>/dev/null; then
            echo "[OK] $UUID habilitada"
        else
            echo "[ERROR] No se pudo habilitar $UUID"
            ENABLE_ERROR=true
        fi

    else

        echo "[ERROR] GNOME todavía no reconoce:"
        echo "$UUID"

        ENABLE_ERROR=true
    fi

done

if [[ "$ENABLE_ERROR" == true ]]; then
    touch "$RELOGIN_FILE"

    echo
    echo "======================================"
    echo "   REINICIO DE SESIÓN NECESARIO"
    echo "======================================"
    echo
    echo "GNOME todavía no cargó todas las extensiones."
    echo "Cerrá sesión y volvé a entrar."
    echo
    exit 0
fi

echo
echo "Extensiones activas:"
gnome-extensions list --enabled

echo
echo "======================================"
echo " Extensiones Maospy Rice configuradas"
echo "======================================"
