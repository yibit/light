#!/bin/sh

luaflow -d $1 > "$1".dot && dot -Tpng "$1".dot -o "$1".png
