{
    inputs,
    pkgs,
    self,
    ...
}: {
    environment.systemPackages = with pkgs; [
        inputs.tack.packages.${pkgs.system}.default
    ];
}
