{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.packages;

  configuration = {
    home.packages = enabledPackages;
  };

  sys = with pkgs; [
    bind
    dmidecode
    dpkg
    ethtool
    fuse
    iftop
    inetutils
    lshw
    nmap
    openldap
    openssl
    parted
    pciutils
    pwgen
    sshfs-fuse
    unrar
    usbutils
    utillinux
  ];

  user = with pkgs; [
    bat
    bottom
    direnv
    du-dust
    duf
    exa
    fd
    gnupg
    neomutt
    openfortivpn
    pandoc
    pass
    procs
    ripgrep
    sd
    sshuttle
    tomb
    zellij
    neomutt
    openfortivpn
  ];

  enabledPackages =
    sys ++
    user;
in {
  options.dotfiles.packages = {};

  config = configuration;
}
