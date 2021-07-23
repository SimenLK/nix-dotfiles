self: super:
let
in
{
  kind = super.kind.overrideAttrs (attrs: rec {
    version = "v0.11.1";
    src = super.fetchurl {
      url = "https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64";
      sha256 = "0kpcd9q6v2qh0dzddykisdbi3djbxj2rl70wchlzrb6bx95hkzmc";
    };
  });
}
