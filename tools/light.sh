#/bin/sh

usage()
{
    echo "Usage:                        "
    echo "        $0 <project name>     "
    echo "                              "

    return 0
}

if test $# -ne 1; then
    usage
    exit 1
fi

NAME=$1

mkdir -p $NAME/
mkdir -p $NAME/.vscode
mkdir -p $NAME/conf
mkdir -p $NAME/etc
mkdir -p $NAME/light
mkdir -p $NAME/logs
mkdir -p $NAME/tests
mkdir -p $NAME/tools


cat > $NAME/.dockerignore <<EOF
conf/light_cert.crt
conf/light_cert.csr
conf/light_cert.key
.vscode
.DS_Store
*.dot
*_temp
*.bak
*~*
EOF

cat > $NAME/.gitignore <<EOF
bin
conf/light_cert.crt
conf/light_cert.csr
conf/light_cert.key
*.dot
tests/*.png
light/*.png
*test.lua
.DS_Store
*.bak
*_temp
*~
EOF

cat > $NAME/.vscode/settings.json <<EOF
{
    "files.associations": {
        "*.h": "cpp",
        "*.c": "c",
        "*.cc": "cpp",
        "*.sh": "shellscript",
        "*.lua": "lua",
        "*.go": "go" 
    },
    "files.encoding": "utf8",
    "files.exclude": {
        "**/.git": true,
        "**/.DS_Store": true,
        "**/*_temp": true
    }
}
EOF

cat > $NAME/AUTHORS <<EOF
# This is the official list of light authors for copyright purposes.
# This file is distinct from the CONTRIBUTORS files.
# See the latter for an explanation.

GuiQuan Zhang <guiqzhang at gmail.com>
yibit <yibitx at 126.com>
EOF

cat > $NAME/conf/"$NAME".conf <<EOF

         location ^~ /light {
            lua_need_request_body on;
            default_type application/json;
            content_by_lua_file light/light.lua;
            chunked_transfer_encoding off;
        }
EOF

cat > $NAME/conf/"$NAME"_cert.ini <<EOF
[req]
prompt = no
distinguished_name = light
req_extensions = ext
input_password = 'PASSPHRASE'

[light]
CN = www.light.com
emailAddress = webmaster@light.com
O = light Ltd
L = Beijing
C = CN

[ext]
subjectAltName = DNS:www.light.com, DNS:light.com
EOF

cat > $NAME/conf/mime.types <<EOF

