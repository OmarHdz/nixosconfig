{ config, pkgs, lib, ... }:

{

  imports = [
    ../../modules/shells/sh.nix
    ../../modules/shells/zoxide.nix
    ../../modules/shells/git.nix
    ../../modules/shells/direnv.nix
    # ../../modules/home-manager/multiplexer/tmux.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.

    atuin                        # Search history utility
    bat                          # Fancy show files, modern cat
    btop                         # Moniotorea el sistema
    chafa                        # Show images in terminal for neovim
    # cmatrix                      # Terminal matrix theme
    delta                        # Fancy show differences in files
    devenv                       # Isolate nix shell environments
    direnv                       # Activate environment when enter dir
    duf                          # Disc Space measurement
    eza                          # Fancy list directories, modern ls
    fd                           # Modern find
    feh                          # Image in terminal
    fzf                          # Modern find in fuzzy find
    gcc                          # Compilador de c
    gh                           # Github cli, conect, control github
    # ghostscript                  # gs for nvim 
    git                          # Control version control
    git-secrets                  # Control secrets in git
    glow                         # Show markdowns renders in terminal
    gnumake                      # Install make para compilar
    # hollywood                    # Hacker theme
    htop                         # Monitor de sistema
    imagemagick                  # Manejo imagenes, lo pide nvim
    jq                           # Manejo de json en terminal
    lazygit                      # Interactive git ui
    lua5_1                       # Lua5.1 for nvim
    luarocks                     # luarocks for nvim
    mermaid-cli                  # Show mermaid diagrams in terminal
    neofetch                     # Get OS Info
    neovim                       # Best text editor ever
    nodejs_18                    # Nodejs version 18
    oh-my-zsh                    # Package manager for zsh
    oh-my-posh                   # Style terminal
    python3                      # Python3
    python312Packages.pylatexenc # Latex2tex convert text to latex render
    ripgrep                      # Modern grep
    sd                           # Modern sed
    speedread                    # speedread practice
    stow                         # Symlinks dotfiles
    # texlive                      # Latex
    timg                         # Image in terminal
    thefuck                      # Correct things in terminal
    tlrc                         # Show info for commands in fancy way
    tmux                         # Multi terminal managment
    tree-sitter                  # Language parser for nvim
    ueberzugpp                   # Backend to see image in nvim
    uv                           # Fast packages manager python
    vim                          # Great old text editor
    viu                          # Fancy show images in terminal
    wezterm                      # Terminal emulator for gpu
    wget                         # Descargar archivos del internet
    wslu                         # Utility for Wsl
    xclip                        # Clipboard manipulator
    xh                           # Fancy https requests
    yazi                         # Fancy filesystem explorer
    zoxide                       # Fast change directory
    zsh                          # Base Terminal
    zsh-autocomplete             # Autocomple for terminal
    zsh-autosuggestions          # Autosuggestions for terminal
    zsh-syntax-highlighting      # Highligh installed packages

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".tmux.conf".source = ../../modules/multiplexer/tmux.conf;
    ".vimrc".source = ../../modules/editors/vimrc;
    ".config/nvim".source = ../../modules/editors/nvim;
    ".config/ohmyposh/mytheme.json".source = ../../modules/themes/mytheme.json;
    ".config/yazi".source = ../../modules/shells/yazi;
    ".config/lazygit".source = ../../modules/shells/lazygit;

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nixos/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
     EDITOR = "nvim";
  };

  # Activation script to clone tpm if it doesn't exist
  home.activation.cloneTpm = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/.tmux/plugins"
      if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
      fi
    '';

  #home.file.".vimrc".source = ./modules/home-manager/editors/vimrc;
  # home.file.".config/nvim".source = ./modules/home-manager/editors/nvim;
  # home.file.".config/ohmyposh/mytheme.json".source = ./modules/themes/mytheme.json;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
