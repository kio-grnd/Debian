#!/bin/bash

# Verificar si el script se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root o con sudo."
  exit 1
fi

# Instalación de paquetes esenciales
echo "Instalando paquetes esenciales..."
apt update && apt install -y \
  sudo \
  xorg \
  x11-xserver-utils \
  xinit \
  gcc \
  make \
  linux-headers-$(uname -r) \
  build-essential \
  ntfs-3g \
  alsa-utils \
  pkg-config \
  git \
  fontconfig \
  libx11-dev \
  libfreetype6-dev \
  libxft-dev \
  libharfbuzz-dev \
  libfribidi-dev \
  libgd-dev \
  curl \
  unzip \
  gzip \
  wget \
  nano \
  libxinerama1 \
  libncursesw5-dev \
  vim \
  htop \
  dbus-x11 \
  numlockx  # Paquete para activar NumLock

# Instalación de Zsh y sus plugins
echo "Instalando Zsh y plugins..."
apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions

# Configuración de sudo para el usuario "debian"
echo "Configurando permisos de sudo para el usuario 'debian'..."
echo "debian    ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo

# Autoremove de AppArmor (si es necesario)
echo "Eliminando AppArmor si está instalado..."
apt autoremove -y apparmor

# Configuración de OS Prober en GRUB
echo "Habilitando OS Prober en GRUB..."
sed -i '/GRUB_DISABLE_OS_PROBER=/d' /etc/default/grub
echo 'GRUB_DISABLE_OS_PROBER="false"' >> /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Activar NumLock al iniciar sesión
echo "Activando NumLock al inicio..."
echo "numlockx on" >> ~/.xinitrc

# Configuración personalizada del teclado con setxkbmap para teclado español
echo "Configurando el teclado con setxkbmap (teclado español)..."
# Configuración del teclado español
echo "setxkbmap -layout es" >> ~/.xinitrc

# Si deseas cambiar alguna tecla, puedes agregar más opciones. Ejemplo:
# echo "setxkbmap -layout es -option caps:swapescape" >> ~/.xinitrc  # Ejemplo: cambiar Caps Lock por Escape

# Eliminar el controlador nouveau
echo "Eliminando el controlador nouveau..."
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist.conf
update-initramfs -u

# Eliminar Plymouth si está instalado
if dpkg -l | grep -q plymouth; then
    echo "Eliminando Plymouth..."
    apt remove --purge -y plymouth
    update-initramfs -u
else
    echo "Plymouth no está instalado, no es necesario eliminarlo."
fi

# Reiniciar el sistema para aplicar los cambios
echo "El sistema necesita reiniciarse para aplicar los cambios en el controlador nouveau."
read -p "¿Quieres reiniciar ahora? (s/n): " -n 1 -r
echo    # Nueva línea
if [[ $REPLY =~ ^[Ss]$ ]]; then
    reboot
fi

# Instalar el controlador de NVIDIA
echo "Instalando el controlador NVIDIA..."
apt update
apt install -y nvidia-driver

# Reiniciar para aplicar los cambios
echo "La instalación se ha completado. Por favor, reinicia el sistema."
