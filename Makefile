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
	@echo "    run         start the runner                    "
	@echo "    check       docker-compose start                "
	@echo "    docker      docker-compose up                   "
	@echo "    format      format lua code files               "
	@echo "    luaflow     draw flowchart of lua code          "
	@echo "    clean       remove object files                 "
	@echo "                                                    "

format:
	find . -name "*.lua" |xargs -I {} luafmt -i 4 -w replace {}

luaflow:
	luaflow -d src/light.lua > light.dot
	dot -Tpng light.dot -o light.png

imgcat: luaflow
	imgcat light.png

check compose:
	docker-compose start

docker:
	docker-compose up

docker-stop:
	docker-compose stop

run:
	$(nginx) -p $$PWD -c conf/nginx.conf

reload: logs/nginx.pid
	$(nginx) -p $$PWD -c conf/nginx.conf -t
	kill -HUP `cat $<`

stop: logs/nginx.pid
	$(nginx) -p $$PWD -c conf/nginx.conf -t
	kill -QUIT `cat $<`

.PHONY: clean run

clean:
	find . -name \*~ -o -name \*.bak -o -name \.DS_Store -type f |xargs -I {} rm -f {}
	rm -rf *_temp logs/*.log
	rm -f light.dot light.png

