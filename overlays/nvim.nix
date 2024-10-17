final: prev:
let
  neovim-latest = prev.neovim.overrideAttrs (attrs: rec {
    version = "0.10.2";
    name = "neovim-${version}";

    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "refs/tags/v${version}";
      hash = "sha256-+qjjelYMB3MyjaESfCaGoeBURUzSVh/50uxUqStxIfY=";
    };
  });
in
{
  neovim-latest = neovim-latest;
}
