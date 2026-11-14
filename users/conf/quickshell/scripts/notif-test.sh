#!/usr/bin/env sh
RANDOM_IMAGE=$(find ~/Pictures -type f | shuf -n 1)
ACTION=$(notify-send "Test notification with body image" "This notification should contain your user account <b>image</b> and <a href=\"https://discord.com/app\">Discord</a> <b>icon</b>. Oh and here is a random image in your Pictures folder: <br/><img src=\"$RANDOM_IMAGE\" alt=\"Testing image\"/>" -a "Hyprland keybind" -p -h "string:image-path:/var/lib/AccountsService/icons/$USER" -t 6000 -i "discord" -A "openImage=Open profile image" -A "action2=Open the random image" -A "action3=Useless button")
[[ $ACTION == *openImage ]] && xdg-open "/var/lib/AccountsService/icons/$USER"
[[ $ACTION == *action2 ]] && xdg-open \"$RANDOM_IMAGE\"
