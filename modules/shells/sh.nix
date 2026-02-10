{ config, pkgs, ... }:

let
 myAliases = {
    v = "nvim";
    ll = "ls -l";
    lg = "lazygit";
    ldk = "lazydocker";
    ff = "yazi";
    cat="bat -p --theme=default";

    uva="uv venv && uv init . && git init . && echo 'source .venv/bin/activate' >> .envrc && direnv allow && clear";
    lh="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions";
    ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
    lst="eza --color=always --tree --level=2 --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
    lst2="eza --color=always --tree --level=3 --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
    lp="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions";

    show="wezterm imgcat --tmux-passthru=enable --hold";
    showi="echo 'Usar sin tmux' && timg -p 's'";
    showw="wslview";
    showf="feh";
    showv="viu";

    nrs="echo 'sudo nixos-rebuild switch --flake .' && sudo nixos-rebuild switch --flake .";
    hms="echo 'home-manager switch --flake .' && home-manager switch --flake .";

    aq="sh ~/nixosconfig/docs/scripts/consultaAi.sh";
    caq="sh ~/nixosconfig/docs/scripts/comandosQuery.sh";
    saq="sh ~/nixosconfig/docs/scripts/streamConsulta.sh";
    daq="sh ~/nixosconfig/docs/scripts/deekseekQuery.sh";
    imgg="sh ~/nixosconfig/docs/scripts/imageGen.sh";
    setd="sh ~/nixosconfig/docs/scripts/setDevEnv.sh";
    setpy="sh ~/nixosconfig/docs/scripts/setDevEnv.sh";
    tabla="bash ~/nixosconfig/docs/scripts/tabla.sh";
    tm="sh ~/nixosconfig/docs/scripts/tmux-plantilla.sh";
    ayu="~/nixosconfig/docs/scripts/ayu";
    brain="cd /mnt/c/Users/omarh/Documents/Obsidian Vault && nvim .";

  };
in
{
  # programs.bash.enable = true;
  programs.zsh = {
    enable = true;

    shellAliases = myAliases;
    enableCompletion = true; # Habilita el sistema de compleción de Zsh
    syntaxHighlighting = {
      enable = true;
    };
    autosuggestion = {
      enable = true;
    };
    # loginShell = true;

    initExtra = ''
        export PATH="/mnt/c/Users/omarh/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"
        eval "$(oh-my-posh init zsh --config '${config.xdg.configHome}/ohmyposh/mytheme.json')"
        test -z "$TMUX" && tmux
        eval "$(zoxide init --cmd cd zsh)"
        eval "$(direnv hook zsh)"
        # Bind ctrl-r but not up arrow
        eval "$(atuin init zsh --disable-up-arrow)"
        touch ~/.special_keys
        source ~/.special_keys
        source $HOME/.local/bin/env
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

        # Editor con sudoedit
        export EDITOR="nvim"
        export VISUAL="nvim"

        # Ejecuta gitcheck en la terminal para revisar todos los repositorios en la carpeta actual
        # Se compara todos los cambios con los repositorios remotos origin
        function gitcheck() {
            local TARGET_DIR="''${1:-.}"
            if [ ! -d "$TARGET_DIR" ]; then
                echo "❌ Error: La carpeta '$TARGET_DIR' no existe."
                return 1
            fi
            (
                cd "$TARGET_DIR" || return
                echo "🔍 Revisando repositorios en: $(pwd)"
                for d in ./*/(N); do
                    if [ -d "$d/.git" ]; then
                        NAME=$(basename "$d")
                        (
                            cd "$d"
                            git fetch -q
                            STATUS_BRANCH=$(git status -sb)
                            STATUS_FILES=$(git status --porcelain)
                            MSG=""
                            if echo "$STATUS_BRANCH" | grep -q "behind"; then
                                MSG="$MSG ❌ BEHIND"
                            fi
                            if echo "$STATUS_BRANCH" | grep -q "ahead"; then
                                MSG="$MSG ⬆️ PUSH"
                            fi
                            if [ -n "$STATUS_FILES" ]; then
                                MSG="$MSG ✏️ DIRTY"
                            fi
                            if [ -z "$MSG" ]; then
                                echo "✅ $NAME"
                            else
                                echo "⚠️  $NAME ->$MSG"
                            fi
                        )
                    fi
                done
            )
        }

        # Ver puertos
        function puertos() {
          for s in $(systemctl list-units --type=service --state=running --no-legend | awk '{print $1}'); do
            pid=$(systemctl show -p MainPID --value $s)
            if [ "$pid" != "0" ]; then
              ports=$(sudo ss -ltnp | grep "pid=$pid" | awk '{print $4}')
              if [ ! -z "$ports" ]; then
                echo "$s (PID $pid):"
                echo "$ports"
                echo
              fi
            fi
          done
        }
     '';

    # --- Mueve la configuración de Oh My Zsh aquí ---
    oh-my-zsh = {
      enable = true;
      # theme = "agnoster"; # Tu tema elegido
      plugins = [
        "git"
        # Descomenta si los necesitas y tienes las herramientas base instaladas
        # (sudo suele estar, docker necesita pkgs.docker en home.packages)
        # "sudo"
        # "docker"
        # "zsh-syntax-highlighting"
        # "zsh-autosuggestions"
      ];
    };

    # interactiveShellInit = ''
    #   source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    #   # Si también quieres autosuggestions:
    #   source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # '';
  };

  # programs.bash.enable = true;
	# # Cargar el entorno de Nix
	# if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
	# . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
	# fi
  programs.bash = {
    enable = true;
    shellAliases = myAliases;
    initExtra = ''
    if [ -x "$(command -v zsh)" ] && [ "$(basename "$SHELL")" != "zsh" ] && [ -n "$PS1" ]; then
      # Asegúrate de que el PATH de Nix esté cargado antes de intentar ejecutar zsh
      # (esto ya debería estar más arriba en tu .bashrc como discutimos antes)
      # if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
      #   . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      # fi
      # Comprueba de nuevo si zsh existe DESPUÉS de cargar el perfil de Nix
      if [ -x "$(command -v zsh)" ]; then
          export SHELL=$(which zsh) # Establece la variable SHELL correctamente para Zsh
          exec $(which zsh) -l     # Ejecuta zsh como shell de login
      fi
    fi
    eval "$(oh-my-posh init bash --config '${config.xdg.configHome}/ohmyposh/mytheme.json')"
     '';
  };


}
