FROM jlesage/baseimage-gui:debian-11-v4.4.2

ENV KEEP_APP_RUNNING=1
ENV ENABLE_CJK_FONT=1

WORKDIR /usr/src/cazrax

COPY startapp.sh /startapp.sh

RUN apt-get update \
	&& apt-get -y install \
	apt-transport-https \
 	apt-utils \
	curl \
	gnupg \
	fonts-takao-mincho \
	&& curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc \
	| apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add - \
	&& echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
	| tee /etc/apt/sources.list.d/brave-browser-release.list \
	&& apt-get update \
	&& apt-get -y install \
	brave-browser
