{
    inputs,
    pkgs,
    ...
}: {
    programs.hyprland = {
        enable = true;
        withUWSM = false;
        xwayland.enable = true;
    };
    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    };
    hj.packages = with pkgs; [
        xdg-desktop-portal-hyprland
        hyprpaper
        hypridle
        hyprlock
    ];
}
