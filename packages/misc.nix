{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles.packages;

  configuration = {
    overlays = [
      (import ../overlays/k9s.nix)
    ];

    home.packages = enabledPackages;
  };

  cloud = with pkgs; [
    awscli2
    minio-client
    vault-bin
    colmena
    rclone
  ];

  geo = with pkgs; [ netcdf ];

  k8sPkgs = with pkgs; [
    argocd
    cilium-cli
    dive
    krew
    kubecolor
    kubectl
    kubernetes-helm
    kubeseal
    linkerd
    minikube
    nerdctl
    step-cli # cert swiss army knife
    talosctl
    tilt
    vcluster
    velero
  ];

  useIf = x: y: if x then y else [ ];

  enabledPackages = useIf cfg.cloud cloud ++ useIf cfg.kubernetes k8sPkgs ++ useIf cfg.geo geo;

  kubernetes = {
    programs = {
      k9s = {
        enable = true;
        package = k9s;
        settings = {
          k9s = {
            ui = {
              logoless = true;
            };
          };
        };
      };
    };
  };
in
{
  options.dotfiles.packages = with lib; {
    cloud = mkEnableOption "Enable cloud cli tools";
    kubernetes = mkEnableOption "Enable Kuberntes cli tools";
    geo = mkEnableOption "Enable geo tools";
  };

  config = lib.mkMerge [
    configuration
    (lib.mkIf cfg.kubernetes kubernetes)
  ];
}
