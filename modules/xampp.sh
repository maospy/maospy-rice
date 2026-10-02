#!/usr/bin/env bash

set -e

echo "======================================"
echo "        MAOSPY RICE - XAMPP"
echo "======================================"

XAMPP_VERSION="8.2.12"
XAMPP_BUILD="0"

XAMPP_DIR="/opt/lampp"

CACHE_DIR="$HOME/.cache/maospy-rice"
mkdir -p "$CACHE_DIR"

INSTALLER_NAME="xampp-linux-x64-${XAMPP_VERSION}-${XAMPP_BUILD}-installer.run"
INSTALLER="$CACHE_DIR/$INSTALLER_NAME"

DOWNLOAD_URL="https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/${XAMPP_VERSION}/${INSTALLER_NAME}/download"

EXPECTED_SHA256="df0774e7a6d0d0754a5f0132015411234b5f953df2365b693d3758fc35a30374"


echo
echo "[1/7] Comprobando dependencias..."

PACKAGES=(
    net-tools
    glibc.i686
    libgcc.i686
    libstdc++.i686
    libxcrypt-compat
    libnsl
)

MISSING=()

for package in "${PACKAGES[@]}"; do
    if ! rpm -q "$package" >/dev/null 2>&1; then
        MISSING+=("$package")
    fi
done

if (( ${#MISSING[@]} > 0 )); then
    echo "Instalando dependencias faltantes:"
    printf '  %s\n' "${MISSING[@]}"
    sudo dnf install -y "${MISSING[@]}"
else
    echo "Todas las dependencias ya están instaladas."
fi


echo
echo "[2/7] Comprobando XAMPP..."

if [[ -x "$XAMPP_DIR/lampp" ]]; then
    echo "XAMPP ya está instalado."
    echo "Ruta: $XAMPP_DIR"
else

    echo
    echo "[3/7] Descargando XAMPP ${XAMPP_VERSION}-${XAMPP_BUILD}..."

    curl \
        --fail \
        --location \
        --retry 8 \
        --retry-delay 3 \
        --retry-all-errors \
        --continue-at - \
        --progress-bar \
        "$DOWNLOAD_URL" \
        -o "$INSTALLER"

    if [[ ! -s "$INSTALLER" ]]; then
        echo "ERROR: La descarga está vacía."
        exit 1
    fi

    echo
    echo "Descarga terminada:"
    ls -lh "$INSTALLER"


    echo
    echo "[4/7] Verificando integridad..."

    ACTUAL_SHA256="$(sha256sum "$INSTALLER" | awk '{print $1}')"

    if [[ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]]; then
        echo
        echo "ERROR: SHA-256 incorrecto."
        echo "Esperado: $EXPECTED_SHA256"
        echo "Obtenido: $ACTUAL_SHA256"
        rm -f "$INSTALLER"
        exit 1
    fi

    echo "SHA-256 correcto."

    chmod +x "$INSTALLER"


    echo
    echo "[5/7] Instalando XAMPP..."

    sudo "$INSTALLER" --mode unattended

    echo "Instalación terminada."
fi


if [[ ! -x "$XAMPP_DIR/lampp" ]]; then
    echo
    echo "ERROR: No se encontró:"
    echo "$XAMPP_DIR/lampp"
    exit 1
fi


echo
echo "[6/7] Iniciando XAMPP..."

sudo "$XAMPP_DIR/lampp" start || true


echo
echo "[7/7] Verificando servicios..."

echo
echo "--------------------------------------"
echo "Apache"
echo "--------------------------------------"

if curl -fsS http://localhost >/dev/null 2>&1; then
    echo "[OK] Apache responde en http://localhost"
else
    echo "[ERROR] Apache no responde."
fi


echo
echo "--------------------------------------"
echo "MariaDB / MySQL"
echo "--------------------------------------"

if sudo "$XAMPP_DIR/bin/mysqladmin" -u root ping >/dev/null 2>&1; then
    echo "[OK] MariaDB/MySQL está funcionando."
else
    echo "[ERROR] MariaDB/MySQL no responde."
fi


echo
echo "--------------------------------------"
echo "Puerto 3306"
echo "--------------------------------------"

if sudo ss -ltnp | grep -q ':3306'; then
    echo "[OK] Puerto 3306 activo."
else
    echo "[INFO] Puerto 3306 no detectado."
fi


echo
echo "--------------------------------------"
echo "ProFTPD"
echo "--------------------------------------"

if pgrep -x proftpd >/dev/null 2>&1; then
    echo "[OK] ProFTPD está funcionando."
else
    echo "[INFO] ProFTPD no detectado."
fi


echo
echo "======================================"
echo "          XAMPP CONFIGURADO"
echo "======================================"

echo
echo "Ruta:"
echo "  $XAMPP_DIR"

echo
echo "Servidor:"
echo "  http://localhost"

echo
echo "phpMyAdmin:"
echo "  http://localhost/phpmyadmin"

echo
echo "Comandos útiles:"
echo
echo "  sudo /opt/lampp/lampp start"
echo "  sudo /opt/lampp/lampp stop"
echo "  sudo /opt/lampp/lampp restart"
echo "  sudo /opt/lampp/lampp status"

echo
echo "Nota:"
echo "El comando 'lampp status' puede informar incorrectamente"
echo "que MySQL está detenido en Fedora moderno."
echo "Maospy Rice verifica MariaDB usando mysqladmin y el puerto 3306."

echo
echo "Maospy Rice: módulo XAMPP terminado."
