#!/bin/bash

# Asegurar que el script se ejecuta con permisos de superusuario
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ejecutarse con permisos de superusuario (root o sudo)."
    exit 1
fi

echo "🚀 Actualizando lista de paquetes..."
apt update -y && apt upgrade -y

echo "🔧 Instalando Docker desde los repositorios oficiales de Ubuntu..."
apt install -y docker.io

echo "✅ Habilitando y verificando el servicio de Docker..."
systemctl enable docker
systemctl start docker
systemctl status docker --no-pager

echo "🛠️ Agregando el usuario actual al grupo Docker..."
if [ -n "$SUDO_USER" ]; then
    usermod -aG docker $SUDO_USER
    echo "⚠️ Para aplicar los cambios de grupo, cierra sesión y vuelve a iniciar sesión."
else
    echo "⚠️ No se pudo determinar el usuario que ejecutó sudo. Agrega manualmente tu usuario al grupofi

echo "🐳 Verificando instalación de Docker..."
docker --version

echo "📦 Instalando Docker Compose desde los repositorios oficiales..."
apt install -y docker-compose

echo "🔍 Verificando instalación de Docker Compose..."
docker-compose --version

echo "✅ Instalación completada. ¡Docker y Docker Compose están listos para usarse!"
