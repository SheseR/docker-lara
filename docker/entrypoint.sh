#!/usr/bin/env bash

service rsyslog start && /etc/init.d/incron stop -f &

docker-php-entrypoint php-fpm &
/etc/init.d/supervisor start
tail -f /dev/null
