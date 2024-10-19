#!/bin/bash

# Comprobamos si el script se está ejecutando como root o con sudo
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root o usando sudo."
  exit 1
fi

# Instalación de paquetes mediante APT
echo "Instalando paquetes necesarios desde APT..."
apt update && apt install -y \
  bspwm \
  sxhkd \
  rofi \
  polybar \
  ranger \
  rxvt-unicode \
  feh \
  picom \
  ueberzug \
  viewnior \
  bash-completion \
  zathura \
  zathura-pdf-poppler \
  lxappearance \
  chromium \
  flatpak \
  wmctrl \

# Instalación de Google Chrome
echo "Instalando Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
apt install -y /tmp/google-chrome.deb
rm /tmp/google-chrome.deb  # Limpiar el archivo .deb descargado

echo "Script completado. ¡Disfruta tu entorno de bspwm!"
