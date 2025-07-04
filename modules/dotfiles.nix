{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles;

  fromGithubBranch =
    rev: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = rev;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        rev = rev;
      };
    };

  configuration = {
    manual.manpages.enable = true;

    programs = {
      htop.enable = true;
      man.enable = true;
      lesspipe.enable = false;
      dircolors.enable = true;

      fish = {
        enable = true;
        shellInit = ''
          set -e TMUX_TMPDIR
          set PATH ~/.local/bin $HOME/.nix-profile/bin ~/.dotnet/tools ~/.krew/bin $PATH
        '';
        shellAbbrs = {
          gfa = "git fetch --all";
          kgp = "kubectl get pods";
          kcd = "kubectl config set-context --current --namespace";
        };
        shellAliases = {
          rm = "rm -i";
          mv = "mv -i";
          cp = "cp -i";
          ll = "ls -lh";
          la = "ls -a";
          lla = "ls -la";
          ltr = "ls -lht";
          # ltr = "ls -ltr";
          # cat = "bat -p";
          diff = "diff -u";
          vimdiff = "nvim -d";
          pssh = "parallel-ssh -t 0";
          xopen = "xdg-open";
          lmod = "module";
          unhist = "unset HISTFILE";
          nix-zsh = ''nix-shell --command "exec zsh"'';
          nix-fish = ''nix-shell --command "exec fish"'';
          halt = "halt -p";
          kc = "kubecolor";
          k = "kubectl";
          tw = "timew";
          vim = "nvim";
          home-manager = "home-manager -f ~/.dotfiles/home.nix";
          lock = "xset s activate";
          cpwd = "pwd | xclip -i";
          cdc = "cd (xclip -o)";
          gl = "glab";
          os = "openstack";
        };
      };

      neovim =
        let
          fsharp-grammar =
            let
              drv = pkgs.tree-sitter.buildGrammar {
                language = "fsharp";
                version = "0.1.0-alpha.4";
                location = "fsharp";
                src = pkgs.fetchFromGitHub {
                  owner = "ionide";
                  repo = "tree-sitter-fsharp";
                  rev = "971da5ff0266bfe4a6ecfb94616548032d6d1ba0";
                  hash = "sha256-0jrbznAXcjXrbJ5jnxWMzPKxRopxKCtoQXGl80R1M0M=";
                };
                meta.homepage = "https://github.com/ionide/tree-sitter-fsharp";
              };
            in
            drv.overrideAttrs (attrs: {
              installPhase = ''
                runHook preInstall
                mkdir $out
                mv parser $out/
                if [[ -d ../queries ]]; then
                  cp -r ../queries $out
                fi
                runHook postInstall
              '';
            });

          helm-ls-nvim = fromGithubBranch "648509594281eed48e58bb690744b082c1eeb741" "qvalentin/helm-ls.nvim";

          my-treesitter =
            pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
              # NOTE: Recommended to be in "ensure_installed"
              p.c
              p.lua
              p.vim
              p.vimdoc
              p.query

              p.bash
              p.bibtex
              p.c_sharp
              p.cpp
              p.css
              p.cue
              p.dhall
              p.dockerfile
              p.fish
              p.git_rebase
              p.gitattributes
              p.gitignore
              p.glsl
              p.go
              p.html
              p.javascript
              p.latex
              p.markdown
              p.markdown_inline
              p.nix
              p.python
              p.rust
              p.sql
              p.typescript
              p.typst
              p.yaml
              p.zig
            ]);
        in
        {
          enable = true;
          # package = pkgs.neovim-nightly;
          plugins = with pkgs; [
            # Essentials
            vimPlugins.fugitive
            vimPlugins.vim-surround
            vimPlugins.tmux-navigator

            vimPlugins.plenary-nvim
            vimPlugins.telescope-nvim

            my-treesitter
            (pkgs.neovimUtils.grammarToPlugin fsharp-grammar)

            vimPlugins.nvim-treesitter-context

            # colorschemes
            vimPlugins.zephyr-nvim
            vimPlugins.tokyonight-nvim

            vimPlugins.nvim-lspconfig
            vimPlugins.lsp-zero-nvim

            vimPlugins.nvim-cmp
            vimPlugins.cmp-buffer
            vimPlugins.cmp-path
            vimPlugins.cmp-cmdline
            vimPlugins.cmp_luasnip
            vimPlugins.cmp-nvim-lsp
            vimPlugins.cmp-nvim-lua

            vimPlugins.luasnip
            vimPlugins.friendly-snippets

            vimPlugins.indent-blankline-nvim
            vimPlugins.markdown-preview-nvim
            vimPlugins.nvim-colorizer-lua
            vimPlugins.vim-gnupg
            vimPlugins.vim-nix
            vimPlugins.vim-vsnip
            vimPlugins.vimtex

            helm-ls-nvim
          ];
        };

      git = {
        enable = true;
        aliases = {
          ll = "log --stat --abbrev-commit --decorate";
          history = "log --graph --abbrev-commit --decorate --all";
          co = "checkout";
          ci = "commit";
          st = "status";
          unstage = "reset HEAD";
          pick = "cherry-pick";
          ltr = "branch --sort=-committerdate";
        };
        ignores = [
          "*~"
          "*.o"
          "*.a"
          "*.dll"
          "*.bak"
          "*.old"
        ];
        extraConfig = {
          branch = {
            sort = "-committerdate";
          };
          commit = {
            verbose = true;
          };
          color = {
            branch = "auto";
            diff = "auto";
            status = "auto";
          };
          column = {
            ui = "auto";
          };
          core = {
            editor = "nvim";
          };
          diff = {
            algorithm = "histogram";
            colorMoved = "plain";
            mnemonicPrefix = true;
            renames = true;
          };
          fetch = {
            prune = true;
            pruneTags = true;
            all = true;
          };
          help = {
            autocorrect = "prompt";
          };
          http = {
            sslVerify = false;
          };
          init = {
            defaultBranch = "main";
          };
          merge = {
            tool = "meld";
            conflictStyle = "zdiff3";
          };
          push = {
            # matching, tracking or current
            default = "simple";
            autoSetupRemote = true;
            followTags = true;
          };
          pull = {
            rebase = false;
          };
          rebase = {
            updateRefs = true;
          };
          tag = {
            sort = "version:refname";
          };
          safe = {
            directory = "/etc/nixos";
          };
        };
      };

      ssh = {
        enable = true;
        compression = false;
        forwardAgent = true;
        serverAliveInterval = 30;
        extraConfig = ''
          IPQoS throughput
          UpdateHostKeys no
        '';
      };

      tmux = {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        disableConfirmationPrompt = true;
        escapeTime = 10;
        prefix = "C-Space";
        terminal = "tmux-256color";
        extraConfig = ''
          set-option -g default-shell ${pkgs.fish}/bin/fish

          # Colors
          set -g default-terminal "tmux-256color"
          set-option -sa terminal-overrides ",alacritty:RGB"
          set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
          set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
          set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

          # Vim mode controls
          setw -g mode-keys vi

          # split panes using | and -
          bind | split-window -h
          bind - split-window -v
          unbind '"'
          unbind %
        '';
        plugins = with pkgs; [
          (tmuxPlugins.mkTmuxPlugin {
            pluginName = "statusline";
            version = "1.0";
            src = ../plugins/tmux-plugins;
          })
          (tmuxPlugins.mkTmuxPlugin {
            pluginName = "simple-git-status";
            version = "master";
            src = fetchFromGitHub {
              owner = "kristijanhusak";
              repo = "tmux-simple-git-status";
              rev = "287da42f47d7204618b62f2c4f8bd60b36d5c7ed";
              sha256 = "04vs4afxcr118p78mw25nnzvlms7pmgmi2a80h92vw5pzw9a0msq";
            };
          })
          (tmuxPlugins.mkTmuxPlugin {
            pluginName = "current-pane-hostname";
            version = "master";
            src = fetchFromGitHub {
              owner = "soyuka";
              repo = "tmux-current-pane-hostname";
              rev = "6bb3c95250f8120d8b072f46a807d2678ecbc97c";
              sha256 = "1w1x8w351v9yppw37kcs985mm5ikpmdnckfjwqyhlqx90lf9sqdy";
            };
          })
          tmuxPlugins.vim-tmux-navigator
        ];
      };

      home-manager = {
        enable = true;
      };
    };

    home.keyboard = {
      layout = "us,us";
      variant = "altgr-intl,colemak";
      model = "pc104";
      options = [
        "eurosign:e"
        "grp:alt_shift_toggle"
      ];
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      KUBE_EDITOR = "nvim";
      LESS = "-MiScR";
      GIT_ALLOW_PROTOCOL = "ssh:https:keybase:file";
      LD_LIBRARY_PATH = "$HOME/.nix-profile/lib";
    };

    systemd.user.startServices = true;

    systemd.user.sessionVariables = {
      GIT_ALLOW_PROTOCOL = "ssh:https:keybase:file";
    };

    nixpkgs.config = {
      allowUnfree = true;
    };

    home.activation = {
      linkOverlays = "cp -srf ~/.dotfiles/overlays ~/.config/nixpkgs";
    };

    xdg.configFile = {
      fish = {
        source = /home/simkir/.dotfiles/config/fish;
        target = "fish";
        recursive = true;
      };

      mutt = {
        source = "/home/simkir/.dotfiles/config/mutt";
        target = "mutt";
        recursive = true;
      };

      nvim = {
        source = "/home/simkir/.dotfiles/config/nvim";
        target = "nvim";
        recursive = true;
      };

      hypr = {
        source = "/home/simkir/.dotfiles/config/hypr";
        target = "hypr";
        recursive = true;
      };

      "home.nix" = {
        source = /home/simkir/.dotfiles/home.nix;
        target = "nixpkgs/home.nix";
      };

      "config.nix" = {
        source = /home/simkir/.dotfiles/config.nix;
        target = "nixpkgs/config.nix";
      };

      modules = {
        source = "/home/simkir/.dotfiles/modules";
        target = "nixpkgs/modules";
        recursive = true;
      };

      packages = {
        source = "/home/simkir/.dotfiles/packages";
        target = "nixpkgs/packages";
        recursive = true;
      };
    };

    xdg.dataFile = {
      omf = {
        source = "${pkgs.oh-my-fish}/share/oh-my-fish";
        target = "omf";
        recursive = true;
      };
    };

    services = {
      unison = {
        enable = false;
        pairs = {
          docs = [
            "/home/$USER/Documents"
            "ssh://example/Documents"
          ];
        };
      };
    };
  };

  extraHomeFiles = {
    home.file =
      {
        local-bin = {
          source = /home/simkir/.dotfiles/local/bin;
          target = ".local/bin";
          recursive = true;
        };
      }
      // builtins.foldl' (
        a: x:
        let
          mkHomeFile = x: {
            ${x} = {
              source = "/home/simkir/.dotfiles/adhoc/${x}";
              target = ".${x}";
            };
          };
        in
        a // mkHomeFile x
      ) { } cfg.extraDotfiles;
  };
in
{
  options.dotfiles = {
    extraDotfiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    plainNix = lib.mkEnableOption "Tweaks for non-NixOS systems";
  };

  config = lib.mkMerge [
    configuration
    extraHomeFiles
  ];
}
