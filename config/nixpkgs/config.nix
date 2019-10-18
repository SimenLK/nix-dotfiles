{
  allowUnfree = true;
  permittedInsecurePackages = [
    "mono-4.6.2.16"
  ];
  packageOverrides = pkgs: with pkgs; {
    myPython = python3.withPackages (ps: with ps; [
      numpy
      matplotlib
      tkinter
    ]);
    myTerraform = terraform.withPlugins (ps: with ps; [
      libvirt
    ]);
  };
}

