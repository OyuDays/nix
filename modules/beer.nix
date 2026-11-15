{
    self,
    inputs,
    pkgs,
    ...
}: {
    hj = {
        packages = [
            (pkgs.callPackage "${inputs.beer}/nix/package.nix" { })
        ];
        xdg.config.files = {
            "beer/beer.toml" = {
                generator = (pkgs.formats.toml {}).generate "beer.toml";
                value = {
                    main = {
                        font = "monospace";
                        font-size = 16;
                        pad-x = 2;
                        pad-y = 2;
                    };
                    key-bindings = {
                        "Ctrl+Shfit+C" = "copy";
                        "Ctrl+Shfit+V" = "paste";
                        "Ctrl+Shfit+F" = "search";
                    };
                };
            };
        };
    };

    xdg.terminal-exec = {
        enable = true;
        settings.default = [
            "dev.notashelf.beer.desktop"
        ];
    };
}
