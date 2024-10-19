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
  snapd

# Instalación de neovim mediante snap
echo "Instalando neovim desde Snap..."
sudo snap install nvim --classic

# Configuración de flathub y instalación de Flatpaks
echo "Añadiendo Flathub y instalando aplicaciones Flatpak..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install -y com.google.Chrome
# Si prefieres Brave o Firefox, descomenta las siguientes líneas:
# sudo flatpak install -y com.brave.Browser
# sudo flatpak install -y org.mozilla.firefox

# Copiar ufetch a /usr/bin y hacer que sea ejecutable
# echo "Copiando ufetch a /usr/bin y dando permisos de ejecución..."
# sudo cp /mnt/Linux/fetch/ufetch/ufetch-main/ufetch-debian /usr/bin/debfetch
# sudo chmod +x /usr/bin/debfetch

echo "Script completado. ¡Disfruta tu entorno de bspwm!"
