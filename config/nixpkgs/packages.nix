{ pkgs, options }:
with pkgs;
let
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
    nixos-generators
    utillinux
  ];
  user = [
    byobu
    direnv
    gnupg
    heroku
    kubectl
    kubernetes-helm
    lorri
    minikube
    minio-client
    openfortivpn
    prometheus-alertmanager
    sshuttle
    tomb
  ];
  libs = [
    llvmPackages.clang-unwrapped
    openmpi
    texlive.combined.scheme-full
    tk
    cairo
    pkg-config
    icu
    zlib
    lttng-ust
    libsecret
    libkrb5
    libpng
  ];
  devel = [
    # autoconf
    # automake
    # libtool
    # python37Packages.virtualenv
    # sqsh
    awscli
    binutils
    cask
    cgdb
    chromedriver
    cmake
    ctags
    docker_compose
    fzf
    gcc
    gdb
    gettext
    git
    gnum4
    gnumake
    gradle
    libxml2
    niv
    nix-prefetch-scripts
    patchelf
    postgresql
    ripgrep
    sqlite-interactive
  ]
  ++ libs;
  media = [
    audacity
    gcolor3
    guvcview # webcam
    mpv
    rhythmbox
    shotcut
    simplescreenrecorder
    xf86_input_wacom
  ];
  x11 = with xorg; [
    brightnessctl
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
    glxinfo
    xclip
    xmessage
    xvinfo
    xmodmap
    xsel
  ];
  gnome = with gnome3; [
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
  ];
  desktop = if ! options.desktop.enable then [] else [
    ardour
    blueman
    calibre
    cargo
    cdrtools
    discord
    dmenu
    drive
    dropbox-cli
    exercism
    farstream
    fira-code
    firefox
    freerdp
    geckodriver
    glib
    gparted
    gperftools
    haskellPackages.yeganesh
    imagemagick
    inkscape
    innoextract
    keybase
    keybase-gui
    krita
    megatools
    meld
    networkmanager
    networkmanagerapplet
    pandoc
    pass
    pavucontrol
    pinentry
    polkit_gnome
    qrencode
    rdesktop
    remmina
    scrot
    sdcv
    signal-desktop
    spotify
    sshfs-fuse
    steghide
    taskwarrior
    teams
    tectonic
    tectonic
    timewarrior
    unrtf
    virtmanager
    vscode
    wireshark-qt
    wkhtmltopdf
    xmobar
    xmonad-log
    zbar
    zoom-us
  ]
  ++ gnome
  ++ x11
  ++ media
  ++ [];
  haskell = if ! options.haskell then [] else with haskellPackages; [
    ghc
    # stack
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
    sdk_5_0
    omnisharp-roslyn
    # mono
  ];
  R-packages = if ! options.R then [] else with rPackages; [
    readr
    tidyverse
    zoo
    broom
    lubridate
  ];
  python = if ! options.python then [] else with pythonPackages; [
    (python3.withPackages ( ps: with ps; [
        numpy
        matplotlib
        rpyc
        aiohttp
        requests
        beautifulsoup4
        pandas
      ])
    )
  ];
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
    go
    go2nix
  ];
in
  sys
  ++ user
  ++ devel
  ++ desktop
  ++ dotnet
  ++ haskell
  ++ node
  ++ languages
  ++ R-packages
  ++ python
  ++ proton
  ++ [] # my monoid friend
