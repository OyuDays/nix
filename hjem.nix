{inputs, ...}: {
    imports = [ inputs.hjem.nixosModules.default ];

    hjem.extraModules = [ inputs.hjem-impure.hjemModules.default ];
}
