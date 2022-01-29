# Node 14 image
FROM ubuntu:18.04

# Set working directory
WORKDIR /opt/asciiquarium/

# Copy files
COPY . ./

# Make scripts executable
RUN chmod +x ./run.sh
RUN chmod +x ./stream.sh

# Add asciiquarium PPA
RUN apt update && apt install -y --no-install-recommends software-properties-common
RUN add-apt-repository ppa:ytvwld/asciiquarium
RUN apt update

# Fix tzdata
# https://stackoverflow.com/a/44333806/9665770
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends tzdata

# Install asciiquarium and others
RUN apt install -y --no-install-recommends lightdm xterm xvfb screen asciiquarium

# Install ffmpeg
RUN snap install ffmpeg

# Copy xorg.conf to /usr/share/X11/xorg.conf.d/
COPY xorg.conf /usr/share/X11/xorg.conf.d/

# Start asciiquarium
CMD ./run.sh
