# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [
     # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # Enable OpenGL
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia  = {

    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    powerManagement.finegrained = false;
    # Use the NVidia open source kernel module (not to be confused with the
    open = false;
    # Enable the Nvidia settings menu,
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = ["ntfs" "fuse"];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.interfaces.enp14s0f4u2u3c2.useDHCP = true;
  networking.interfaces.br0.useDHCP = true;
  networking.bridges = {
    "br0" = {
      interfaces = [ "enp14s0f4u2u3c2" ];
    };
  };

  virtualisation.libvirtd.enable = true;  
  
  programs.virt-manager.enable = true;


#enp14s0f4u2u3c2
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Winnipeg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

#  programs.hyprland = {
#    enable = true;
#    xwayland.enable = true;
#  };

#  environment.sessionVariables = {
#    WLR_NO_HARDWARE_CURSORS = "1";
#    NIXOS_OZONE_WL = "1";
#  };
  
  xdg.portal.enable = true;
#  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

#  environment.systemPackages = lib.remove "xdg-desktop-portal-gtk" config.environment.systemPackages;

  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tim = {
    isNormalUser = true;
    description = "Tim Hughes";
    extraGroups = [ "networkmanager" "wheel" ];
  };

 # users.users.nixosvmtest.isSystemUser = true ;
 # users.users.nixosvmtest.initialPassword = "test";
 # users.users.nixosvmtest.group = "nixosvmtest";
 # users.groups.nixosvmtest = {};
 
   
  users.users.nixosvmtest = {
    isNormalUser = true;
    initialPassword = "test";
    group = "nixosvmtest"; # This group should exist
  };
   
  users.groups.nixosvmtest = {};
  

  # Home Manager configuration for your user.
  home-manager.users.tim = {
    home.stateVersion = "24.05";
    
    # Define your user-specific Home Manager configuration.
    # Example configurations:
    programs.git.enable = true; 

    # Add more user-specific configurations here.
  };
  
  nix.settings.experimental-features = ["nix-command" "flakes" ];

  programs.appimage.enable = true;

  programs.appimage.binfmt = true;

  services.flatpak.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    #platformOptimizations.enable = true;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    fastfetch
    obsidian
    _1password-gui
    localsend
    discord
    brave
    beeper
    mpv
    btop
    git
    streamcontroller
    prismlauncher
    gnome-extension-manager
    dconf-editor
    lutris
    heroic
    qemu
    gnome-tweaks
    alacritty
    r2modman
    ryujinx
    github-desktop
    os-prober
    protonup-ng
    unzip
    gparted
    kitty
    grub2
    gearlever
    appimage-run
    fuse
    libepoxy
    patchelf
    waybar
    dunst
    libnotify
    swww
    rofi-wayland
    gnome-text-editor
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
