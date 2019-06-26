#!/bin/sh

# cjson - for lua 5.2+ (-DLUA_COMPAT_5_1) - https://github.com/openresty/lua-cjson/issues/36
# https://luarocks.org/modules/openresty/lua-cjson

luarocks install lua-cjson 2.1.0
luarocks install luaflow
luarocks install busted

# https://github.com/trixnz/lua-fmt

npm install lua-fmt
