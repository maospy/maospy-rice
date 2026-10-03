#!/usr/bin/env bash

set -e

echo "======================================"
echo "     MAOSPY RICE - DEVTOOLS"
echo "======================================"

# =====================================
# Funciones
# =====================================

ensure_local_bin_path() {
    mkdir -p "$HOME/.local/bin"

    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi

    if ! grep -Fq 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
}

ensure_npm_user_prefix() {
    mkdir -p "$HOME/.local/npm"

    npm config set prefix "$HOME/.local/npm"

    if [[ ":$PATH:" != *":$HOME/.local/npm/bin:"* ]]; then
        export PATH="$HOME/.local/npm/bin:$PATH"
    fi

    if ! grep -Fq 'export PATH="$HOME/.local/npm/bin:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/npm/bin:$PATH"' >> "$HOME/.bashrc"
    fi
}

ensure_local_bin_path
ensure_npm_user_prefix

# =====================================
# 1. Claude Code
# =====================================

echo
echo "[1/3] Claude Code..."

if command -v claude >/dev/null 2>&1; then
    echo "Claude Code ya está instalado:"
    claude --version
else
    echo "Instalando Claude Code..."

    npm install -g @anthropic-ai/claude-code

    export PATH="$HOME/.local/npm/bin:$PATH"

    if command -v claude >/dev/null 2>&1; then
        echo "Claude Code instalado correctamente:"
        claude --version
    else
        echo "ERROR: Claude Code se instaló pero no se encontró en PATH."
        exit 1
    fi
fi

if [[ -x "$HOME/.local/npm/bin/claude" ]]; then
    ln -sfn "$HOME/.local/npm/bin/claude" "$HOME/.local/bin/claude"
fi

# =====================================
# 2. OpenAI Codex CLI
# =====================================

echo
echo "[2/3] OpenAI Codex CLI..."

if command -v codex >/dev/null 2>&1; then
    echo "Codex CLI ya está instalado:"
    codex --version
else
    echo "Instalando OpenAI Codex CLI..."

    curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh

    export PATH="$HOME/.local/bin:$PATH"

    if command -v codex >/dev/null 2>&1; then
        echo "Codex CLI instalado correctamente:"
        codex --version
    else
        echo "ERROR: Codex CLI se instaló pero no se encontró en PATH."
        echo "Probá abrir una terminal nueva o ejecutar:"
        echo "source ~/.bashrc"
        exit 1
    fi
fi

# =====================================
# 3. Docker Engine + Compose
# =====================================

echo
echo "[3/3] Docker Engine..."

if command -v docker >/dev/null 2>&1; then
    echo "Docker ya está instalado:"
    docker --version
else
    echo "Instalando Docker..."

    sudo dnf -y install dnf-plugins-core

    sudo dnf config-manager addrepo \
        --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

    sudo dnf install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
fi

echo
echo "Activando servicios Docker..."

sudo systemctl enable --now docker

if ! groups "$USER" | grep -qw docker; then
    echo "Agregando $USER al grupo docker..."
    sudo usermod -aG docker "$USER"

    echo
    echo "AVISO:"
    echo "Cerrá sesión y volvé a entrar"
    echo "para usar Docker sin sudo."
else
    echo "$USER ya pertenece al grupo docker."
fi

# =====================================
# Verificación
# =====================================

echo
echo "======================================"
echo "          VERIFICACIÓN"
echo "======================================"

echo
echo "Claude Code:"
if command -v claude >/dev/null 2>&1; then
    claude --version
else
    echo "No disponible"
fi

echo
echo "Codex CLI:"
if command -v codex >/dev/null 2>&1; then
    codex --version
else
    echo "No disponible"
fi

echo
echo "Docker:"
docker --version

echo
echo "Docker Compose:"
docker compose version

echo
echo "Estado Docker:"
systemctl is-active docker || true

echo
echo "======================================"
echo "     DEVTOOLS CONFIGURADAS"
echo "======================================"

echo
echo "Claude Code y Codex CLI fueron configurados."
echo
echo "Si esta terminal fue abierta antes de la instalación,"
echo "podés ejecutar:"
echo
echo "    source ~/.bashrc"
echo
