{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    pythonVersion = pkgs.python312;
    pypk = pythonVersion.pkgs;
  in
  {
    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
    # devShells."x86_64-linux".default = import ./shell.nix { inherit pkgs; };

      devShells."x86_64-linux".default = pkgs.mkShell {
        packages = [ 
          pythonVersion
          # pypk.pandas
          pypk.debugpy # libreria para debugear
          pypk.pytest # libreria para testear
          pypk.ipython # python interactivo
          pkgs.ruff
          pkgs.ruff-lsp
          pkgs.mypy
          pkgs.pyright
          # --- Node.js y Prettier ---
          # pkgs.nodejs       # Añade Node.js (usa la versión por defecto de nixpkgs)
          # pkgs.nodePackages.prettier # <-- Aquí está Prettier
          ];

        shellHook = ''
          echo "Welcome to my python shell"
        '';

        # Todo lo que no sea una opcion sera una variable de entorno
        MYVAR = "MiVariableEntorno";
      };
    };
}
