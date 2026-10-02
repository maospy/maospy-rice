#!/usr/bin/env bash

set -e

echo "======================================"
echo "     MAOSPY RICE - DEVTOOLS"
echo "======================================"

# =====================================
# Claude Code
# =====================================

echo
echo "[1/2] Claude Code..."

NPM_PREFIX="$HOME/.local/npm"
NPM_BIN="$NPM_PREFIX/bin"

mkdir -p "$NPM_PREFIX"

npm config set prefix "$NPM_PREFIX"

# Agregar Claude/npm global al PATH permanentemente
PATH_LINE='export PATH="$HOME/.local/npm/bin:$PATH"'

if ! grep -Fxq "$PATH_LINE" "$HOME/.bashrc" 2>/dev/null; then
    echo "$PATH_LINE" >> "$HOME/.bashrc"
fi

export PATH="$NPM_BIN:$PATH"

if command -v claude >/dev/null 2>&1; then

    echo "Claude Code ya está instalado:"
    claude --version

else

    echo "Instalando Claude Code..."

    npm install -g @anthropic-ai/claude-code

    export PATH="$NPM_BIN:$PATH"

    if command -v claude >/dev/null 2>&1; then
        echo "Claude Code instalado correctamente:"
        claude --version
    else
        echo "ERROR: Claude fue instalado pero no aparece en PATH."
        echo "Ruta esperada:"
        echo "$NPM_BIN/claude"
        exit 1
    fi
fi


# =====================================
# Docker
# =====================================

echo
echo "[2/2] Docker Engine..."

if ! command -v docker >/dev/null 2>&1; then

    echo "Agregando repositorio oficial de Docker..."

    sudo dnf config-manager addrepo \
        --from-repofile \
        https://download.docker.com/linux/fedora/docker-ce.repo

    echo
    echo "Instalando Docker..."

    sudo dnf install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

else
    echo "Docker ya está instalado:"
    docker --version
fi


echo
echo "Activando servicios Docker..."

sudo systemctl enable --now docker
sudo systemctl enable containerd


# =====================================
# Grupo Docker
# =====================================

if ! getent group docker >/dev/null 2>&1; then
    sudo groupadd docker
fi

if id -nG "$USER" | grep -qw docker; then

    echo "$USER ya pertenece al grupo docker."

else

    echo "Agregando $USER al grupo docker..."

    sudo usermod -aG docker "$USER"

    echo
    echo "IMPORTANTE:"
    echo "El usuario fue agregado al grupo docker."
    echo
    echo "Para activar el permiso inmediatamente podés ejecutar:"
    echo
    echo "    newgrp docker"
    echo
    echo "O cerrar sesión y volver a entrar."
fi


echo
echo "======================================"
echo "       DEVTOOLS CONFIGURADOS"
echo "======================================"

echo
echo "Claude Code:"
claude --version 2>/dev/null || true

echo
echo "Docker:"
docker --version 2>/dev/null || true

echo
echo "Docker Compose:"
docker compose version 2>/dev/null || true

echo
echo "Estado Docker:"
systemctl is-active docker 2>/dev/null || true
