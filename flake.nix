{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # <--- ¡CAMBIA ESTO!
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager"; # Usar rama principal o una release como 24.05
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # Define pkgs una vez para usarlo en ambos
      # pkgs = nixpkgs.legacyPackages.${system};
    in {
     # Configuración del Sistema NixOS
     nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = { 
          # inherit pkgs; 
          inherit inputs; 
          }; # Puedes pasar pkgs explícitamente si quieres
        modules = [
          # El módulo WSL pertenece AQUÍ
          nixos-wsl.nixosModules.wsl
          ./hosts/baseHost/configuration.nix
          # Opcional: Podrías querer importar el módulo de home-manager para NixOS aquí
          # home-manager.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.nixos = import ./home.nix; # Importar config HM directamente
          #   # Asegúrate que 'nixos' es tu nombre de usuario real
          # }
        ];
       };
     };

     # Configuración de Home Manager (Standalone)
     homeConfigurations = {
       # Asegúrate que 'nixos' aquí es tu nombre de usuario real
       # Puedes nombrarlo como quieras, pero suele coincidir con el usuario
       "myuser" = home-manager.lib.homeManagerConfiguration {
         inherit pkgs;
         # Pasa argumentos extras si home.nix los necesita (como 'system')
         extraSpecialArgs = { inherit system; };
         modules = [
           # NO incluyas nixos-wsl.nixosModules.wsl aquí
           ./hosts/baseHost/home.nix
         ];
       };
     };
  };
}
