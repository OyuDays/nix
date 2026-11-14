#!/bin/bash
PROCESS=$(hyprctl activewindow |awk '/pid:/ {print $2}')

if ps -o state= -p $PROCESS | grep -q T ; then
    kill -CONT $PROCESS
else
    kill -STOP $PROCESS
fi
