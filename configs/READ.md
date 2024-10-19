# `bash.bashrc` - Configuración global de Bash

Este archivo `bash.bashrc` contiene la configuración global utilizada por Bash para todas las sesiones interactivas del shell en un sistema Linux. Específicamente, se encarga de definir el entorno de terminal para todos los usuarios que inicien sesión en el sistema, personalizando el prompt, configurando alias, y aplicando varias opciones útiles para la línea de comandos.

## Descripción general

Este archivo establece las siguientes características importantes:

1. **Gestión de sesiones interactivas**: 
   - Detecta si la sesión es interactiva (esto evita ejecutar comandos innecesarios para procesos como `scp` o `rcp`).
   - Activa el ajuste automático del tamaño de la terminal con `shopt -s checkwinsize`.

2. **Historial mejorado**:
   - Habilita la opción `histappend` para que el historial de comandos se agregue en lugar de sobrescribirse cuando se cierra una sesión.

3. **Prompt colorido**:
   - Cambia el color del prompt según el usuario: rojo para `root` y verde para usuarios normales.
   - El prompt muestra el nombre del host y el directorio actual.

4. **Alias útiles**:
   - Alias predeterminados para comandos como `ls`, `grep`, `egrep` y `fgrep` con opciones de color para una mejor legibilidad.
     - `alias ls='ls --color=auto'`
     - `alias grep='grep --colour=auto'`
   
5. **Soporte para configuraciones de terminal**:
   - Detecta si se está usando una terminal compatible con colores y ajusta la configuración del prompt y alias en consecuencia.

6. **Compatibilidad con archivos de configuración locales**:
   - Fuente adicional de configuraciones personalizadas en `/home/sid/.bashrc` si existe y es legible.

## Instalación

### Reemplazo de la configuración global de `bash.bashrc`

1. **Copia de seguridad del archivo existente**:
   ```bash
   sudo cp /etc/bash.bashrc /etc/bash.bashrc.bak

   
