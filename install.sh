#!/bin/bash

echo "Instalando nix multiuser --daemon para wsl"
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

echo "Agregando opciones expermientales"
mkdir -p ~/.config/nix
touch ~/.config/nix/nix.conf
echo "experimental-features = nix-command flakes" >>~/.config/nix/nix.conf
echo "accept-flake-config = true" >>~/.config/nix/nix.conf

echo "Descargando configuracion de home-manager y flake"
nix shell nixpkgs#home-manager nixpkgs#gh --command sh -c "gh auth login && gh repo clone OmarHdz/nixosconfig -- --depth=1 "

echo "Agregando opciones expermientales"
nix shell nixpkgs#home-manager --command sh -c "home-manager switch -b bkup --flake ."

# Opcional instalar home-manager
# nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --update
# nix-shell '<home-manager>' -A install
