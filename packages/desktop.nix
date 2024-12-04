{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles.packages.desktop;

  configuration = {
    nixpkgs.overlays = [
      (import ../overlays/wavebox.nix)
      #(import ../overlays/teams.nix)
      # (import ../overlays/vscode.nix)
      (import ../overlays/rider.nix)
      (import ../overlays/discord.nix)
      (import ../overlays/ferdium.nix)
      # (import ../overlays/obsidian.nix)
    ];

    dotfiles.packages.desktop = {
      media = lib.mkDefault true;
      x11 = lib.mkDefault true;
      gnome = lib.mkDefault true;
      chat = lib.mkDefault true;
      graphics = lib.mkDefault true;
      tex = lib.mkDefault false;
    };

    home.packages = enabledPackages;
  };

  media = with pkgs; [
    obs-studio
    # audacity
    # xf86_input_wacom
    # mpv
    peek
  ];

  x11 = with pkgs; [
    xorg.appres
    xorg.editres
    xorg.listres
    xorg.viewres
    xorg.luit
    xorg.xdpyinfo
    xorg.xdriinfo
    xorg.xev
    xorg.xfd
    xorg.xfontsel
    xorg.xkill
    xorg.xlsatoms
    xorg.xlsclients
    xorg.xlsfonts
    xorg.xmessage
    xorg.xprop
    xorg.xvinfo
    xorg.xwininfo
    xorg.xmessage
    xorg.xvinfo
    xorg.xmodmap
    glxinfo
    xclip
    xsel
  ];

  gnome3 = with pkgs; [
    galculator
    gucharmap
    gnome-settings-daemon
    gnome-font-viewer
    adwaita-icon-theme
    gnome-themes-extra
    evince
    gnome-calendar
    gnome-bluetooth
    seahorse
    nautilus
    dconf
    gnome-disk-utility
    gnome-tweaks
    eog
    networkmanager-fortisslvpn
    gnome-keyring
    dconf-editor
    desktop-file-utils
    gcolor3
    lxappearance
  ];

  graphics = with pkgs; [
    gimp
  ];

  desktop = with pkgs; [
    blueman
    brightnessctl
    cdrtools
    google-chrome
    dconf
    drive
    ferdium
    freerdp
    gparted
    keybase
    keybase-gui
    libreoffice
    libnotify
    newsflash
    obsidian
    pandoc
    pass
    pavucontrol
    pinentry
    remmina
    rssguard
    spotify
    wireshark
  ];

  IDE = with pkgs; [
    rider
  ];

  chat = with pkgs; [
    discord
  ];

  tex = with pkgs; [ texlive.combined.scheme-full ];

  useIf = x: y: if x then y else [ ];

  enabledPackages =
    desktop
    ++ useIf cfg.gnome gnome3
    ++ useIf cfg.x11 x11
    ++ useIf cfg.media media
    ++ useIf cfg.chat chat
    ++ useIf cfg.graphics graphics
    ++ useIf cfg.wavebox [ pkgs.wavebox ]
    ++ useIf cfg.zoom [ pkgs.zoom-us ]
    ++ useIf cfg.tex tex
    ++ useIf cfg.IDE IDE;
in
{
  options.dotfiles.packages.desktop = with lib; {
    enable = mkEnableOption "Enable desktop packages";
    media = mkEnableOption "Enable media packages";
    chat = mkEnableOption "Enable chat clients";
    x11 = mkEnableOption "Enable x11 packages";
    gnome = mkEnableOption "Enable gnome packages";
    graphics = mkEnableOption "Enable graphics packages";
    wavebox = mkEnableOption "Enable wavebox";
    zoom = mkEnableOption "Enable zoom";
    tex = mkEnableOption "Enable LaTeX";
    IDE = mkEnableOption "Enable your IDE, aka Rider in this case :)";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [ configuration ]);
}
