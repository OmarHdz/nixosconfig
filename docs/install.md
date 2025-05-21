
# https://www.youtube.com/watch?v=cZDiqGWPHKI
# https://www.youtube.com/watch?v=hLxyENmWZSQ
Instalar nix
# no usar sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

Agregamos el channel unstable o master
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

Run the Home Manager installation command and create the first Home Manager generation:
nix-shell '<home-manager>' -A install

sh```
mkdir -p ~/.config/nix
touch ~/.config/nix/nix.conf
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
echo "accept-flake-config = true" >> ~/.config/nix/nix.conf
s```

nix shell nixpkgs#home-manager nixpkgs#gh --command sh -c "gh auth login && gh repo clone OmarHdz/nixosconfig -- --depth=1 "
nix shell nixpkgs#home-manager --command sh -c "home-manager switch -b bkup --flake ."
home-manager switch -b bkup --flake .

programs.zsh.enabled = true
nix --extra-experimental-features nix-command --extra-experimental-features flakes shell nixpkgs#home-manager  
nix shell nixpkgs#home-manager  
nixpkgs#gh --command sh -c "\
gh auth login \
&& gh repo clone OmarHdz/nixosconfig -- --depth=1 \
"
nix shell nixpkgs#home-manager --command sh -c "home-manager switch -b bkup --flake ."

nix shell nixpkgs#home-manager --command sh -c "home-manager switch --flake ./nixosconfig#nixos "


? Where do you use GitHub? GitHub.com
? What is your preferred protocol for Git operations on this host? SSH
? Generate a new SSH key to add to your GitHub account? Yes
? Enter a passphrase for your new SSH key (Optional):
? Title for your SSH key: GitHub CLI
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: 9E93-0B76
Press Enter to open https://github.com/login/device in your browser...
Esperar a que se autorice, como 20seg



nix --extra-experimental-features nix-command --extra-experimental-features flakes shell nixpkgs#home-manager  nixpkgs#gh --command sh -c "\
home-manager switch --flake ./nixosconfig#nixos "

nix shell nixpkgs#home-manager --command sh -c "home-manager switch --flake ./nixosconfig#nixos "

source $HOME/.nix-profile/etc/profile.d/nix.sh
exec zsh

poner en .bashrc o .profile
# Cargar el entorno de Nix
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
