
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

ejecutar en powershell (opcional, se carga nixos automatic en windows terminal)
wsl -d NixOS

## Please run `sudo nix-channel --update` and `sudo nixos-rebuild switch` now, to ensure you're running the latest NixOS and NixOS-WSL versions.
sudo nix-channel --update
sudo nixos-rebuild switch
nix-shell -p git --run 'git clone https://github.com/OmarHdz/nixosconfig.git'

## Linkear de mi configuracion
sudo mv /etc/nixos/configuration.nix /etc/nixos/bak.configuration.nix
sudo ln -s ~/nixosconfig/dotfiles/nixos/configuration.nix /etc/nixos/configuration.nix

### Probar un paquete sin instalarlo permanentesmente 
nix-shell -p nombreDelPaquete 
#Ejemplo nix-shell -p neofetch

### Instalacion permanente a nivel usuario
nix-env -iA nixpkgs.nombreDelPaquete
#Ejemplo nix-env -iA nixpkgs.neofetch

### Instalacion permanente a nivel sistema (NixOS)
En el archivo /etc/nixos/configuration.nix, agregar:
environment.systemPackages = with pkgs; [
  neofetch
];

### Buscar paquetes disponibles
nix-env -qaP | grep "nombreDelPaquete"
#Ejemplo nix-env -qaP | grep "python"

### Usar canales actualizados
nix-channel --update

### Ejemplos comunes de instalacion a nivel usuario
nix-env -iA nixpkgs.git
nix-env -iA nixpkgs.nodejs
nix-env -iA nixpkgs.python3

### Notas clave
Nix vs NixOS:
En NixOS, modifica configuration.nix para paquetes del sistema.
En Nix (sin NixOS), usa nix-env para instalaciones de usuario.

Garbage Collection: Para limpiar paquetes no usados:
nix-collect-garbage -d

#### Resumen
Para probar algo rápido: nix-shell -p.
Para instalar como usuario: nix-env -iA.
Para instalar en todo el sistema (NixOS): Editar configuration.nix

#### Notas importantes
Los paquetes en environment.systemPackages están disponibles para todos los usuarios del sistema.

Para buscar paquetes, usa:
nix search nixpkgs nombrePaquete
o visita: https://search.nixos.org/packages
=======
cd .dotfiles
sudo nixos-rebuild switch --flake .
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

#### install home-manager
nix-shell '<home-manager>' -A install

#### run home-manager
#### tiene que estar el archivo flake.nix en este path
home-manager switch --flake .