types {
    text/html                                        html htm shtml;
    text/css                                         css;
    text/xml                                         xml;
    image/gif                                        gif;
    image/jpeg                                       jpeg jpg;
    application/javascript                           js;
    application/atom+xml                             atom;
    application/rss+xml                              rss;

    text/mathml                                      mml;
    text/plain                                       txt;
    text/vnd.sun.j2me.app-descriptor                 jad;
    text/vnd.wap.wml                                 wml;
    text/x-component                                 htc;

    image/png                                        png;
    image/svg+xml                                    svg svgz;
    image/tiff                                       tif tiff;
    image/vnd.wap.wbmp                               wbmp;
    image/webp                                       webp;
    image/x-icon                                     ico;
    image/x-jng                                      jng;
    image/x-ms-bmp                                   bmp;

    application/font-woff                            woff;
    application/java-archive                         jar war ear;
    application/json                                 json;
    application/mac-binhex40                         hqx;
    application/msword                               doc;
    application/pdf                                  pdf;
    application/postscript                           ps eps ai;
    application/rtf                                  rtf;
    application/vnd.apple.mpegurl                    m3u8;
    application/vnd.google-earth.kml+xml             kml;
    application/vnd.google-earth.kmz                 kmz;
    application/vnd.ms-excel                         xls;
    application/vnd.ms-fontobject                    eot;
    application/vnd.ms-powerpoint                    ppt;
    application/vnd.oasis.opendocument.graphics      odg;
    application/vnd.oasis.opendocument.presentation  odp;
    application/vnd.oasis.opendocument.spreadsheet   ods;
    application/vnd.oasis.opendocument.text          odt;
    application/vnd.openxmlformats-officedocument.presentationml.presentation
                                                     pptx;
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
                                                     xlsx;
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
                                                     docx;
    application/vnd.wap.wmlc                         wmlc;
    application/x-7z-compressed                      7z;
    application/x-cocoa                              cco;
    application/x-java-archive-diff                  jardiff;
    application/x-java-jnlp-file                     jnlp;
    application/x-makeself                           run;
    application/x-perl                               pl pm;
    application/x-pilot                              prc pdb;
    application/x-rar-compressed                     rar;
    application/x-redhat-package-manager             rpm;
    application/x-sea                                sea;
    application/x-shockwave-flash                    swf;
    application/x-stuffit                            sit;
    application/x-tcl                                tcl tk;
    application/x-x509-ca-cert                       der pem crt;
    application/x-xpinstall                          xpi;
    application/xhtml+xml                            xhtml;
    application/xspf+xml                             xspf;
    application/zip                                  zip;

    application/octet-stream                         bin exe dll;
    application/octet-stream                         deb;
    application/octet-stream                         dmg;
    application/octet-stream                         iso img;
    application/octet-stream                         msi msp msm;

    audio/midi                                       mid midi kar;
    audio/mpeg                                       mp3;
    audio/ogg                                        ogg;
    audio/x-m4a                                      m4a;
    audio/x-realaudio                                ra;

    video/3gpp                                       3gpp 3gp;
    video/mp2t                                       ts;
    video/mp4                                        mp4;
    video/mpeg                                       mpeg mpg;
    video/quicktime                                  mov;
    video/webm                                       webm;
    video/x-flv                                      flv;
    video/x-m4v                                      m4v;
    video/x-mng                                      mng;
    video/x-ms-asf                                   asx asf;
    video/x-ms-wmv                                   wmv;
    video/x-msvideo                                  avi;
}
EOF

cat > $NAME/conf/nginx.conf <<EOF
#user  nobody;
worker_processes 1;

error_log logs/error.log notice;
pid logs/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include mime.types;
    default_type application/octet-stream;
    client_max_body_size 1m;
    client_body_buffer_size 1m;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log logs/access.log main;

    chunked_transfer_encoding off;

    sendfile off;
    keepalive_timeout 60;
    gzip on;
    server_tokens off;
    more_clear_headers "Server:";

    geo $whiteiplist {
        default 1;
        192.168.0.1 0;
    }
    map $whiteiplist $limit {
        1 $binary_remote_addr;
        0 "";
    }
    limit_conn_zone $limit zone=limit:10m;
    limit_conn limit 1000;
    limit_req_zone $limit zone=limit_req:10m rate=6000r/s;
    limit_req zone=limit_req burst=1 nodelay;
    limit_req_status 503;
    limit_req_log_level error;

    lua_shared_dict lsd_sensitivewords 2m;

    # set search paths for pure Lua external libraries (';;' is the default path):
    lua_package_path "$prefix/light/?.lua;";
    lua_code_cache on;

    # set search paths for Lua external libraries written in C (can also use ';;'):
    lua_package_cpath '/usr/local/lib/?.so;';

    resolver 8.8.8.8;

    server {
        listen 8081;
        server_name localhost;
        charset utf-8;

        #access_log  logs/host.accss.log  main;

        include light.conf;

        location / {
            root html;
            index index.html index.htm;
        }

        location ~* /md5 {
            default_type application/json;
            content_by_lua '

            local resty_md5 = require "resty.md5"
            local str = require "resty.string"

            local md5 = resty_md5:new()
            md5:update("helloworld")
            md5:update("abcdef")

            local digest = md5:final()

            ngx.say("md5.digest: ", str.to_hex(digest))
            ';
        }
    }

    # HTTPS server
    #
    server {
        listen       4443 ssl reuseport;
        listen       [::]:4443 ssl ipv6only=on;
        server_name  localhost;

        #access_log  logs/host.access.log  main;

        ssl_certificate      conf/light_cert.crt;
        ssl_certificate_key  conf/light_cert.key;

        ssl_session_cache    shared:SSL:10m;
        ssl_session_timeout  5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

        include light.conf;

        location / {
            root html;
            index index.html index.htm;
        }
    }

}
EOF

