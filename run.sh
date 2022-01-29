#!/bin/bash

export DISPLAY=:1
Xvfb :1 -screen 0 1280x720x16 &
sleep 1

# Start the stream in a screen session
screen -dmS asciiquarium -s bash "./stream.sh"

# Start asciiquarium
DISPLAY=:1 xterm -geometry 212x55+0+0 -e asciiquarium &
