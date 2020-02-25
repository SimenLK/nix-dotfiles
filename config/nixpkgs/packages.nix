{ pkgs, options }:
with pkgs;
let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  hie = all-hies.selection { selector = p: { inherit (p) ghc865; }; };
  sys = [
    dpkg
    cryptsetup
    fuse
    nmap
    bind
    openldap
    iftop
    openssl
    inetutils
    unrar
    dmidecode
    ethtool
    parted
    pciutils
    pwgen
    usbutils
  ];
  user = [
    kubernetes-helm
    kubectl
    gnupg
    tomb
    sshuttle
    minio-client
    openfortivpn
  ];
  devel = [
    git
    patchelf
    binutils
    gcc
    gdb
    cmake
    libxml2
    chromedriver
    awscli
    postgresql
    docker_compose
    gnumake
    gradle
    gettext
    nix-prefetch-scripts
    sqlite-interactive
    # sqsh
    # automake
    # autoconf
    # libtool
  ];
  desktop = if ! options.desktop.enable then [] else [
    xmonad-log
    dropbox-cli
    wireshark-qt
    xorg.xmodmap
    xorg.xev
    glib
    google-chrome
    # googleearth
    firefox
    drive
    meld
    mplayer
    xorg.xmessage
    xorg.xvinfo
    imagemagick
    rdesktop
    remmina
    scrot
    xsel
    taskwarrior
    # timewarrior
    pass
    tectonic
    pavucontrol
    gimp
    spotify
    gnome3.dconf-editor
    signal-desktop
    inkscape
    # ledger
    # slack
    # pidgin
    # pidginsipe
    vscode
    # browserpass
    calibre
    cargo
    farstream
    freerdp
    fira-code
    keybase
    keybase-gui
    pandoc
    networkmanager
    networkmanagerapplet
    sshfs-fuse
    pinentry
    polkit_gnome
    steghide
    cdrtools
    innoextract
    tectonic
    timewarrior
    tlaps
    unrtf
    # wireshark-cli
    xclip
    wavebox
    gnome3.gnome-settings-daemon
    gnome3.gnome-font-viewer
    gnome3.adwaita-icon-theme
    gnome3.gnome-themes-extra
    gnome3.evince
    gnome3.gnome-calendar
    gnome3.gnome-bluetooth
    gnome3.seahorse
    gnome3.nautilus
    gnome3.dconf
    gnome3.gnome-disk-utility
    gnome3.gnome-tweaks
    gnome3.eog
    gnome3.networkmanager-fortisslvpn
    blueman
    gparted
    virtmanager
    qrencode
    wkhtmltopdf
    zbar
    haskellPackages.yeganesh
    xmobar
    dmenu
    zoom-us
  ];
  haskell = if ! options.haskell then [] else with haskellPackages; [
    ghc
    stack
    hie
    cabal-install
    hlint
    hoogle
    # cabal2nix
    # alex
    # happy
    # cpphs
    # hscolour
    # haddock
    # pointfree
    # pointful
    # hasktags
    # threadscope
    # hindent
    # codex
    # hscope
    # glirc
  ];
  dotnet = if ! options.dotnet then [] else with dotnetCorePackages; [
    sdk_3_1
    # mono
  ];
  python = if ! options.python then [] else with pythonPackages;
     python3.withPackages (ps: with ps; [
      numpy
      matplotlib
      tkinter
    ]);
  node = if ! options.node then [] else with nodePackages; [
    nodejs
    npm
    yarn
    webpack
    # node2nix
    # gulp
    # bundler
    # bundix
    # yo
    # purescript
    # psc-package
    # pulp
    # cordova
  ];
  proton = if ! options.proton then []  else [
    protonvpn-cli
    openvpn
    python
    dialog
  ];
  languages = if ! options.languages then []  else [
    idris
    io
    clooj
    leiningen
  ];
in
  sys ++
  user ++
  devel ++
  desktop ++
  dotnet ++
  haskell ++
  node ++
  languages ++
  python ++
  proton ++
  []
