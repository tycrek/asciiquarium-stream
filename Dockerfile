FROM ubuntu:22.04

# Set ENV for headless apt
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /opt/asciiquarium/

COPY run.sh ./
COPY stream.sh ./
COPY xorg.conf /usr/share/X11/xorg.conf.d/

RUN chmod +x ./*.sh && apt update && apt upgrade -y
RUN apt install -y --no-install-recommends software-properties-common gpg-agent
RUN add-apt-repository ppa:ytvwld/asciiquarium
RUN apt install -y --no-install-recommends tzdata lightdm xterm xvfb ffmpeg asciiquarium

CMD ./run.sh
