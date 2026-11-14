{
    self,
    config,
    pkgs,
    inputs,
    ...
}: let
    dots = "${./conf}";
in {
    # Define a user account. Don't forget to set a password with ‘passwd’.
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
                dotsDirImpure = "/etc/nixos/user/conf";
            };
            packages = with pkgs; [
                prismlauncher
                steam
                equibop
                foot
                spotify
                (wrapOBS {
                    plugins = with obs-studio-plugins; [];
                })
                obs-cmd
                mpv
            ];
            files = {
                ".gitconfig".source = dots + "/.gitconfig";
                ".config/quickshell".source = dots + "/quickshell";
                ".config/hypr".source = dots + "/hypr";
            };
        };
    };
}
