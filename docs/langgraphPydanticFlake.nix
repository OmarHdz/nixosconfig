{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
  };

  outputs = { self, nixpkgs }: 
  let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    pythonVersion = pkgs.python312;
    pypk = pythonVersion.pkgs;
    langgraph-no-tests = pypk.langgraph.overridePythonAttrs (oldAttrs: {
        doCheck = false;
      });
    # --- Definición para pydantic-ai ---
    pydantic-ai = pypk.buildPythonPackage rec {
      pname = "pydantic-ai";
      # Reemplaza con la versión más reciente que encontraste en PyPI
      version = "0.1.3"; # <--- ACTUALIZA ESTA VERSIÓN SI ES NECESARIO

      src = pypk.fetchPypi {
        inherit pname version;
        sha256 = "1lnisbnwjyn1sk4a4glpz2rww1mrj9k8zz6zny0l36gmapc0hvny";
      };

      # Lista las dependencias de pydantic-ai encontradas en PyPI/repo
      # Mapeadas a los nombres de Nixpkgs (pypk.nombre_paquete)
      propagatedBuildInputs = [
        pypk.pydantic # Casi seguro que necesita pydantic
      ];

      # Información Meta (opcional pero buena práctica)
      meta = {
        description = "Integrates LLMs with Pydantic models for structured outputs";
        homepage = "https://github.com/pydantic/pydantic-ai"; # Verifica la URL correcta
        # license = licenses.mit; # Verifica la licencia correcta
      };
    };
  in
  {
    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
    # devShells."x86_64-linux".default = import ./shell.nix { inherit pkgs; };

      devShells."x86_64-linux".default = pkgs.mkShell {
        packages = [ 
          pythonVersion
          pypk.numpy
          # pypk.langgraph
          langgraph-no-tests
          pydantic-ai
          # pypk.pydantic-ai
          pypk.docker
          pypk.uv
          # pypk.pprint
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
