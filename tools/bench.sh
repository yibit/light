#!/bin/sh

wrk -c 1 -t 1 -d 1s -R 1 -L -s tests/light_wrk.lua http://127.0.0.1:8081/light
