{
    self,
    pkgs,
    ...
}: {
    fonts = {
        packages = with pkgs; [
            nerd-fonts.hack
            noto-fonts

            corefonts # microsoft windows
            vista-fonts # some more microsoft windows
        ];
    };
    fontconfig = {
        defaultFonts = {
            sansSerif = [
                "Noto Sans"
            ];
            serif = [
                "Noto Serif"
            ];
            monospace = [
                "Hack"
            ];
            emoji = [
                "Noto Color Emoji"
            ];
        };
    };
}
