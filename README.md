# nixosconfig
## My personal nixos config

pegar el archivo nixconf/configuration.nix en:

/etc/nixos/configuration.nix

y ejecutar

sudo nixos-rebuild switch

### Instalar NixOs-Wsl
https://github.com/nix-community/NixOS-WSL

bajar nixos.wsl de los releases del repo y hacer doble click en el archivo descargado

ejecutar en powershell
wsl -d NixOS

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

### Ejemplos comunes de instalacion
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

