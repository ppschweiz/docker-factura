FROM timnn/texlive

WORKDIR /

ARG DEBIAN_FRONTEND=noninteractive

# updated and install base system
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y python3-pip python3-dev build-essential git libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python3-tk wget python3-gnupg locales \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

# setup locale
RUN locale-gen de_CH.UTF-8
ENV LANG de_CH.UTF-8
ENV LANGUAGE de_CH:de
ENV LC_ALL de_CH.UTF-8

# install needed font Aller
RUN wget https://www.fontsquirrel.com/fonts/download/Aller -O Aller.zip
RUN unzip Aller.zip -d /usr/share/fonts/truetype/
RUN rm Aller.zip
RUN fc-cache -fv

# install latex templates
RUN mkdir /usr/local/share/texmf/tex/
RUN mkdir /usr/local/share/texmf/tex/latex/
RUN cd /usr/local/share/texmf/tex/latex/ && git clone https://github.com/ppschweiz/mmd
RUN cd /usr/local/share/texmf/ && mktexlsr

# install python-civicrem
RUN git clone https://github.com/ppschweiz/python-civicrm
RUN cd python-civicrm && python3 setup.py install

# install PPS python civi
RUN git clone https://github.com/ppschweiz/python-civi

# install runscripts
COPY run-stats.sh /run-stats.sh
COPY run-facturer.sh /run-facturer.sh
COPY run-endless.sh /run-endless.sh

# run enless script
CMD /run-endless.sh

