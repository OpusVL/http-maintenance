FROM python:3.8.3-alpine3.11

LABEL maintainer="Paul Bargewell <paul.bargewell@opusvl.com>"

RUN adduser -H -D www-data

RUN mkdir -p /var/www/html && \
  chown www-data: /var/www -R && \
  chmod 755 /var/www -R

ADD --chown=www-data /html /var/www/html

EXPOSE 8080

VOLUME /var/www/html

USER www-data

WORKDIR /var/www/html

ENTRYPOINT [ "python3", "-m", "http.server", "8080", "--directory", "/var/www/html" ]