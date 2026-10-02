#!/usr/bin/env bash

set -e

echo "======================================"
echo "     MAOSPY RICE - EXTENSIONES"
echo "======================================"

EXTENSIONS=(
    "tilingshell@ferrarodomenico.com"
    "blur-my-shell@aunetx"
    "dash-to-dock@micxgx.gmail.com"
)

echo
echo "GNOME detectado:"
gnome-shell --version

echo
echo "Comprobando extensiones..."

for extension in "${EXTENSIONS[@]}"; do
    if gnome-extensions list | grep -Fxq "$extension"; then
        echo "[OK] $extension instalada"

        if gnome-extensions enable "$extension" 2>/dev/null; then
            echo "     habilitada"
        else
            echo "     ya estaba habilitada o requiere reiniciar sesión"
        fi
    else
        echo "[FALTA] $extension"
    fi
done

echo
echo "Estado final:"
gnome-extensions list --enabled

echo
echo "Módulo de extensiones completado."
