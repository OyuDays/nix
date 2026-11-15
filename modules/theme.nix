# highly referenced from fazzi's config
{
    self,
    pkgs,
    lib,
    ...
}: {
    hj = {
        packages = with pkgs; [
            kdePackages.breeze
            kdePackages.breeze-gtk
            qt6Packages.qt6ct
            volantes-cursors
        ];
        xdg.config.files = {
            "qt6ct/qt6ct.conf" = {
                generator = lib.generators.toINI { };
                value = {
                    Appearance = {
                        icon_theme = "breeze-dark";
                        standard_dialogs = "xdgdesktopportal";
                        style = "breeze";
                    };
                    Fonts = {
                        fixed = ''"monospace,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
                        general = ''"sans-serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
                    };
                };
            };
        };
        xdg.data.files."icons/default/index.theme" = {
            generator = lib.generators.toINI { };
            value = {
                "Icon Theme".Inherits = "volantes_light_cursors"
            };
        };
    };

    environment.sessionVariables = {
        GTK_THEME = "breeze-dark:dark";
        QT_QPA_PLATFORMTHEME = "qt6ct";
        HYPRCURSOR_THEME = "volantes_light_cursors";
        HYPRCURSOR_SIZE = 24;
        XCURSOR_THEME = "volantes_light_cursors";
        XCURSOR_SIZE = 24;
        XCURSOR_PATH = [ "${pkgs.volantes-cursors}/share/icons" ]
    };

    programs.dconf.profiles.user.databases = [{
        lockAll = true;
        settings = {
            "org/gnome/desktop/interface" = {
                gtk-theme = "breeze-dark";
                icon-theme = "breeze-dark";
                cursor-theme = "volantes_light_cursors";
                cursor-size = gvariant.mkInt32 24;
                font-name = "Sans Regular 11";
                document-font-name = "Sans Regular 11";
                monospace-font-name = "Monospace Regular 12";
                color-scheme = "prefer-dark";

                gtk-enable-primary-paste = false; # no middle click paste
            };
        };
    }];

}
