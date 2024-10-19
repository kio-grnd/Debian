#!/bin/bash

# Verificar si el script se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root o con sudo."
  exit 1
fi

# Actualización del sistema e instalación de herramientas multimedia
echo "Instalando herramientas multimedia..."
apt update && apt install -y \
  ffmpeg \
  libavcodec-extra \
  gstreamer1.0-libav \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-pulseaudio \
  vorbis-tools \
  flac \
  vlc \
  audacity

# Confirmación final
echo "Instalación de herramientas multimedia completada."
