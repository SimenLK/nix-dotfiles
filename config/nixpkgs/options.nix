{
  desktop = {
    laptop = true;
    enable = true;
    dropbox = true;
  };
  dotnet = true;
  node = true;
  haskell = true;
  python = false;
  proton = false;
  languages = false;
  vimDevPlugins = true;
  eth = "wlp0s20f3";
  gitUser = {
    userEmail = "jonas.juselius@itpartner.no";
    userName = "Jonas Juselius";
    signing = {
      key = "jonas.juselius@gmail.com";
    };
  };
  sshHosts = {
    "k?-?" = {
      user = "admin";
      hostname = "%h.itpartner.no";
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
}

