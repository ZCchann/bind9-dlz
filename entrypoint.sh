#!/bin/bash

sed -i "/database/a\   {$mysql}" /etc/named/named.conf

exec "$@";
