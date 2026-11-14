{
    self,
    pkgs,
    inputs,
    ...
}: {
    imports = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
    ];

    services.flatpak = {
        enable = true;
        packages = [
            {
                appId = "org.vinegarhq.Sober";
                origin = "flathub";
            } # i'm sorry
        ];
    };
}
