{ config, pkgs, ... }:

{
  imports = [
    ./i3.nix
    ./i3blocks.nix
  ];
  home.username = "narrator";
  home.homeDirectory = "/home/narrator";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    pavucontrol
    git
    sl
    firefox
    neovim
    i3blocks
	strawberry
    iproute2
    gawk
    inetutils
    gnugrep
    wireplumber
    lm_sensors
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
    pipewire

  ];

}
