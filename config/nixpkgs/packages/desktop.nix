{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.packages.desktop;

  configuration = {
    nixpkgs.overlays = [
      (import ../overlays/wavebox.nix)
      #(import ../overlays/teams.nix)
      # (import ../overlays/vscode.nix)
      (import ../overlays/rider.nix)
      (import ../overlays/discord.nix)
    ];

    dotfiles.packages.desktop = {
      media = mkDefault true;
      x11 = mkDefault true;
      gnome = mkDefault true;
      chat = mkDefault true;
      graphics = mkDefault true;
      tex = mkDefault false;
    };

    home.packages = enabledPackages;
  };

  media = with pkgs; [
    # obs-studio
    # audacity
    # xf86_input_wacom
    # mpv
    peek
  ];

  x11 = with pkgs.xorg; [
    appres
    editres
    listres
    viewres
    luit
    xdpyinfo
    xdriinfo
    xev
    xfd
    xfontsel
    xkill
    xlsatoms
    xlsclients
    xlsfonts
    xmessage
    xprop
    xvinfo
    xwininfo
    xmessage
    xvinfo
    xmodmap
    pkgs.glxinfo
    pkgs.xclip
    pkgs.xsel
  ];

  gnome = with pkgs.gnome3; [
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
    pkgs.dconf
    gnome-disk-utility
    gnome-tweaks
    eog
    networkmanager-fortisslvpn
    gnome-keyring
    dconf-editor
    pkgs.desktop-file-utils
    pkgs.gcolor3
    pkgs.lxappearance
  ];

  graphics = with pkgs; [
    aseprite
    # imagemagick
    # scrot
    # krita
    # inkscape
  ];

  desktop = with pkgs; [
    blueman
    brightnessctl
    cdrtools
    dconf
    drive
    fira-code
    firefox
    gparted
    google-chrome
    #innoextract
    keybase
    keybase-gui
    kind
    libreoffice
    neomutt
    openfortivpn
    pandoc
    pass
    pavucontrol
    pinentry
    rider
    spotify
  ];

  chat = with pkgs; [
    slack
    teams
    discord
  ];

  tex = with pkgs; [
    texlive.combined.scheme-full
  ];

  useIf = x: y: if x then y else [];

  enabledPackages =
    desktop ++
    useIf cfg.gnome gnome ++
    useIf cfg.x11 x11 ++
    useIf cfg.media media ++
    useIf cfg.chat chat ++
    useIf cfg.graphics graphics ++
    useIf cfg.wavebox [ pkgs.wavebox ] ++
    useIf cfg.zoom [ pkgs.zoom-us ] ++
    useIf cfg.factorio [ pkgs.factorio ] ++
    useIf cfg.tex tex;

in {
  options.dotfiles.packages.desktop = {
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
  };

  config = mkIf cfg.enable (mkMerge [
    configuration
 ]);

}