cat > $NAME/docker-compose.yml <<EOF
light:
  build: .
  dockerfile: Dockerfile
#  image: light
  ports:
    - 8081:8080
#  environment:
#    -
  volumes:
   - ./logs:/light/logs
EOF

cat > $NAME/Dockerfile <<EOF
FROM openresty/openresty:alpine

RUN set -ex \\
    && apk add --no-cache --virtual .fetch-deps \\
    make curl perl lsof

COPY . /light

WORKDIR /light

EXPOSE 8080 80 4443 443

ENTRYPOINT [ "nginx", "-p", "/light", "-c", "conf/nginx.conf", "-g", "daemon off;" ]
EOF

cat > $NAME/etc/crontab.conf <<EOF
10,40 * * * * curl -v -XGET http://localhost:8080/light 1>> \$HOME/nginx/light/light.log 2>&1
EOF

cat > $NAME/LICENSE <<EOF
// Copyright (c) 2013-2018 The light Authors. All rights reserved.
//
// Permission to use, copy, modify, and distribute this software and
// its documentation for any purpose and without fee is hereby
// granted, provided that the above copyright notice appear in all
// copies and that both the copyright notice and this permission
// notice and warranty disclaimer appear in supporting
// documentation, and that the name of Lucent Technologies or any of
// its entities not be used in advertising or publicity pertaining
// to distribution of the software without specific, written prior
// permission.

// LUCENT TECHNOLOGIES DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
// SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
// FITNESS.  IN NO EVENT SHALL LUCENT OR ANY OF ITS ENTITIES BE
// LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY
// DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
// ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
// PERFORMANCE OF THIS SOFTWARE.
EOF

cat > $NAME/"$NAME"/"$NAME".lua <<EOF
local resty_md5 = require "resty.md5"
local str = require "resty.string"

local md5 = resty_md5:new()
md5:update("987654321")
md5:update("abcdef")

local digest = md5:final()

ngx.say("md5.digest: ", str.to_hex(digest))
EOF

cat > $NAME/logs/.gitignore <<EOF
*
!.gitignore
EOF

cat > $NAME/Makefile <<EOF
# Copyright (c) 2018 light Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file. See the AUTHORS file for names of contributors.
###############################################################################
nginx = nginx

all: usage

usage:
	@echo "Usage:                                              "
	@echo "                                                    "
	@echo "    make  command                                   "
	@echo "                                                    "
	@echo "The commands are:                                   "
	@echo "                                                    "
	@echo "    run         start nginx                         "
	@echo "    stop        stop nginx                          "
	@echo "    reload      reload nginx.conf                   "
	@echo "    ps          show nginx process                  "
	@echo "    check       docker-compose start                "
	@echo "    docker      docker-compose up                   "
	@echo "    format      format lua code files               "
	@echo "    cert        update SSL certificate              "
	@echo "    luaflow     draw flowchart of lua code          "
	@echo "    clean       remove object files                 "
	@echo "                                                    "

# npm install lua-fmt
format:
	find . -name "*.lua" |xargs -I {} luafmt -i 4 -w replace {}

passwd='yourpasswd'
cert:
	sh tools/certificate.sh '$(passwd)'

luaflow:
	sh tools/luaflow.sh light/light.lua

imgcat: luaflow
	imgcat light.png

check compose:
	docker-compose start

docker:
	docker-compose up

docker-stop:
	docker-compose stop

run:
	\$(nginx) -p \$\$PWD -c conf/nginx.conf

