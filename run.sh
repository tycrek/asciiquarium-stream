#!/bin/bash

# Install fake monitor
echo "[1/3] Installing fake monitor"
Xvfb :1 -screen 0 1280x720x16 &
sleep 1

# Start asciiquarium
echo "[2/3] Starting asciiquarium in xterm"
DISPLAY=:1 xterm -geometry 212x55+0+0 -e /usr/games/asciiquarium &
sleep 1

# Start the stream
echo "[3/3] Streaming"
./stream.sh
