{ config, pkgs, ... }:

{
  imports = [
    ./i3.nix
  ];
  home.username = "narrator";
  home.homeDirectory = "/home/narrator";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    git
    firefox
    neovim
    btop
    flameshot
    xclip
    psmisc
    dmenu
    picom
    telegram-desktop
    feh
    alacritty
    i3-gaps
    lsd
    polybar
    tmux
    zoxide
    fortune
    nixpkgs-fmt
	rofi


  ];

}
