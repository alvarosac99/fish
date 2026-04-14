if status is-interactive
    set distro_id (grep "^ID=" /etc/os-release | cut -d= -f2)
    fastfetch --logo {$distro_id}_small --structure Title:Separator:OS:Kernel:Uptime:Packages:Memory
    set -g fish_greeting ""
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first'
    alias df='duf -only local'
    alias cat='bat'
end
starship init fish | source

function modo_servidor
    # 1. Desactivar el ahorro de energía del Wi-Fi (evita cortes)
    # Cambia 'wlan0' por tu interfaz si es necesario (míralo con 'ip a')
    sudo iw dev wlan0 set power_save off
    echo (set_color green)"✔ Wi-Fi en modo alto rendimiento."(set_color normal)

    # 2. Bloquear la sesión (funciona en GNOME, KDE, Hyprland y Sway)
    loginctl lock-session
    echo (set_color blue)"✔ Sesión bloqueada."(set_color normal)

    # 3. Inhibir la suspensión
    echo (set_color yellow)"El ordenador NO se dormirá al cerrar la tapa."(set_color normal)
    echo "Presiona CTRL+C para volver al modo normal antes de desconectar."
    
    systemd-inhibit --why="Compartiendo Internet" --who="$USER" --what=idle sleep infinity
end
