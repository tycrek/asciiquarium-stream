#!/bin/bash

# Change INRES and OUTRES values to match your config from above
INRES="1280x720" # Input resolution
OUTRES="1280x720" # Output resolution

# Target FPS
FPS="15" # target FPS

# i-frame interval, should be double of FPS
GOP="30"

# Minimum i-frame interval, should be equal to fps
GOPMIN="15"

# Max is 6
THREADS="2"

# Constant bitrate. should be between 1000k - 3000k
CBR="1000k"

# One of the many FFMPEG presets
QUALITY="ultrafast"

# Audio rate. Only change if you know what you're doing
AUDIO_RATE="44100"

# Select a Twitch server to stream to. See this link for info:
# https://stream.twitch.tv/ingests/
SERVER="live-sea"

# Stream with ffmpeg
# Make sure -i :1 mathces your config
# Best to leave this as is unless you know what you are doing
ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :1 -f alsa -i pulse -f flv -ac 2 -ar $AUDIO_RATE \
-vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
-s $OUTRES -preset $QUALITY -tune film -acodec libmp3lame -threads $THREADS -strict normal \
-bufsize $CBR "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"
