{
  allowUnfree = true;

  permittedInsecurePackages = [
  ];

  packageOverrides = pkgs: with pkgs; {
    myTerraform = terraform.withPlugins (ps: with ps; [
      libvirt
    ]);
  };
}

