#!/usr/bin/env bash

while getopts it flag
do
    case "${flag}" in
        i) ICON_FLAG=TRUE;;
        t) TEXT_FLAG=TRUE;;
    esac
done


if nc -zw1 8.8.8.8 443; then
    #SIGSTRENGTH=$(awk "NR==3{print\"\"substr(\$3,1,length(\$3)-1)}" /proc/net/wireless) #no longer works (/proc/net/wireless vanished)
    SIGSTRENGTH=$(nmcli -t -f IN-USE,SIGNAL device wifi list | awk -F: '$1=="*" {print $2}')

    if [[ $SIGSTRENGTH -gt 90 ]]; then
        ICON="nm-signal-100-symbolic"
    elif [[ $SIGSTRENGTH -gt 60 ]]; then
        ICON="nm-signal-75-symbolic"
    elif [[ $SIGSTRENGTH -gt 30 ]]; then
        ICON="nm-signal-50-symbolic"
    elif [[ $SIGSTRENGTH -gt 15 ]]; then
        ICON="nm-signal-25-symbolic"
    else
        ICON="nm-signal-00-symbolic"
    fi
else
    ICON="nm-no-connection-symbolic"
    SIGSTRENGTH="n/a"
fi


if [[ $ICON_FLAG == TRUE ]]; then
    printf "%s\n" $ICON
fi
if [[ $TEXT_FLAG == TRUE ]]; then
    printf "%s%%\n" $SIGSTRENGTH
fi
