{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.packages;

  configuration = {
    nixpkgs.overlays = [];

    dotfiles.packages.devel = {
      nix = mkDefault true;
    };

    home.packages = enabledPackages;
  };

  base = with pkgs; [
    autoconf
    automake
    binutils
    cmake
    docker-compose
    difftastic
    fzf
    gcc
    gdb
    gettext
    git
    gnum4
    gnumake
    jq
    libtool
    libxml2
    meld
    ripgrep
    yq-go
    websocat
  ];

  haskell = with pkgs; [
    ghc
    # stack
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

  combined = (with pkgs.dotnetCorePackages; combinePackages [
    pkgs.dotnet-sdk
    pkgs.dotnet-sdk_7
    pkgs.dotnet-sdk_8
  ]);

  dotnet = {
    home.sessionVariables = {
      DOTNET_ROOT = combined;
    };
    home.packages = [
      combined
    ];
  };

  python = with pkgs; [
    (python3.withPackages (ps: with ps; [
        numpy
        matplotlib
        tkinter
        virtualenv
      ]))
  ];

  node = with pkgs.nodePackages; [
    pkgs.nodejs
    npm
    webpack
    webpack-cli
    typescript
    typescript-language-server
  ];

  cpp = with pkgs; [
    ccls
  ];

  rust = with pkgs; [
    rust-analyzer
  ];

  go = with pkgs; [
    go
    go2nix
  ];

  clojure = with pkgs; [
    clooj
    leiningen
  ];

  nix = with pkgs; [
    colmena
    niv
    lorri
    nix-prefetch-scripts
    patchelf
  ];

  db = with pkgs; [
    postgresql
    sqlite-interactive
    sqsh
    unixODBC
    sqlitebrowser
  ];

  java = with pkgs; [
    openjdk
    gradle
    ant
  ];

  lsp = with pkgs; [
    yaml-language-server
    helm-ls
    lua-language-server
    nixd
    # nil
  ];

  useIf = x: y: if x then y else [];

  enabledPackages =
    base ++
    lsp ++
    useIf cfg.devel.android [ pkgs.android-studio ] ++
    useIf cfg.devel.cpp cpp ++
    useIf cfg.devel.node node ++
    useIf cfg.devel.rust rust ++
    useIf cfg.devel.haskell haskell ++
    useIf cfg.devel.python python ++
    useIf cfg.devel.go go ++
    useIf cfg.devel.clojure clojure ++
    useIf cfg.devel.nix nix ++
    useIf cfg.devel.java java ++
    useIf cfg.devel.db db;
in {
  options.dotfiles.packages = {
    devel = {
      enable = mkEnableOption "Enable development packages";
      android = mkEnableOption "Enable android studio";
      dotnet = mkEnableOption "Enable dotnet sdk";
      node = mkEnableOption "Enable Node.js";
      nix = mkEnableOption "Enable nix";
      cpp = mkEnableOption "Enable C++";
      rust = mkEnableOption "Enable Rust";
      haskell = mkEnableOption "Enable Haskell";
      python = mkEnableOption "Enable Python";
      go = mkEnableOption "Enable Go";
      clojure = mkEnableOption "Enable Clojure";
      java = mkEnableOption "Enable Java";
      db = mkEnableOption "Enable database cli tools";
    };
  };

  config = mkIf cfg.devel.enable (mkMerge [
    configuration
    (mkIf cfg.devel.dotnet dotnet)
  ]);
}
