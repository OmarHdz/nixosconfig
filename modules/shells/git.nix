{ config, pkgs, ... }:

{
 programs.git = {
    enable = true; # Asegúrate de que Git esté habilitado

    # --- Configuraciones básicas ---
    userName = "OmarHdz";
    userEmail = "omarhg_@hotmail.com";

    # --- Configuraciones adicionales (equivalente a git config --global key value) ---
    # Usa 'extraConfig' para la mayoría de las opciones
    extraConfig = {
      # init.defaultBranch = "main"; # Cambia la rama por defecto a 'main'
      init.defaultBranch = "main"; # Cambia la rama por defecto a 'main'
      # pull.rebase = true;          # Prefiere rebase en lugar de merge al hacer pull
      github.user = "OmarHdz"; # Útil para herramientas como 'hub' o 'gh'
      # # ... otras opciones ...
      #
      # # Ejemplo de alias
      # alias = {
      #   st = "status -sb";
      #   co = "checkout";
      #   br = "branch";
      #   ci = "commit";
      #   ll = "log --pretty=format:'%C(yellow)%h %C(cyan)%>(12)%ar %C(magenta)%<(10)%aN %C(auto)%d %Creset%s'";
       };
      };
}
