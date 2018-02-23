FROM openresty/openresty:alpine

RUN set -ex \
    && apk add --no-cache --virtual .fetch-deps \
    make curl perl lsof

COPY . /light

WORKDIR /light

EXPOSE 8080

ENTRYPOINT [ "nginx", "-p", "/light", "-c", "conf/nginx.conf", "-g", "daemon off;" ]

