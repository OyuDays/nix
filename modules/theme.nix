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
            kdePackages.breeze-icons
            qtengine
            volantes-cursors
        ];
        xdg.config.files = {
            "qtengine/config.json" = {
                generator = lib.generators.toJSON { };
                value = {
                    theme = {
                        colorScheme = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
                        iconTheme = "breeze-dark";
                        style = "breeze";

                        font = {
                            family = "Sans Serif";
                            size = 11;
                            weight = -1;
                        };

                        fontFixed = {
                            family = "Monospace";
                            size = 11;
                            weight = -1;
                        };
                    };
                    misc = {
                        singleClickActivate = false;
                        menusHaveIcons = true;
                        shortcutsForContextMenus = true;
                    };
                };
            };
        };
        xdg.data.files."icons/default/index.theme" = {
            generator = lib.generators.toINI { };
            value = {
                "Icon Theme".Inherits = "volantes_light_cursors";
            };
        };
    };

    environment.sessionVariables = {
        GTK_THEME = "Breeze-Dark";
        QT_QPA_PLATFORMTHEME = "qtengine";
        HYPRCURSOR_THEME = "volantes_light_cursors";
        HYPRCURSOR_SIZE = 24;
        XCURSOR_THEME = "volantes_light_cursors";
        XCURSOR_SIZE = 24;
        XCURSOR_PATH = [ "${pkgs.volantes-cursors}/share/icons" ];
    };

    programs.dconf = {
        enable = true;
        profiles.user.databases = [{
            lockAll = true;
            settings = {
                "org/gnome/desktop/interface" = {
                    gtk-theme = "Breeze-Dark";
                    icon-theme = "breeze-dark";
                    color-scheme = "prefer-dark";
                    cursor-theme = "volantes_light_cursors";
                    cursor-size = lib.gvariant.mkInt32 24;
                    font-name = "Sans Regular 11";
                    document-font-name = "Sans Regular 11";
                    monospace-font-name = "Monospace Regular 12";

                    gtk-enable-primary-paste = false; # no middle click paste
                };
            };
        }];
    };

}
