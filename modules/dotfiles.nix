{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles;

  fromGithub =
    ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = "refs/tags/${ref}";
      };
    };

  configuration = {
    nixpkgs.overlays = [
      (import ../overlays/nvim.nix)
    ];

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
          kc = "kubectl";
          k = "kubectl";
          tw = "timew";
          vim = "nvim";
          home-manager = "home-manager -f ~/.dotfiles/home.nix";
          lock = "xset s activate";
          cpwd = "pwd | xclip -i";
          cdc = "cd (xclip -o)";
          gl = "glab";
        };
      };

      neovim =
        let
          obsidian-nvim = fromGithub "v3.9.0" "epwalsh/obsidian.nvim";
          render-markdown-nvim = fromGithub "v7.5.0" "MeanderingProgrammer/render-markdown.nvim";

          my-treesitter =
            let
              fsharp-grammar =
                let
                  drv = pkgs.tree-sitter.buildGrammar {
                    language = "fsharp";
                    version = "0.1.0-alpha.1";
                    location = "fsharp";
                    src = /home/simkir/code/tree-sitter-fsharp;
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
            in
            pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
              # NOTE: Recommended to be in "ensure_installed"
              p.c
              p.lua
              p.vim
              p.vimdoc
              p.query

              fsharp-grammar
              p.bash
              p.bibtex
              p.c_sharp
              p.cue
              p.cpp
              p.css
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
              p.yaml
              p.zig
            ]);
        in
        {
          enable = true;
          # package = pkgs.neovim-nightly;
          plugins = with pkgs.vimPlugins; [
            fugitive
            plenary-nvim
            telescope-nvim
            my-treesitter
            nvim-treesitter-context
            zephyr-nvim
            tokyonight-nvim

            nvim-lspconfig
            lsp-zero-nvim

            nvim-cmp
            cmp-buffer
            cmp-path
            cmp_luasnip
            cmp-nvim-lsp
            cmp-nvim-lua

            luasnip
            friendly-snippets

            vim-surround

            render-markdown-nvim
            nvim-dap
            tmux-navigator
            vim-gnupg
            vim-nix
            vim-vsnip
            vimtex

            obsidian-nvim
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
          init = {
            defaultBranch = "main";
          };
          merge = {
            tool = "meld";
          };
          color = {
            branch = "auto";
            diff = "auto";
            status = "auto";
          };
          push = {
            # matching, tracking or current
            default = "current";
          };
          pull = {
            rebase = false;
          };
          core = {
            editor = "nvim";
          };
          help = {
            autocorrect = 1;
          };
          http = {
            sslVerify = false;
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

          # Vim mode controls⋅
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
        path = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
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
