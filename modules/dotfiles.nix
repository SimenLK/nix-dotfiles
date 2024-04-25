{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.dotfiles;

  fromGithub = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationname repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
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
          vimPlugins = pkgs.vimPlugins // {
            vim-gnupg = pkgs.vimUtils.buildVimPlugin {
              name = "vim-gnupg";
              src = ~/.dotfiles/plugins/vim-plugins/vim-gnupg;
            };
          };
          # local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
          # parser_config.fsharp = {
          #   install_info = {
          #     url = "https://github.com/Nsidorenco/tree-sitter-fsharp",
          #     branch = "develop",
          #     files = {"src/scanner.cc", "src/parser.c" },
          #     generate_requires_npm = true,
          #     requires_generate_from_grammar = true
          #   },
          #   filetype = "fsharp",
          # }

          fsharp-grammar = pkgs.tree-sitter.buildGrammar {
            language = "fsharp";
            version = "0.0.0+rev=a4d418e";
            src = pkgs.fetchFromGitHub {
              owner = "Nsidorenco";
              repo = "tree-sitter-fsharp";
              rev = "a4d418e426c555e85e32e638c0333fe3e555aeea";
              hash = "sha256-bMBIz8rQ4X21jtH6nvAgc8Wtr7PkZ5HyfGDossJqN5U=";
            };
            generate = false;
            meta.homepage = "https://github.com/Nsidorenco/tree-sitter-fsharp";
          };

          treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
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
          plugins = with vimPlugins; [
            fugitive
            plenary-nvim
            telescope-nvim
            treesitter
            nvim-treesitter-context
            playground
            zephyr-nvim

            nvim-lspconfig
            lsp-zero-nvim

            Ionide-vim

            nvim-cmp
            cmp-buffer
            cmp-path
            cmp_luasnip
            cmp-nvim-lsp
            cmp-nvim-lua

            luasnip
            friendly-snippets

            vim-surround

            markdown-preview-nvim
            nvim-dap
            tmux-navigator
            vim-gnupg
            vim-nix
            vim-vsnip
            vimtex
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
        ignores = ["*~" "*.o" "*.a" "*.dll" "*.bak" "*.old"];
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
        path = "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
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
        source = ~/.dotfiles/config/fish;
        target = "fish";
        recursive = true;
      };
      mutt = {
        source = ~/.dotfiles/config/mutt;
        target = "mutt";
        recursive = true;
      };
      nvim = {
        source = ~/.dotfiles/config/nvim;
        target = "nvim";
        recursive = true;
      };
      "home.nix" = {
        source = ~/.dotfiles/home.nix;
        target = "nixpkgs/home.nix";
      };
      "config.nix" = {
        source = ~/.dotfiles/config.nix;
        target = "nixpkgs/config.nix";
      };
      modules = {
        source = ~/.dotfiles/modules;
        target = "nixpkgs/modules";
        recursive = true;
      };
      packages = {
        source = ~/.dotfiles/packages;
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
      lorri.enable = true;

      unison = {
        enable = false;
        pairs = {
          docs = [ "/home/$USER/Documents"  "ssh://example/Documents" ];
        };
      };
    };
  };

  extraHomeFiles = {
    home.file = {
      local-bin = {
        source = ~/.dotfiles/local/bin;
        target = ".local/bin";
        recursive = true;
      };
    } // builtins.foldl' (a: x:
      let
        mkHomeFile = x: {
          ${x} = {
            source = ~/. + "/.dotfiles/adhoc/${x}";
            target = ".${x}";
          };
        };
      in
        a // mkHomeFile x) {} cfg.extraDotfiles;
  };

  vimDevPlugins =
    let
      devPlugins = with pkgs.vimPlugins; [ ];
    in { programs.neovim.plugins = devPlugins; };

  # settings when not running under NixOS
  plainNix = {
    home.sessionVariables = {
      NIX_PATH = "$HOME/.nix-defexpr/channels/:$NIX_PATH";
    };

    services = {
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        defaultCacheTtl = 43200; # 12 hours
        defaultCacheTtlSsh = 64800; # 18 hours
        maxCacheTtl = 64800;
        maxCacheTtlSsh = 64800;
        pinentryFlavor = "curses";
      };
    };
  };
in
{
  options.dotfiles = {
    extraDotfiles = mkOption {
      type = types.listOf types.str;
      default = [];
    };

    vimDevPlugins = mkEnableOption "Enable vim devel plugins";

    plainNix = mkEnableOption "Tweaks for non-NixOS systems";
  };

  config = mkMerge [
    configuration
    extraHomeFiles
    (mkIf cfg.vimDevPlugins vimDevPlugins)
  ];
}