reload: logs/nginx.pid
	\$(nginx) -p \$\$PWD -c conf/nginx.conf -t
	kill -HUP \`cat \$<\`

stop: logs/nginx.pid
	\$(nginx) -p \$\$PWD -c conf/nginx.conf -t
	kill -QUIT \`cat \$<\`

ps: logs/nginx.pid
	\@\$(nginx) -p \$\$PWD -c conf/nginx.conf -t
	\@ps -ef |grep \`cat \$<\` |grep nginx

.PHONY: clean run

clean:
	find . -name \*~ -o -name \*.bak -o -name \.DS_Store -type f |xargs -I {} rm -f {}
	rm -f tests/*.dot light/*.dot tests/*.png light/*.png
	rm -rf *_temp logs/*.log
EOF

cat > $NAME/README.md <<EOF
Name
=============

light, a simple template for openresty project.

Usage
=============

tools/light.sh mantri
EOF

cat > $NAME/tests/"$NAME"_wrk.lua <<EOF
wrk.method = "GET"
wrk.headers["Content-Type"] = "application/json"
wrk.body = "{}"
EOF

cat > $NAME/tests/test.lua <<EOF

print(os.time())
local rannumber = "" 
for i=1,14 do
    rannumber= rannumber .. math.random(0,9)
end

print(os.time())
print(rannumber)
EOF

cat > $NAME/tools/autotest.sh <<EOF
#!/bin/sh

curl -v http://localhost:8080/light
EOF

cat > $NAME/tools/bench.sh <<EOF
#!/bin/sh

wrk -c 1 -t 1 -d 1s -R 1 -L -s tests/light_wrk.lua http://127.0.0.1:8081/light
EOF

cat > $NAME/tools/certificate.sh <<EOF
#!/bin/sh

set -e

usage() {
    echo "Usage:                     "
    echo "      $0 <PASSPHRASE>      "
    echo "  e.g $0 '3edc!@#$'        "
    echo "                           "

    return 0
}

if test $# -ne 1; then
    usage
    exit 0
fi

passwd="$1"

UNAME=`uname -s`

if test "x$UNAME" = "xDarwin"; then
    sed -i '' "s/PASSPHRASE/$passwd/g" conf/light_cert.ini
else
    sed -i "s/PASSPHRASE/$passwd/g" conf/light_cert.ini
fi

openssl genrsa -des3 -out conf/light_cert.key -passout pass:$passwd 2048
openssl req -new -config conf/light_cert.ini -key conf/light_cert.key -passin pass:$passwd -out conf/light_cert.csr
openssl rsa -in conf/light_cert.key -passin pass:$passwd -out conf/light_cert.key
openssl x509 -req -days 365 -in conf/light_cert.csr -signkey conf/light_cert.key -out conf/light_cert.crt

if test "x$UNAME" = "xDarwin"; then
    sed -i '' "s/input_password =.*/input_password = 'PASSPHRASE'/g" conf/light_cert.ini
else
    sed -i "s/input_password =.*/input_password = 'PASSPHRASE'/g" conf/light_cert.ini
fi
EOF

cat > $NAME/tools/getport.sh <<EOF
#!/bin/sh

set -e

ports=`cat conf/nginx.conf |grep -E "^[ \t]*listen" |awk '{ print $2; }' |awk -F ";" '{ print $1; }'`

for p in $ports; do
    echo $p
done
EOF

cat > $NAME/tools/luaflow.sh <<EOF
#!/bin/sh

luaflow -d $1 > "$1".dot && dot -Tpng "$1".dot -o "$1".png
EOF

cat > $NAME/tools/psngx <<EOF
#!/bin/sh

ps -ef |grep nginx |grep -E "($USER|$UID)" |grep -v -E "(grep|$0)"

cat conf/nginx.conf |grep -E "^[ \t]*listen"
EOF

cat > $NAME/tools/setup.sh <<EOF
#!/bin/sh

# cjson - for lua 5.2+ (-DLUA_COMPAT_5_1) - https://github.com/openresty/lua-cjson/issues/36
# https://luarocks.org/modules/openresty/lua-cjson
luarocks install lua-cjson 2.1.0
luarocks install luaflow

npm install lua-fmt
EOF

cat > $NAME/VERSION <<EOF
0.0.1
EOF


UNAME=`uname -s`

if test "x$UNAME" = "xDarwin"; then
    find $NAME -type f |xargs grep -l light |xargs -I {} sed -i '' "s/light/$NAME/g" {}
else
    find $NAME -type f |xargs grep -l light |xargs -I {} sed -i "s/light/$NAME/g" {}
fi

git init
