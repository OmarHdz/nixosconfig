{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
     pkgs.hello

     pkgs.oh-my-posh

     pkgs.tmux
     # pkgs.tmux-plugin-manager
     # pkgs.zoxide

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nixos/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.zoxide = {
      enable = true;
    };

 programs.git = {
    enable = true; # Asegúrate de que Git esté habilitado

    # --- Configuraciones básicas ---
    userName = "OmarHdz";
    userEmail = "omarhg_@hotmail.com";

    # --- Configuraciones adicionales (equivalente a git config --global key value) ---
    # Usa 'extraConfig' para la mayoría de las opciones
    extraConfig = {
      # init.defaultBranch = "main"; # Cambia la rama por defecto a 'main'
      # pull.rebase = true;          # Prefiere rebase en lugar de merge al hacer pull
      # github.user = "tu_usuario_github"; # Útil para herramientas como 'hub' o 'gh'
      # # ... otras opciones ...
      #
      # # Ejemplo de alias
      # alias = {
      #   st = "status -sb";
      #   co = "checkout";
      #   br = "branch";
      #   ci = "commit";
      #   ll = "log --pretty=format:'%C(yellow)%h %C(cyan)%>(12)%ar %C(magenta)%<(10)%aN %C(auto)%d %Creset%s'";
       };
      };

  # programs.bash.enable = true;
  programs.bash = {
    enable = true;
    shellAliases = {
        ll = "ls -l";
        cd = "cd ..";
     };
     initExtra = ''
        eval "$(oh-my-posh init bash --config '${config.xdg.configHome}/ohmyposh/mytheme.json')"
     '';
  };

  # programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    shellAliases = {
        ll = "ls -l";
        v = "nvim";
        lg = "lazygit";
        cd = "z";
     };
     initExtra = ''
        eval "$(oh-my-posh init zsh --config '${config.xdg.configHome}/ohmyposh/mytheme.json')"
        test -z "$TMUX" && tmux
     '';
  };

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

# Activation script to clone tpm if it doesn't exist
home.activation.cloneTpm = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.tmux/plugins"
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
      ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
  '';

  home.file.".vimrc".source = ./vimrc;
  home.file.".config/nvim".source = ./nvim;
  home.file.".config/ohmyposh/mytheme.json".source = ./mytheme.json;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
