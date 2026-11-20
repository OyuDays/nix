{
    self,
    config,
    pkgs,
    inputs,
    lib,
    ...
}: let
    dots = "${./conf}";
in {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    imports = [
        (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" "oyu" ])
    ];

    users.users."oyu" = {
        isNormalUser = true;
        description = "cat w. computer";
        extraGroups = [ "networkmanager" "wheel" ];
    };

    hjem = {
        clobberByDefault = true;
        users.oyu = {
            user = "oyu";
            directory = "/home/oyu";
            impure = {
                enable = true;
                dotsDir = dots;
                dotsDirImpure = "/etc/nixos/users/conf";
            };
            packages = with pkgs; [
                prismlauncher
                steam
                equibop
                spotify
                (wrapOBS {
                    plugins = with obs-studio-plugins; [];
                })
                obs-cmd
                mpv
                nicotine-plus
                gimp
                krita
                kdePackages.kolourpaint
                ripgrep
                bat
                picard
                (callPackage ./scripts/organize-music.nix {})
                slurp
                grim
                grimblast
                rofi
                wl-clipboard
                wayfreeze
                btop
                alejandra
                restic
                kdePackages.kdenlive
                (python3.withPackages (python-pkgs: with python-pkgs; [
                    psutil
                ]))
            ];
            files = {
                ".gitconfig".source = dots + "/.gitconfig";
                ".config/quickshell".source = dots + "/quickshell";
                ".config/hypr".source = dots + "/hypr";
            };
        };
    };
}
