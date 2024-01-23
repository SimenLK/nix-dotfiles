{ pkgs, lib, ... }:
with lib;
let
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
