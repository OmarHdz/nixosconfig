{ config, pkgs, lib, ... }:

{

  imports = [
    ./modules/home-manager/shells/sh.nix
    ./modules/home-manager/shells/zoxide.nix
    ./modules/home-manager/multiplexer/tmux.nix
  ];
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
