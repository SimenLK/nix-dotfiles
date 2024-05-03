{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.packages;

  configuration = {
    nixpkgs.overlays = [
      (import ../overlays/linkerd.nix)
      # (import ../overlays/minio-client.nix)
      (import ../overlays/vcluster.nix)
      (import ../overlays/tilt.nix)
      # (import ../overlays/k9s.nix)
    ];

    home.packages = enabledPackages;
  };

  cloud = with pkgs; [
    awscli2
    minio-client
    vault-bin
    colmena
  ];

  geo = with pkgs; [
    netcdf
  ];

  kubernetes = with pkgs; [
    argocd
    cilium-cli
    cue
    cuelsp
    cuetools
    k9s
    krew
    kubectl
    kubernetes-helm
    kubeseal
    linkerd
    minikube
    step-cli # cert swiss army knife
    talosctl
    tilt
    timoni
    vcluster
    velero
  ];

  useIf = x: y: if x then y else [];

  enabledPackages =
    useIf cfg.cloud cloud ++
    useIf cfg.kubernetes kubernetes ++
    useIf cfg.geo geo;
in {
  options.dotfiles.packages = {
    cloud = mkEnableOption "Enable cloud cli tools";
    kubernetes = mkEnableOption "Enable Kuberntes cli tools";
    geo = mkEnableOption "Enable geo tools";
  };

  config = configuration;

}
