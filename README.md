# asciiquarium-stream
Files and guide on streaming asciiquarium to Twitch

[**Watch stream on Twitch**](https://twitch.tv/asciiquarium) or ~~[**see how it works**][reddit thread]~~ see below.

This guide has been adapted from the original [reddit thread].

---

[reddit thread]: https://old.reddit.com/r/commandline/comments/gtlzxt/im_streaming_asciiquarium_on_twitch_247_hopefully/fsk7sq3/

# How does it work

## Requirements

- Headless server with root access
  - Preferably Ubuntu 18.04 as this is what I originally tested with
- Command line experience
- Twitch account
- A monitor is **not** required for setup or streaming. Part of this project was seeing if I could stream without a physical display.

## Procedure

1. Install requirements
   ```bash
   sudo add-apt-repository ppa:ytvwld/asciiquarium
   sudo apt update
   sudo apt install lightdm xterm xvfb screen asciiquarium

   # Also install ffmpeg in the preferred method for your distro
   # Ubuntu 18.04:
   sudo snap install ffmpeg
   ```
2. Set up a virtual display by putting the following in your `xorg.conf` (usually found in `/usr/share/X11/xorg.conf.d/`. Create it if needed):
   ```conf
   Section "Monitor"
     Identifier   "Monitor0"
     HorizSync    31-81
     VertRefresh  56-75
   EndSection

   Section "Device"
     Identifier  "Card0"
     Driver      "nvidia"
   EndSection

   Section "Screen"
     Identifier "Screen0"
     Device     "Card0"
     Monitor    "Monitor0"
   EndSection
   ```
   If necessary, change driver to `vesa` (or whatever graphics drivers you are using).
3. Reboot
4. Create a file called `virtual-display.sh` and add the following to it:
   ```bash
   #!/bin/sh

   # Change the number if desired
   # 1 is typically safe unless you have more than 1 physical monitor
   export DISPLAY=:1

   # Make sure :1 matches the previous line.
   # The dimensions and colour depth can also be changed, if desired.
   Xvfb :1 -screen 0 1280x720x16 &

   # Just to be safe
   sleep 1
   ```
5. Make it executable with `$ chmod +x virtual-display.sh`
6. Place the following at the end of `.bashrc`:
   ```bash
   streaming() {
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
       
       # Stream key will be passed at the command line
       STREAM_KEY="$1"
       
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
   }
   ```
   Read the comments for guidance on what can be modified.
7. Place your Twitch key in `.twitch_key`. Your key can be found at `https://dashboard.twitch.tv/u/YOUR_USER_NAME_HERE/settings/channel#stream-preferences`. **Keep your key private!!**
8. Run the following commands to start streaming:
   ```bash
   source .bashrc
   ./virtual-display.sh
   screen -S twitch_stream
   streaming $(cat .twitch_key)

   # There will be some warnings that fly through the console. Don't worry about these.
   ```
8. Press `CTRL+A` followed by `CTRL+D` to disconnect from `screen`.
9. Start `asciiquarium` with the following command:
   ```bash
   DISPLAY=:1 xterm -geometry 212x55+0+0 -e asciiquarium &
   ```
   - `DISPLAY=:1` - Sets the preferred video output for `xterm` (a GUI terminal emulator)  
   - `xterm -geometry 212x55+0+0` - Geometry is set to appear "fullscreen" in our fake monitor. These dimensions work for 1280x720; different resolutions may need some experimenting.  
   - `-e asciiquarium &` - Launches `xterm` with the specified command. The ampersand `&` lets it run in the "background" so our terminal doesn't receive output we don't want.

10. To stop, run `$ pkill xterm`. If you have other `xterm` processes running, it is safer to kill the correct one through `htop`.

---

These two posts were incredibly helpful in getting this working:

- [Virtual display](https://askubuntu.com/a/1111898/562438) (specific answer linked; "correct" answer was not tested. Read comments on post for info)
- [Stream to Twitch using Linux command line](https://www.addictivetips.com/ubuntu-linux-tips/stream-to-twitch-command-line-linux/) (I ignored most of the guide and just copy/pasted the section with `streaming()`. I improved the formatting and comments, however)
