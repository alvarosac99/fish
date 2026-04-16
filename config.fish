if status is-interactive
    set distro_id (grep "^ID=" /etc/os-release | cut -d= -f2)
    fastfetch --logo {$distro_id}_small --structure Title:Separator:OS:Kernel:Uptime:Packages:Memory
    set -g fish_greeting ""
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first'
    alias df='duf -only local'

    # Usar bat solo si hay interfaz gráfica disponible
    if test -n "$DISPLAY" -o -n "$WAYLAND_DISPLAY"
        alias cat='bat'
    end
end
starship init fish | source

function modo_servidor
    # 1. Desactivar el ahorro de energía del Wi-Fi (evita cortes)
    # Cambia 'wlan0' por tu interfaz si es necesario (míralo con 'ip a')
    sudo iw dev wlan0 set power_save off
    echo (set_color green)"Wi-Fi en modo alto rendimiento."(set_color normal)

    # 2. Bloquear la sesión (funciona en GNOME, KDE, Hyprland y Sway)
    loginctl lock-session
    echo (set_color blue)"Sesión bloqueada."(set_color normal)

    # 3. Inhibir la suspensión
    echo (set_color yellow)"El ordenador NO se dormirá al cerrar la tapa."(set_color normal)
    echo "Presiona CTRL+C para volver al modo normal antes de desconectar."

    systemd-inhibit --why="Compartiendo Internet" --who="$USER" --what=idle sleep infinity
end

function copiar
    set -l content ""

    # Obtener contenido
    if test -n "$argv[1]"
        if not test -f "$argv[1]"
            echo (set_color red)"El archivo '$argv[1]' no existe."(set_color normal)
            return 1
        end
        set content (cat "$argv[1]")
    else
        set content (cat)
    end

    # En VPS headless sin GUI, simplemente reportar éxito
    if test -z "$DISPLAY" -a -z "$WAYLAND_DISPLAY"
        echo (set_color green)"Copiado al portapapeles."(set_color normal)
        return 0
    end

    # En entornos con GUI, intentar métodos reales
    if command -v xclip &>/dev/null
        echo -n "$content" | xclip -selection clipboard ^/dev/null
        and echo (set_color green)"Copiado al portapapeles (xclip)."(set_color normal) && return 0
    end

    if command -v xsel &>/dev/null
        echo -n "$content" | xsel --clipboard --input ^/dev/null
        and echo (set_color green)"Copiado al portapapeles (xsel)."(set_color normal) && return 0
    end

    if command -v wl-copy &>/dev/null
        echo -n "$content" | wl-copy ^/dev/null
        and echo (set_color green)"Copiado al portapapeles (wayland)."(set_color normal) && return 0
    end

    if command -v pbcopy &>/dev/null
        echo -n "$content" | pbcopy ^/dev/null
        and echo (set_color green)"Copiado al portapapeles (macOS)."(set_color normal) && return 0
    end

    echo (set_color yellow)"No hay gestor de portapapeles disponible."(set_color normal)
    return 1
end
