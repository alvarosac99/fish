# Fish Shell Config

Configuración personal de Fish shell con prompt Starship, herramientas modernas de terminal y plugins de productividad.

## Vista previa

Al abrir el terminal verás fastfetch con el logo de Arch, el prompt de Starship con el preset `bracketed-segments` y las siguientes mejoras activas:

- `ls` / `ll` con iconos y directorios primero (eza)
- `cat` con resaltado de sintaxis (bat)
- `df` con vista amigable (duf)
- Cierre automático de paréntesis y comillas (autopair)
- Notificación al terminar comandos largos (done)
- Búsqueda difusa de historial, ficheros y variables con fzf

---

## Requisitos previos

Arch Linux o Ubuntu (22.04+). Elige los comandos de tu distro en cada paso.

---

## 1. Instalar dependencias

**Arch Linux:**

```bash
sudo pacman -S fish fzf eza bat duf fastfetch
```

> `eza`, `bat`, `duf` y `fastfetch` están en los repositorios oficiales. Si alguno no aparece, están igualmente en el AUR.

**Ubuntu:**

```bash
sudo apt update && sudo apt install fish fzf bat duf
```

```bash
# fastfetch no está en apt; instala via PPA:
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt update && sudo apt install fastfetch
```

```bash
# eza requiere Ubuntu 23.10+ o añadir el repo oficial:
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt update && sudo apt install eza
```

> En Ubuntu, `bat` se instala como `batcat`. Crea un enlace para que el alias funcione:
> ```bash
> mkdir -p ~/.local/bin && ln -s /usr/bin/batcat ~/.local/bin/bat
> ```

---

## 2. Instalar la fuente JetBrainsMono Nerd Font

Necesaria para los iconos de `eza` y los glifos del prompt Starship.

**Arch Linux:**

```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

**Ubuntu:**

```bash
# Descarga e instala la Nerd Font manualmente:
mkdir -p ~/.local/share/fonts
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -O /tmp/JetBrainsMono.zip
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
fc-cache -fv
```

Después de instalarla, **configura tu emulador de terminal** para que use `JetBrainsMono Nerd Font` (o `JetBrainsMono NF`). Sin este paso los iconos aparecerán como cuadrados o interrogaciones.

---

## 3. Instalar Starship

**Cualquier distro** (método recomendado):

```bash
curl -sS https://starship.rs/install.sh | sh
```

O bien desde el gestor de paquetes:

**Arch Linux:**
```bash
sudo pacman -S starship
```

**Ubuntu:**
```bash
# No está en apt; usa el script de arriba o Homebrew/cargo.
```

### Aplicar el preset `bracketed-segments`

```fish
starship preset bracketed-segments -o ~/.config/starship.toml
```

> Si ya tienes el `starship.toml` de este repositorio en su sitio, omite este paso: el fichero ya está configurado con ese preset.

---

## 4. Establecer Fish como shell por defecto

```bash
# Añadir fish a la lista de shells válidos si no está ya
grep -q /usr/bin/fish /etc/shells || echo /usr/bin/fish | sudo tee -a /etc/shells

# Cambiar la shell por defecto
chsh -s /usr/bin/fish
```

Cierra sesión y vuelve a entrar para que el cambio surta efecto.

---

## 5. Clonar y aplicar la configuración

```fish
# Hacer backup de tu config actual si la tienes
mv ~/.config/fish ~/.config/fish.bak

# Clonar el repositorio en su lugar
git clone https://github.com/alvarosac99/fish.git ~/.config/fish
```

---

## 6. Instalar Fisher y los plugins

Abre Fish y ejecuta:

```fish
# Instalar Fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# Instalar los plugins listados en fish_plugins
fisher update
```

`fisher update` lee `fish_plugins` e instala automáticamente todos los plugins declarados:

| Plugin | Función |
|--------|---------|
| `jorgebucaran/autopair.fish` | Cierra automáticamente `(`, `[`, `{`, `"`, `'` |
| `franciscolourenco/done` | Notificación de escritorio cuando un comando tarda más de unos segundos |
| `patrickf1/fzf.fish` | Integración de fzf: `Ctrl+R` historial, `Ctrl+F` ficheros, `Ctrl+V` variables |

---

## 7. Verificar la instalación

Abre una nueva sesión de Fish. Deberías ver:

1. **fastfetch** con el logo de tu distro al abrir el terminal
2. **Prompt de Starship** con el formato `[usuario@host] [directorio] [git]`
3. `ls` mostrando iconos sin errores

```fish
# Comprobaciones rápidas
eza --version
bat --version
duf --version
fzf --version
fastfetch --version
starship --version
```

---

## Atajos de teclado activos (fzf.fish)

| Atajo | Acción |
|-------|--------|
| `Ctrl+R` | Buscar en el historial de comandos |
| `Ctrl+F` | Buscar ficheros en el directorio actual |
| `Ctrl+V` | Buscar variables de entorno |
| `Ctrl+Alt+L` | Buscar en `git log` (dentro de un repo) |
| `Ctrl+Alt+S` | Buscar en `git status` |

---

## Función `modo_servidor`

Disponible en cualquier sesión de Fish. Prepara el portátil para dejarlo encendido sin atención (compartir internet, descargas largas, etc.):

```fish
modo_servidor
```

Hace tres cosas:
1. Desactiva el ahorro de energía del Wi-Fi en `wlan0`
2. Bloquea la sesión con `loginctl lock-session`
3. Inhibe la suspensión indefinidamente — pulsa `Ctrl+C` para volver al modo normal

> Si tu interfaz Wi-Fi no se llama `wlan0`, edita la función en `config.fish` y cambia `wlan0` por el nombre correcto (`ip a` para consultarlo).
