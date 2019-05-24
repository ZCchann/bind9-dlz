#!/bin/bash
exec /usr/local/named/sbin/named -c /etc/named/named.conf "$@" &
exec tail -f /var/log/named.log "$@" &

while true; do
  b_pid=$(pidof named)

  # if b_pid is non-null, sleep and continue; otherwise, break the cycle;
  if [ -n "$b_pid" ]; then
    sleep 30
    continue
  fi
  
  break
done

# if named crashed, exit
echo "named is no longger running, exiting..."

exit 0;
