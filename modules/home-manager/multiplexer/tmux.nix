{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    # clock24 = true; # Ejemplo de opción simple de tmux
    escapeTime = 0;  # Reduce el delay al presionar Esc (útil en Vim/Neovim)
    baseIndex = 1;   # Empezar a numerar ventanas desde 1
    historyLimit = 10000; # Aumentar el historial de scrollback
    mouse = true;    # Habilitar soporte para ratón (scroll, seleccionar ventana/panel)
    sensibleOnTop = true; # Asegura que las opciones de tmux-sensible no se sobreescriban

    # --- Integración con TPM y Plugins ---
    plugins = with pkgs; [
      # ¡¡Importante!! Incluir TPM como el primer plugin
      # tmuxPlugins.tpm

      # --- Añade aquí los plugins que quieras gestionar con TPM ---
      # Plugins comunes (descomenta los que quieras):
      tmuxPlugins.sensible    # Configuraciones base sensibles
      tmuxPlugins.resurrect   # Guarda y restaura sesiones de tmux
      tmuxPlugins.continuum   # Autoguardado y autorestore (requiere resurrect)
      tmuxPlugins.vim-tmux-navigator # Navegación transparente entre paneles de tmux y splits de Vim/Neovim
      tmuxPlugins.catppuccin # Navegación transparente entre paneles de tmux y splits de Vim/Neovim
      tmuxPlugins.tmux-floax # Navegación transparente entre paneles de tmux y splits de Vim/Neovim
      # tmuxPlugins.yank        # Copiar al portapapeles del sistema
      # tmuxPlugins.open      # Abrir archivos/URLs resaltados
      # tmuxPlugins.copycat   # Búsqueda rápida en el scrollback
      # tmuxPlugins.sidebar   # Un árbol de directorios en un panel lateral
      # ... busca más en pkgs.tmuxPlugins ...
    ];

    # --- Configuraciones Adicionales de Tmux ---
    # Aquí puedes añadir cualquier configuración personalizada de .tmux.conf
    # Usa sintaxis de string de Nix (comillas dobles o '' para multilínea)
    extraConfig = ''
      # Ejemplo: Cambiar el prefijo a Ctrl+a
      set-option -g status-position top
      unbind C-a
      set -g prefix C-Space
      bind C-Space send-prefix

      # Ejemplo: Recargar config con Prefix + r
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # Ejemplo: Dividir paneles con | y -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Ejemplo: Navegación entre paneles estilo Vim (si no usas vim-tmux-navigator)
      # bind h select-pane -L
      # bind j select-pane -D
      # bind k select-pane -U
      # bind l select-pane -R

      # Ejemplo: Configuraciones para tmux-resurrect (si lo usas)
      # set -g @resurrect-capture-pane-contents 'on'
      # set -g @continuum-restore 'on' # Para que continuum restaure al iniciar tmux

      # --- IMPORTANTE para TPM ---
      # ¡No necesitas añadir 'run ~/.tmux/plugins/tpm/tpm' aquí!
      # El módulo de Home Manager se encarga de eso automáticamente
      # cuando defines la sección `plugins` de arriba.

      # Añade el resto de tus configuraciones personales aquí...
      # set -g status-style 'bg=black,fg=white'
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      #set-option -sa terminal-overrides ",xterm*:Tc"
      set -g allow-passthrough on
      # set -g @plugin 'catppuccin/tmux'
      set -g @catppuccin_flavor 'mocha'
      set -g @catppuccin_window_default_text " #W"
      set -g @catppuccin_window_text " #W"
      set -g @catppuccin_window_current_text " #W"

      #set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      #set -agF status-right "#{E:@catppuccin_status_cpu}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"

      set -g @floax-border-color 'cyan'
      set -g @floax-bind 'C-f'

      set -g @catppuccin_window_status_style "rounded"
    '';

  };

}
