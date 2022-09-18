{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.packages;

  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  hie = all-hies.selection { selector = p: { inherit (p) ghc865; }; };

  configuration = {
    #nixpkgs.overlays = [ (import ../overlays/dotnet-sdk.nix) ];

    dotfiles.packages.devel = {
      nix = mkDefault true;
    };

    home.packages = enabledPackages;
  };

  base = with pkgs; [
    git
    binutils
    fzf
    gcc
    gdb
    gnumake
    cmake
    libxml2
    docker-compose
    gettext
    gnum4
    chromedriver # for selenium
    jq
    websocat
    meld
    automake
    autoconf
    libtool
    ripgrep
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

  dotnet = {
    home.sessionVariables = {
      DOTNET_ROOT = pkgs.dotnet-sdk_6;
    };
    home.packages = [
      pkgs.dotnet-sdk_6
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
    typescript
    typescript-language-server
  ];

  rust = with pkgs; [
    rustup
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
    niv
    lorri
    nix-prefetch-scripts
    patchelf
    rnix-lsp
  ];

  db = with pkgs; [
    postgresql
    sqlite-interactive
    sqlitebrowser
  ];

  java = with pkgs; [
    openjdk
    gradle
    ant
  ];

  useIf = x: y: if x then y else [];

  enabledPackages =
    base ++
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
      dotnet = mkEnableOption "Enable dotnet sdk";
      node = mkEnableOption "Enable Node.js";
      nix = mkEnableOption "Enable nix";
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
