{ config, pkgs, ... }:

let
 myAliases = {
    ll = "ls -l";
    v = "nvim";
    lg = "lazygit";
    ff = "yazi";
    cat="bat --theme=default";

    uva="uv venv && echo 'source .venv/bin/activate' > .envrc && direnv allow && clear";
    lh="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions";
    ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
    lst="eza --color=always --tree --level=2 --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";

    show="wezterm imgcat --tmux-passthru=enable --hold";
    showi="echo 'Usar sin tmux' && timg -p 's'";
    showw="wslview";
    showf="feh";
  };
in
{
  # programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ]; # "sudo" "docker" ];  # Plugins que desees
      theme = "agnoster";                   # Tema (ej: "robbyrussell", "agnoster")
    };
    shellAliases = myAliases;
    interactiveShellInit = ''
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      # Si también quieres autosuggestions:
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    '';
    initExtra = ''
        eval "$(oh-my-posh init zsh --config '${config.xdg.configHome}/ohmyposh/mytheme.json')"
        test -z "$TMUX" && tmux
        eval "$(zoxide init --cmd cd zsh)"
        eval "$(direnv hook zsh)"
        # Bind ctrl-r but not up arrow
        eval "$(atuin init zsh --disable-up-arrow)"
     '';
  };

  # programs.bash.enable = true;
  programs.bash = {
    enable = true;
    shellAliases = myAliases;
    initExtra = ''
        eval "$(oh-my-posh init bash --config '${config.xdg.configHome}/ohmyposh/mytheme.json')"
     '';
  };


}
