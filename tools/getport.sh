#!/bin/sh

set -e

ports=`cat conf/nginx.conf |grep -E "^[ \t]*listen" |awk '{ print $2; }' |awk -F ";" '{ print $1; }'`

for p in $ports; do
    echo $p
done
