# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hosts.nix
    ];

  nixpkgs.overlays = [
    (final: prev: {
      unstable = import <nixos-unstable> {
        config = { allowUnfree = true; };
        system = prev.system;
      };
    })
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "marvelmachine"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;


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
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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
    extraGroups = [ "networkmanager" "wheel" "video" "dialout" "mlocate" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.steam.enable = true;

  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # development environment
    zsh
    neovide
    git
    unstable.jujutsu
    thefuck
    silver-searcher
    jump
    kitty
    stack
    gnumake
    tmux
    jq
    haskellPackages.pointfree
    direnv
    unstable.fzf
    mermaid-cli

    # desktop
    xmonad-with-packages
    brave
    acpilight # xbacklight
    redshift
    rofi
    feh
    eww
    playerctl
    scrot
    urlencode # for hackage search
    lsof

    # apps
    spotify
    pavucontrol
    beeper
    thunderbird
    gimp-with-plugins
    evince
    calibre
    unstable.yed
    inkscape
    rmapi
    transcribe
    vlc
    libreoffice-qt6-still
    deluge-gtk
    wineWowPackages.stable
    sqlite-interactive
    asciinema
    desmume

    # utils
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
    vdpauinfo
    yt-dlp
    unrar
    graphviz
    (agda.withPackages (ps: [
      ps.standard-library
    ]))
    proxmark3
    zip
    oath-toolkit #gashell
    openssl #gashell
    zbar #gashell
    curl #gashell
    # texliveFull
    flamegraph
    inotify-tools
    p7zip
    bat
    fd
    tree
    btop
    lsd
    fsatrace


    # fpga
    openfpgaloader
    python312Packages.apycula # opensource gowin packing

    # temporary

    vaapiVdpau
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers
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
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  services.miniflux.enable = true;
  services.miniflux.adminCredentialsFile = "/home/sandy/.tino/miniflux.conf";

  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.opengl.enable = true;

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
  '';


  # things to run
  services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap /home/sandy/.xmodmaprc";

  # thunderbolt
  services.hardware.bolt.enable = true;

  # voice isolation
  programs.noisetorch.enable = true;

  # enable calibre content server
  networking.firewall.allowedTCPPorts  = [ 9090 ];
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
    localuser = null;
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

}
