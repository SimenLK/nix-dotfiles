self: super:
let
  kind = { buildGoModule, fetchFromGitHub }:

  buildGoModule rec {
    pname = "kind";
    version = "v0.11.1";

    src = fetchFromGitHub {
      rev = "${version}";
      owner = "kubernetes-sigs";
      repo = "kind";
      sha256 = "1k6m4xwkrjgq7rjpj2zy5kw1wn0jz8q0f3m1sdqa6y3cwgc3jf56";
    };

    vendorSha256 = "08cjvhk587f3aar4drn0hq9q1zlsnl4p7by4j38jzb4r8ix5s98y";

    subPackages = [ "." ];
  };
in {
  kind = kind {
    buildGoModule = super.buildGoModule;
    fetchFromGitHub = super.fetchFromGitHub;
  };
}
