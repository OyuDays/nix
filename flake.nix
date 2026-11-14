{
    description = "My NixOS Flake";

    inputs = {
        nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
        quickshell = {
            url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hjem = {
            url = "github:feel-co/hjem";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hjem-impure = {
            url = "github:Rexcrazy804/hjem-impure";
            inputs.nixpkgs.follows = "";
            inputs.hjem.follows = "";
        };
    };

    outputs = { self, nixpkgs, ...}@inputs: {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
                ./hjem.nix
                ./configuration.nix
                ./user
            ];
        };
    };
}
