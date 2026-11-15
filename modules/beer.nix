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
                    colors = {
                        foreground = "#dcdfe4";
                        background = "#282c34";
                        selection-foreground = "#000000";
                        selection-background = "#fffacd";
                        regular = [
                            "#282c34"
                            "#e06c75"
                            "#98c379"
                            "#e5c07b"
                            "#61afef"
                            "#c678dd"
                            "#56b6c2"
                            "#dcdfe4"
                        ];
                        bright = [
                            "#5d677a"
                            "#e06c75"
                            "#98c379"
                            "#e5c07b"
                            "#61afef"
                            "#c678dd"
                            "#56b6c2"
                            "#dcdfe4"
                        ];
                    };
                    cursor = {
                        style = "beam";
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
