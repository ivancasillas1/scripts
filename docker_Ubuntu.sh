#!/bin/bash

# Asegurar que el script se ejecuta con permisos de superusuario
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ejecutarse con permisos de superusuario (root o sudo)." 
    exit 1
fi

echo "🚀 Actualizando paquetes..."
apt update -y && apt upgrade -y

echo "🔧 Instalando paquetes necesarios..."
apt install -y ca-certificates curl gnupg lsb-release

echo "🔑 Agregando la clave GPG oficial de Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/keyrings/docker.gpg > /dev/null
chmod a+r /etc/apt/keyrings/docker.gpg

echo "📦 Agregando el repositorio de Docker..."
echo "deb [signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔄 Actualizando lista de paquetes..."
apt update -y

echo "🐳 Instalando Docker y Docker Compose..."
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "✅ Habilitando y verificando el servicio de Docker..."
systemctl enable docker
systemctl start docker
systemctl status docker --no-pager

echo "🛠️ Agregando el usuario actual al grupo Docker..."
if [ -n "$SUDO_USER" ]; then
    usermod -aG docker $SUDO_USER
    echo "⚠️ Para aplicar los cambios de grupo, cierra sesión y vuelve a iniciar sesión."
else
    echo "⚠️ No se pudo determinar el usuario que ejecutó sudo. Agrega manualmente tu usuario al grupo Docker con: sudo usermod -aG docker <tu_usuario>"
fi

echo "🔍 Verificando instalación de Docker..."
docker --version
docker compose version

echo "✅ Instalación completada. ¡Docker está listo para usarse!"
