{
    description = "My NixOS Flake";

    outputs = {self}: let
        inputs = import ./.tack;
    in {
        nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
                ./configuration.nix
                ./modules
                ./users
            ];
        };
    };
}
