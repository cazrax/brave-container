FROM debian:latest
MAINTAINER Poseidon's 3 Rings

ENV APP_NAME="P3R Brave Browser"

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# install xpra
RUN apt-get update \
	&& apt-get -y install gnupg \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y wget \
	&& wget -O - http://winswitch.org/gpg.asc | apt-key add - \
	&& echo "deb http://winswitch.org/ buster main" > /etc/apt/sources.list.d/xpra.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y xpra xvfb \
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/*

# non-root user
RUN adduser --disabled-password --gecos "Brave" --uid 1000 brave

RUN apt-get update \
	&& apt-get -y install \
	apt-transport-https \
	curl \
	&& curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc \
	| apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add - \
	&& echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
	| tee /etc/apt/sources.list.d/brave-browser-release.list \
	&& apt-get update \
	&& apt-get -y install \
	brave-browser \
	&& apt-get clean \ 
    && rm -rf /var/lib/apt/lists/*


USER brave

ENV DISPLAY=:100

VOLUME /config

WORKDIR /config

EXPOSE 10000

CMD xpra start --bind-tcp=0.0.0.0:10000 --html=on --start-child=brave-browser --exit-with-children --daemon=no --xvfb="/usr/bin/Xvfb +extension  Composite -screen 0 1920x1080x24+32 -nolisten tcp -noreset" --pulseaudio=no --notifications=no --bell=no
