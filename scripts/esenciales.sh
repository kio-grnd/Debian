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

# Configuración de sudo para el usuario actual
USER=$(logname)  # Obtener el nombre del usuario que ejecuta el script
echo "Configurando permisos de sudo para el usuario '$USER'..."
echo "$USER    ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo

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
echo "numlockx on" >> /home/$USER/.xinitrc

# Configuración personalizada del teclado con setxkbmap para teclado español
echo "Configurando el teclado con setxkbmap (teclado español)..."
echo "setxkbmap -layout es" >> /home/$USER/.xinitrc

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

# Reemplazar la configuración de /etc/bash.bashrc
echo "Configurando /etc/bash.bashrc..."
cat << 'EOF' > /etc/bash.bashrc
# /etc/bash.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Disable completion when the input buffer is empty.  i.e. Hitting tab
# and waiting a long time for bash to expand all of $PATH.
shopt -s no_empty_cmd_completion

# Enable history appending instead of overwriting when exiting.  #139609
shopt -s histappend

# Save each command to the history file as it's executed.  #517342
# This does mean sessions get interleaved when reading later on, but this
# way the history is always up to date.  History is not synced across live
# sessions though; that is what `history -n` does.
# Disabled by default due to concerns related to system recovery when $HOME
# is under duress, or lives somewhere flaky (like NFS).  Constantly syncing
# the history will halt the shell prompt until it's finished.
#PROMPT_COMMAND='history -a'

# Change the window title of X terminals 
case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|interix)
		PS1='\[\033]0;\u@\h:\w\007\]'
		;;
	screen*)
		PS1='\[\033k\u@\h:\w\033\\\]'
		;;
	*)
		unset PS1
		;;
esac

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.
# We run dircolors directly due to its changes in file syntax and
# terminal name patching.
use_color=false
if type -P dircolors >/dev/null ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	LS_COLORS=
	if [[ -f ~/.dir_colors ]] ; then
		eval "$(dircolors -b ~/.dir_colors)"
	elif [[ -f /etc/DIR_COLORS ]] ; then
		eval "$(dircolors -b /etc/DIR_COLORS)"
	else
		eval "$(dircolors -b)"
	fi
	if [[ -n ${LS_COLORS:+set} ]] ; then
		use_color=true
	else
		unset LS_COLORS
	fi
else
	case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|screen|cons25|*color) use_color=true;;
	esac
fi

if ${use_color} ; then
	if [[ ${EUID} == 0 ]] ; then
		PS1+='\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '
	else
		PS1+='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	PS1+='\u@\h \w \$ '
fi
EOF

# Reiniciar el servicio console-setup
echo "Reiniciando el servicio console-setup..."
sudo service console-setup restart

# Configuración de console-setup
echo "Configurando console-setup..."
cat <<EOF > /etc/default/console-setup
# CONFIGURATION FILE FOR SETUPCON

ACTIVE_CONSOLES="/dev/tty[1-6]"

CHARMAP="UTF-8"

CODESET="Lat15"
FONTFACE="VGA"
FONTSIZE="8x16"

VIDEOMODE=

# Terminal colors
USECOLOR="yes"
EOF

# Reiniciar el servicio console-setup
echo "Reiniciando el servicio console-setup..."
sudo service console-setup restart

# Reiniciar el sistema para aplicar los cambios en el controlador nouveau
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
