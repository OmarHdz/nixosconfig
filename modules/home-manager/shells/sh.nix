{ config, pkgs, ... }:

let
 myAliases = {
    ll = "ls -l";
    v = "nvim";
    lg = "lazygit";
    cd = "z";
    ff = "yazi";
    lst="eza --color=always --tree --level=2 --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
  };
in
{
  # programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    shellAliases = myAliases;
    initExtra = ''
        eval "$(oh-my-posh init zsh --config '${config.xdg.configHome}/ohmyposh/mytheme.json')"
        test -z "$TMUX" && tmux
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
