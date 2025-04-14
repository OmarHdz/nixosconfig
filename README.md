
# Rebuild the system
sudo nixos-rebuild switch --flake .

sudo nixos-rebuild switch --flake .#nombredel host

# Actualiza los paquetes en el lock, solo cambia el archivo lock
nix flake update

# Para actualizar los paquetes se usa
sudo nixos-rebuild switch --flake .

# Homemanager switch
home-manager switch --flake .

# Exportar a otro sistema

cd .dotfiles
sudo nixos-rebuild switch --flake .
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

#### install home-manager
nix-shell '<home-manager>' -A install

#### run home-manager
#### tiene que estar el archivo flake.nix en este path
home-manager switch --flake .
