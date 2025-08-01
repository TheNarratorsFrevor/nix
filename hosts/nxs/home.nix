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
services.picom = {
  enable = true;
  settings = {
    vsync = true;
    backend = "glx";
    glx-no-stencil = true;
    glx-copy-from-front = false;
    use-damage = false;
  };
};

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
