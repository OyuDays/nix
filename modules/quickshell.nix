{
    pkgs,
    inputs,
    ...
}: {
    hj.packages = [
        (inputs.quickshell.packages.${pkgs.system}.default.withModules [
            pkgs.kdePackages.kirigami
        ])
    ];
}
