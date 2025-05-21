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
  wsl.defaultUser = "myuser";

  nix.settings.trusted-users = [ "root" "myuser" ];

  # Añade los paquetes que necesites aquí:
  environment.systemPackages = with pkgs; [
   # zsh
  ];

  users.users.nixos = {
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
  };
  
  # programs.zsh = {
  #   enable = true;
  #   ohMyZsh = {
  #     enable = true;
  #     plugins = [ "git" ]; # "sudo" "docker" ];  # Plugins que desees
  #     theme = "agnoster";                   # Tema (ej: "robbyrussell", "agnoster")
  #   };
  #   interactiveShellInit = ''
  #     source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  #     # Si también quieres autosuggestions:
  #     source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  #   '';
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "America/Mexico_City";

}
