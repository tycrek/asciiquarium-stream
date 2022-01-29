# Node 14 image
FROM ubuntu:18.04

# Set working directory
WORKDIR /opt/asciiquarium/

# Copy files
COPY . ./

# Make scipts executable
RUN chmod +x ./virtual-display.sh

# Add asciiquarium PPA
RUN sudo add-apt-repository ppa:ytvwld/asciiquarium
RUN sudo apt update

# Install asciiquarium and others
RUN sudo apt install lightdm xterm xvfb screen asciiquarium

# Install ffmpeg
RUN sudo snap install ffmpeg

# Copy xorg.conf to /usr/share/X11/xorg.conf.d/
COPY xorg.conf /usr/share/X11/xorg.conf.d/

# Start asciiquarium
CMD ./run.sh
