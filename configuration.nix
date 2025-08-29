# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./hosts.nix
    ];

#   nixpkgs.overlays = [
#     (final: prev: {
#       unstable = import <nixos-unstable> {
#         config = { allowUnfree = true; };
#         system = prev.system;
#       };
#     })
#   ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "marvelmachine"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [22 8080 9090 8112];


  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ./xmonad.hs;
  };

  services.deluge = {
    enable = true;
    web.enable = true;
  };

  services.libinput.enable = true;
  services.libinput.touchpad = {
    clickMethod = "clickfinger";
    tapping = true;
    disableWhileTyping = true;
    middleEmulation = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;  # Enables .local resolution
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      domain = true;
    };
  };

  # rss
  services = {
    freshrss = {
      enable = true;
      defaultUser = "sandy";
      authType = "none";
      baseUrl = "http://localhost:8080";
      virtualHost = "localhost";  # disables default nginx vhost setup
    };

    nginx = {
      enable = true;
      virtualHosts."localhost" = {
        listen = [{
          addr = "0.0.0.0";
          port = 8080;
        }];
      };
    };
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sandy = {
    isNormalUser = true;
    description = "Sandy";
    extraGroups = [ "networkmanager" "wheel" "video" "dialout" "mlocate" "usb" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  # programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.steam.enable = true;

  # programs.neovim = {
  #   enable = true;
  #   vimAlias = true;
  # };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # development environment
    zsh
    neovide
    neovim
    git
    jujutsu
    thefuck
    silver-searcher
    jump
    kitty
    stack
    gnumake
    tmux
    jq
    direnv
    fzf
    mermaid-cli
    # gh
    futhark
    chromium

    # desktop
    brave
    acpilight # xbacklight
    redshift
    rofi
    feh
    eww
    scrot
    urlencode # for hackage search
    lsof
    # restream
    xscreensaver

    # calendar
    khal
    vdirsyncer

    # apps
    pavucontrol
    beeper
    thunderbird
    gimp-with-plugins
    evince
    calibre
    transcribe
    vlc
    asciinema
    neomutt # mail
    khard # contacts
    reaper
    # rustdesk

    # utils
    bitwarden-cli
    wget
    coreutils # chown; chmod
    thermald # powermgmt
    xorg.xmodmap
    xorg.xsetroot
    xorg.xev
    xclip
    acpi
    lm_sensors
    xarchiver
    xfce.tumbler # thumbnails
    pciutils # lspci
    usbutils # lsusb
    inxi
    tzdata
    intel-gpu-tools
    libva-utils
    htop
    unrar
    graphviz
    (agda.withPackages (ps: [
      ps.standard-library
    ]))
    # proxmark3
    zip
    oath-toolkit #gashell
    openssl #gashell
    zbar #gashell
    curl #gashell
    # flamegraph
    inotify-tools
    bat
    tree
    btop

    # music
    timidity
    lilypond

    # soh
    shipwright

    freecad

    # # fpga
    # unstable.openfpgaloader
    # unstable.python312Packages.apycula # opensource gowin packing
    # unstable.nextpnr
    # yosys
  ];

  fonts.packages = with pkgs; [
    font-awesome
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.graphics.enable = true;

  powerManagement.enable = true;
  # powerManagement.powertop.enable = true;
  services.thermald.enable = true;
  services.tlp.enable = true;

  # don’t shutdown when power button is short-pressed
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

  services.udev.extraRules = ''
# backlight
RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/acpi_video0/brightness"
RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/acpi_video0/brightness"

# oryx
# https://github.com/zsa/wally/wiki/Linux-install#2-create-a-udev-rule-file
KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"

# flipper
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", TAG+="uaccess"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="40??", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
  '';


  # things to run
  services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap /home/sandy/.xmodmaprc";

  # thunderbolt
  services.hardware.bolt.enable = true;

  # voice isolation
  programs.noisetorch.enable = true;

  # enable calibre content server
  environment.variables."SSL_CERT_FILE" = "/etc/ssl/certs/ca-bundle.crt";

  # Binary Cache for Haskell.nix
  nix.settings.trusted-public-keys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.settings.substituters = [
    "https://cache.iog.io"
  ];

  # mlocate support
  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    interval = "hourly";
  };

  # work stuff
  services.tailscale.enable = true;
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "mydatabase" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

services.xscreensaver = {
  enable = true;
};

# for bazr
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
xdg.portal.enable = true;
services.flatpak.enable = true;


# mimes
environment.etc."xdg/mimeapps.list".text = ''
    [Default Applications]
    text/plain=neovide.desktop
    text/markdown=neovide.desktop
    application/json=neovide.desktop
    application/x-yaml=neovide.desktop
    application/x-shellscript=neovide.desktop
  '';

# eww
  system.activationScripts.ewwConfigs = {
    text = ''
      rm -rf ${config.users.users.sandy.home}/.config/eww
      ln -sf /etc/nixos/eww ${config.users.users.sandy.home}/.config/eww
      chown sandy:users ${config.users.users.sandy.home}/.config/eww
    '';
  };

boot.loader.systemd-boot.configurationLimit = 5;

}

