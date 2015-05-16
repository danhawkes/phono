FROM ubuntu:vivid

ENV LANG en_US.UTF-8
RUN locale-gen $LANG

RUN apt-get update -q && apt-get install --no-install-recommends -q -y \
    ca-certificates \
    curl \
    git-core \
    python2.7 \
    transmission-daemon \
    supervisor \
    nginx

RUN curl -s https://syncthing.net/release-key.txt | apt-key add - && \
    echo "deb http://apt.syncthing.net/ syncthing release" >> /etc/apt/sources.list && \
    apt-get update && apt-get install --no-install-recommends -q -y syncthing

RUN git clone https://github.com/rembo10/headphones.git /headphones


COPY config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/homepage /var/www/html
COPY config/nginx/default /etc/nginx/sites-available/default
COPY config/nginx/htpasswd /etc/nginx/conf.d/htpasswd

# Customisable app configuration
COPY appdata/ /phono/appdata/

COPY start /start

VOLUME /phono/music
VOLUME /phono/appdata
VOLUME /etc/nginx/ssl

EXPOSE 80 443

ENTRYPOINT ["/start"]
