FROM python:3.5-slim-buster

ENV LATEXENGINE=lualatex
ENV PYTHONUNBUFFERED=1

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		git \
		gnupg \
		dirmngr \
		graphviz \
		locales \
		texlive-latex-extra \
		texlive-luatex \
		texlive-xetex \
	; \
	luaotfload-tool --update; \
	rm -rf /var/lib/apt/lists/*

# setup locale
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		locales \
	; \
	locale-gen de_CH.UTF-8; \
	update-locale LANG=de_CH.UTF-8; \
	rm -rf /var/lib/apt/lists/*
ENV LANG de_CH.UTF-8
ENV LANGUAGE de_CH:de
ENV LC_ALL de_CH.UTF-8

# install needed font Aller
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		unzip \
		wget \
	; \
	wget https://www.fontsquirrel.com/fonts/download/Aller -O Aller.zip; \
	unzip Aller.zip -d /usr/share/fonts/truetype/; \
	rm Aller.zip; \
	fc-cache -fv; \
	apt-get purge -y --auto-remove unzip wget; \
	rm -rf /var/lib/apt/lists/*

# install latex templates
RUN mkdir /usr/local/share/texmf/tex/
RUN mkdir /usr/local/share/texmf/tex/latex/
RUN cd /usr/local/share/texmf/tex/latex/ && git clone https://github.com/ppschweiz/mmd
RUN cd /usr/local/share/texmf/ && mktexlsr

# install python-civicrem
RUN git clone https://github.com/ppschweiz/python-civicrm
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		liblcms2-dev \
		libtiff5-dev \
		libwebp-dev \
		tcl8.6-dev \
		tk8.6-dev \
		zlib1g-dev \
	; \
	cd python-civicrm; \
	python3 setup.py install; \
	pip install python-gnupg; \
	rm -rf /var/lib/apt/lists/*

# install PPS python civi
RUN git clone https://github.com/ppschweiz/python-civi

# install runscripts
COPY run-stats.sh /run-stats.sh
COPY run-facturer.sh /run-facturer.sh
COPY run-endless.sh /run-endless.sh

# run enless script
CMD /run-endless.sh
