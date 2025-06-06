#!/bin/bash

echo "Instalando nix multiuser --daemon para wsl"
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
echo "Hay que abrir otra terminal para que cargue nix"
exec bash

echo "Agregando opciones expermientales"
mkdir -p ~/.config/nix
touch ~/.config/nix/nix.conf
echo "experimental-features = nix-command flakes" >>~/.config/nix/nix.conf
echo "accept-flake-config = true" >>~/.config/nix/nix.conf

echo "Descargando configuracion de home-manager y flake"
nix shell nixpkgs#home-manager nixpkgs#gh --command sh -c "gh auth login && gh repo clone OmarHdz/nixosconfig -- --depth=1 "

echo "Agregando opciones expermientales"
cd nixosconfig
nix shell nixpkgs#home-manager --command sh -c "home-manager switch -b bkup --flake ."

echo "Configuracion de python para que no interfiera con nix"
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt install python3.12 python3.12-venv python3.12-dev -y

sudo curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.zshrc
nvm install --lts
# sudo apt install build-essential -y

# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
./createuvenv.sh create

# Opcional instalar home-manager
# nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --update
# nix-shell '<home-manager>' -A install
