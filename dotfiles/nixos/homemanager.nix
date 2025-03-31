# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
# Usar sudo nixos-rebuild switch para construir
# y exec zsh si no se recarga la terminal

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";


  # Añade los paquetes que necesites aquí:
  environment.systemPackages = with pkgs; [
    zsh                          # Base Terminal
    oh-my-zsh                    # Package manager for zsh
    oh-my-posh                   # Style terminal
    git                          # Ejemplo: Instalar Git
    zsh-syntax-highlighting      # Highligh installed packages
    zsh-autosuggestions          # Autosuggestions for terminal
    neovim                       # Best text editor
    stow                         # Link dotfiles
    htop                         # Monitor de sistema
    yazi                         # Filesystem explorer
    vim                          # Old text editor
    wget                         # Descargar archivos
    neofetch                     # OS Info
    lazygit                      # Interactive git ui
  ];

  users.users.nixos = {
	shell = pkgs.zsh;
  };

home-manager.users.nixos = {
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ]; # "sudo" "docker" ];  # Plugins que desees
      theme = "agnoster";                   # Tema (ej: "robbyrussell", "agnoster")
    };
    interactiveShellInit = ''
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      # Si también quieres autosuggestions:
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    '';
  };
  # programs.zsh = {
  #   enable = true;
  #   initExtra = ''  # Reemplaza tu .zshrc
  #     export PATH="$PATH:$HOME/.local/bin"
  #     eval "$(oh-my-posh init zsh --config ~/.poshthemes/tokyo.omp.json)"
  #   '';
  # };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''  # Reemplaza tu .vimrc/init.lua
      set number
      colorscheme tokyonight
    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''  # Reemplaza tu .tmux.conf
      set -g mouse on
      bind-key -n C-S-Left swap-window -t -1
    '';
  };
};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
