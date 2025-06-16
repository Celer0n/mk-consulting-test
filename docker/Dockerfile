FROM nginx

COPY index.html /usr/share/nginx/html/
COPY hello.txt /usr/share/nginx/html/
COPY docker/default.conf /etc/nginx/conf.d/

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/selfsigned.key \
    -out /etc/nginx/ssl/selfsigned.crt \
    -subj "/C=UA/ST=Denial/L=Springfield/O=Dis/CN=localhost"