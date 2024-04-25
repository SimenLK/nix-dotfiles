{
  allowUnfree = true;

  permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  packageOverrides = pkgs: with pkgs; {
    myTerraform = terraform.withPlugins (ps: with ps; [
      libvirt
    ]);
  };
}

