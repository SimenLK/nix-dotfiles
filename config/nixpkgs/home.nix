{pkgs, ...}:
with pkgs.lib;
let
  options = {
    desktop = {
      enable = true;
      dropbox = false;
    };
    dotnet = true;
    node = true;
    haskell = true;
    python = false;
    proton = false;
    languages = false;
  };

  gitUser = {
    userEmail = "jonas.juselius@itpartner.no";
    userName = "Jonas Juselius";
    signing = {
      key = "jonas.juselius@gmail.com";
    };
  };

  privateFiles = if ! options.desktop.enable then {} else {
    ssh = {
      source = ~/.dotfiles/ssh;
      target = ".ssh";
      recursive = true;
    };
    gnupg = {
      source = ~/.dotfiles/gnupg;
      target = ".gnupg";
      recursive = true;
    };
  };

  sshConfig = {
    compression = false;
    forwardAgent = true;
    serverAliveInterval = 30;
    extraConfig = "IPQoS throughput";
    matchBlocks = {
      "k?-?" = {
        user = "admin";
        hostname = "%h.itpartner.no";
      };
      "k0-0" = {
        user = "itpartner";
        hostname = "k0-0.itpartner.no";
      };
      xor = {
        hostname = "xor.itpartner.no";
        port = 11022;
      };
      xor-intern = {
        hostname = "xor.itpartner.no";
        port = 22;
      };
      regnekraft = {
        user = "jonas";
        hostname = "regnekraft.itpartner.no";
      };
      regnekraft-adm = {
        user = "root";
        hostname = "regnekraft.itpartner.no";
      };
      stallo = {
        hostname = "stallo.uit.no";
        serverAliveInterval = 10;
      };
      stallo-2 = {
        hostname = "stallo-login2.uit.no";
      };
      stallo-1 = {
        hostname = "stallo-login1.uit.no";
      };
      radon = {
        hostname = "radon.chem.helsinki.fi";
      };
      hep-web01 = {
        user = "hepadmin";
        hostname = "10.208.0.130";
      };
        # lambda-by-proxy = {
        #     proxyCommand = "ssh -q jju000@hss.cc.uit.no nc lambda.cc.uit.no 22";
        # };
        # "c*-*" = {
        #     proxyCommand = "ssh -W %h:%p stallo";
        # };
        # stallo-forward = {
        #    hostname = "ssh2.cc.uit.no";
        #    user = "jju000";
        #    extraOptions = {
        #     "PermitLocalCommand" = "yes";
        #     "LocalCommand" =  "ssh stallo.uit.no";
        #    };
        # };

      };
    };

  extraDotfiles = [
    "aliases"
    "bcrc"
    "codex"
    "ghci"
    "haskeline"
    "taskrc"
  ];
in
{
  require = [
    (if options.desktop.enable then
      import ./desktop.nix { inherit pkgs options; }
     else {}
    )
  ];

  nixpkgs.overlays = [
    (import ./overlays/dotnet-sdk.nix)
    (import ./overlays/vscode.nix)
    (import ./overlays/wavebox.nix)
  ];

  home.file = {
    local-bin = {
      source = ~/.dotfiles/local/bin;
      target = ".local/bin";
      recursive = true;
    };
  }
  // privateFiles
  // builtins.foldl' (a: x:
    let
      mkHomeFile = x: {
        ${x} = {
          source = ~/. + "/.dotfiles/${x}";
          target = ".${x}";
        };
      };
    in
      a // mkHomeFile x) {} extraDotfiles;

  home.packages = import ./packages.nix { inherit pkgs options; };

  home.keyboard = {
    layout = "us(altgr-intl)";
    model = "pc104";
    options = [ "eurosign:e" "caps:none" ];
  };

  home.sessionVariables = {};

  programs = {
    htop.enable = true;
    man.enable = true;
    lesspipe.enable = true;

    neovim =
      let
        vimPlugins = pkgs.vimPlugins // {
          vim-gnupg = pkgs.vimUtils.buildVimPlugin {
            name = "vim-gnupg";
            src = ~/.dotfiles/vim-plugins/vim-gnupg;
          };
          vim-ionide = pkgs.vimUtils.buildVimPlugin {
            name = "vim-ionide";
            src = ~/.dotfiles/vim-plugins/vim_fsharp_languageclient;
          };
          jonas = pkgs.vimUtils.buildVimPlugin {
            name = "jonas";
            src = ~/.dotfiles/vim-plugins/jonas;
          };
        };
      in
      {
        enable = true;
        plugins = with vimPlugins; [
          jonas
          LanguageClient-neovim
          ctrlp
          idris-vim
          neco-ghc
          neocomplete
          nerdcommenter
          nerdtree
          purescript-vim
          supertab
          syntastic
          tabular
          tlib_vim
          vim-addon-mw-utils
          vim-airline
          vim-airline-themes
          NeoSolarized
          vim-commentary
          vim-fish
          vim-markdown
          vim-nix
          vimproc
          vim-sensible
          vim-snipmate
          vim-surround
          vim-unimpaired
          vim-gnupg
          vim-ionide
        ];
        extraConfig = builtins.readFile ../../vimrc;
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
      };
      ignores = ["*~" "*.o" "*.a" "*.dll" "*.bak" "*.old"];
      extraConfig = {
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
          editor = "vim";
        };
        help = {
          autocorrect = 1;
        };
        http = {
          sslVerify = false;
        };
      };
    } // gitUser;

    ssh = {
      enable = true;
    } // sshConfig;

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 10;
      terminal = "tmux-256color";
      extraConfig = ''
        # start windows and panes at 1
        setw -g pane-base-index 1
        set -ga terminal-overrides ",xterm-termite:Tc"
      '';
    };

    home-manager = {
      enable = true;
      path = "https://github.com/rycee/home-manager/archive/master.tar.gz";
    };
  };

  systemd.user.startServices = true;
  systemd.user.sessionVariables = {
    GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
    GIT_ALLOW_PROTOCOL = "keybase:ssh:https";
  };


  nixpkgs.config = {
    allowUnfree = true;
  };

  xdg.configFile = {
    fish = {
      source = ~/.dotfiles/config/fish;
      target = "fish";
      recursive = true;
    };
    nixpkgs = {
      source = ~/.dotfiles/config/nixpkgs/overlays;
      target = "nixpkgs/overlays";
      recursive = true;
    };
  };

  xdg.dataFile = {
    omf = {
      source = ~/.dotfiles/local/share/omf;
      target = "omf";
    };
  };
}
