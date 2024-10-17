{
  allowUnfree = true;

  permittedInsecurePackages = [
    "electron-25.9.0"
    "vault-bin-1.15.6"
  ];

  packageOverrides =
    pkgs: with pkgs; {
      myTerraform = terraform.withPlugins (ps: with ps; [ libvirt ]);
    };
}
