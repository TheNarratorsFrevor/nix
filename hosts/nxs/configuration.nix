# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fileSystems."/home" = {
    device = "/dev/nvme0n1p7";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };
  swapDevices = [
    { device = "/dev/nvme0n1p8"; }
  ];
  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;

  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.extraConfig = ''
    GRUB_DISABLE_OS_PROBER=false  
  '';
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nxs"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    libinput = {
      enable = true;

      touchpad = {
        naturalScrolling = true;
        tapping = true;
        disableWhileTyping = true;
        clickMethod = "clickfinger";
      };
    };

    displayManager.lightdm = {
	enable = true;
	    autoLogin.enable = true;
    autoLogin.user = "narrator";
 };
windowManager.i3.enable = true;

  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.fish.enable = true;
  users.users.narrator = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    os-prober
    fish
    htop
    curl
    git
    lightdm
    i3-gaps
  ];
  fonts.packages = with pkgs; [
  nerd-fonts.fira-code
  nerd-fonts.droid-sans-mono
nerd-fonts.symbols-only
];
services.logind = {
  lidSwitch = "suspend";
  lidSwitchDocked = "ignore";
  lidSwitchExternalPower = "lock";
  extraConfig = ''
    HandlePowerKey=suspend
    HandleSuspendKey=hibernate
  '';
};

# firewall bc duh
networking.firewall.enable = true;

# time sync
services.timesyncd.enable = true;


# bluetooth
hardware.bluetooth.enable = true;
services.blueman.enable = true;

# enable printing
services.printing.enable = true;

# enable openssh for remote access
services.openssh.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}

