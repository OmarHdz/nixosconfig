{ pkgs ? import <nixpkgs> {} }:

let
  # Define la versión de Python una sola vez para reutilizarla
  pythonVersion = pkgs.python312;
in

pkgs.mkShell {
    packages = [ 
      pythonVersion
      pythonVersion.pkgs.pandas # carga numpy como dependencia
      pythonVersion.pkgs.fastapi # solo funciona de la version 12 en adelante
      pythonVersion.pkgs.debugpy # libreria para debugear
      pythonVersion.pkgs.pytest # libreria para testear
      pythonVersion.pkgs.ipython # python interactivo
      pkgs.ruff
      pkgs.ruff-lsp
      pkgs.mypy
      pkgs.pyright
      # --- Node.js y Prettier ---
      # pkgs.nodejs       # Añade Node.js (usa la versión por defecto de nixpkgs)
      # pkgs.nodePackages.prettier # <-- Aquí está Prettier
      ];

    shellHook = ''
      echo "welcome to my python shell"
    '';

    # Todo lo que no sea una opcion sera una variable de entorno

    MYVAR = "soyunavariable";

    # LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.ncurses]}";
  }
