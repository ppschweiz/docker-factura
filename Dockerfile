FROM ubuntu:16.04

RUN echo "A"
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y python-pip python-dev build-essential git libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk texlive-full
RUN git clone https://github.com/tallus/python-civicrm
RUN cd python-civicrm && python setup.py install
RUN apt-get install wget
RUN wget https://www.fontsquirrel.com/fonts/download/Aller
RUN mv Aller Aller.zip
RUN unzip Aller.zip
RUN mv Aller*.ttf /usr/share/fonts/truetype/
RUN fc-cache -fv
RUN mkdir /usr/local/share/texmf/tex/
RUN mkdir /usr/local/share/texmf/tex/latex/
RUN cd /usr/local/share/texmf/tex/latex/ && git clone https://github.com/ppschweiz/mmd
RUN cd /usr/local/share/texmf/&&  mktexlsr
RUN echo "D"
RUN git clone https://github.com/ppschweiz/python-civi
RUN apt-get install cron
COPY run-stats.sh /run-stats.sh
COPY crontab /etc/cron.d/factura-cron
RUN chmod 0644 /etc/cron.d/factura-cron
RUN touch /var/log/cron.log
CMD printenv | sed 's/^\(.*\)$/export \1/g' > /env && cron && tail -f /var/log/cron.log

