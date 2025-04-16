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
    # <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  nix.settings.trusted-users = [ "root" "nixos" ];

  # Añade los paquetes que necesites aquí:
  environment.systemPackages = with pkgs; [
    gcc                          # Compilador de c
    gnumake                      # Install make para compilar
    zsh                          # Base Terminal
    oh-my-zsh                    # Package manager for zsh
    oh-my-posh                   # Style terminal
    git                          # Ejemplo: Instalar Git
    zsh-syntax-highlighting      # Highligh installed packages
    zsh-autosuggestions          # Autosuggestions for terminal
    neovim                       # Best text editor
    zoxide                       # Fast change directory
    stow                         # Link dotfiles
    htop                         # Monitor de sistema
    yazi                         # Filesystem explorer
    vim                          # Old text editor
    wget                         # Descargar archivos
    neofetch                     # OS Info
    lazygit                      # Interactive git ui
    eza                          # Fancy list dirs and files 
    bat                          # Fancy show files
    python3                      # Fancy show files
    uv                           # Packages manage python
    devenv                           # Packages manage python
    mermaid-cli                           # Packages manage python
  ];

  users.users.nixos = {
	shell = pkgs.zsh;
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
