#!/usr/bin/env bash

set -e

echo "======================================"
echo "     MAOSPY RICE - EXTENSIONES"
echo "======================================"

GNOME_MAJOR="$(gnome-shell --version | grep -oE '[0-9]+' | head -1)"

if [[ "$GNOME_MAJOR" != "50" ]]; then
    echo "ADVERTENCIA: Maospy Rice v0.1 fue probado con GNOME 50."
    echo "GNOME detectado: $GNOME_MAJOR"
fi

declare -A EXTENSIONS

EXTENSIONS["tilingshell@ferrarodomenico.com"]="7065"
EXTENSIONS["blur-my-shell@aunetx"]="3193"
EXTENSIONS["dash-to-dock@micxgx.gmail.com"]="307"
EXTENSIONS["user-theme@gnome-shell-extensions.gcampax.github.com"]="19"
EXTENSIONS["rounded-window-corners@fxgn"]="7048"

TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

install_extension() {

    UUID="$1"
    EXT_ID="$2"

    if gnome-extensions list | grep -Fxq "$UUID"; then
        echo "[OK] $UUID ya está instalada"
        return
    fi

    echo
    echo "[INSTALANDO] $UUID"

    INFO_URL="https://extensions.gnome.org/extension-info/?pk=${EXT_ID}&shell_version=${GNOME_MAJOR}"

    DOWNLOAD_URL="$(curl -fsSL "$INFO_URL" | jq -r '.download_url // empty')"

    if [[ -z "$DOWNLOAD_URL" ]]; then
        echo "ERROR: No se encontró una versión compatible para GNOME $GNOME_MAJOR"
        echo "Extensión: $UUID"
        exit 1
    fi

    ZIP_FILE="$TMP_DIR/${EXT_ID}.zip"

    curl -fL \
        "https://extensions.gnome.org${DOWNLOAD_URL}" \
        -o "$ZIP_FILE"

    gnome-extensions install --force "$ZIP_FILE"

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

echo
echo "Habilitando extensiones..."

for UUID in "${!EXTENSIONS[@]}"; do

    if gnome-extensions list | grep -Fxq "$UUID"; then

        if gnome-extensions enable "$UUID" 2>/dev/null; then
            echo "[OK] $UUID habilitada"
        else
            echo "[INFO] $UUID instalada; puede requerir cerrar sesión"
        fi

    else
        echo "[ERROR] $UUID no aparece instalada"
    fi

done

echo
echo "======================================"
echo " Extensiones de Maospy Rice listas"
echo "======================================"

echo
echo "Instaladas:"
gnome-extensions list

echo
echo "IMPORTANTE:"
echo "Si alguna extensión recién instalada no aparece activa,"
echo "cerrá la sesión de GNOME y volvé a entrar."
