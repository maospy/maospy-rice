#!/usr/bin/env bash

set -e

echo "======================================"
echo "        MAOSPY RICE - APPS"
echo "======================================"

echo
echo "[1/4] Google Chrome Stable..."

if ! command -v google-chrome-stable >/dev/null 2>&1; then
    TMP_RPM="/tmp/google-chrome-stable.rpm"

    curl -L \
      https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm \
      -o "$TMP_RPM"

    sudo dnf install -y "$TMP_RPM"
    rm -f "$TMP_RPM"
else
    echo "Google Chrome ya está instalado."
fi


echo
echo "[2/4] Visual Studio Code..."

if ! command -v code >/dev/null 2>&1; then

    sudo rpm --import \
      https://packages.microsoft.com/keys/microsoft.asc

    sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

    sudo dnf install -y code
else
    echo "Visual Studio Code ya está instalado."
fi


echo
echo "[3/4] Node.js..."

if ! command -v node >/dev/null 2>&1; then
    sudo dnf install -y nodejs npm
else
    echo "Node.js ya está instalado:"
    node --version
fi


echo
echo "[4/4] Spotify..."

flatpak remote-add --if-not-exists \
    flathub \
    https://flathub.org/repo/flathub.flatpakrepo

if ! flatpak list --app | grep -q com.spotify.Client; then
    flatpak install -y flathub com.spotify.Client
else
    echo "Spotify ya está instalado."
fi


echo
echo "======================================"
echo " Aplicaciones principales instaladas"
echo "======================================"
