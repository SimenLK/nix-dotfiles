{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles.packages.desktop;

  fcitx = (self: super: { fcitx-engines = pkgs.fcitx5; });

  configuration = {
    nixpkgs.overlays = [
      (import ../overlays/wavebox.nix)
      #(import ../overlays/teams.nix)
      # (import ../overlays/vscode.nix)
      (import ../overlays/rider.nix)
      (import ../overlays/discord.nix)
      (import ../overlays/ferdium.nix)
      (import ../overlays/obsidian.nix)
      fcitx
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

  gnome = with pkgs; [
    galculator
    gnome3.gucharmap
    gnome3.gnome-settings-daemon
    gnome3.gnome-font-viewer
    gnome3.adwaita-icon-theme
    gnome3.gnome-themes-extra
    gnome3.evince
    gnome3.gnome-calendar
    gnome3.gnome-bluetooth
    gnome3.seahorse
    gnome3.nautilus
    dconf
    gnome3.gnome-disk-utility
    gnome3.gnome-tweaks
    gnome3.eog
    gnome3.networkmanager-fortisslvpn
    gnome3.gnome-keyring
    gnome3.dconf-editor
    desktop-file-utils
    gcolor3
    lxappearance
  ];

  graphics = with pkgs; [
    aseprite
    gimp
  ];

  desktop = with pkgs; [
    blueman
    brightnessctl
    cdrtools
    chromium
    dconf
    dunst
    drive
    ferdium
    firefox
    freerdp
    google-chrome
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
    slack
    discord
  ];

  tex = with pkgs; [ texlive.combined.scheme-full ];

  useIf = x: y: if x then y else [ ];

  enabledPackages =
    desktop
    ++ useIf cfg.gnome gnome
    ++ useIf cfg.x11 x11
    ++ useIf cfg.media media
    ++ useIf cfg.chat chat
    ++ useIf cfg.graphics graphics
    ++ useIf cfg.wavebox [ pkgs.wavebox ]
    ++ useIf cfg.zoom [ pkgs.zoom-us ]
    ++ useIf cfg.factorio [ pkgs.factorio ]
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
    factorio = mkEnableOption "Enable factorio!";
    tex = mkEnableOption "Enable LaTeX";
    IDE = mkEnableOption "Enable your IDE, aka Rider in this case :)";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [ configuration ]);
}
