echo -e nstalling ZiVPN Old...
svc=pn.service
systemctl stop $svc 1>/dev/null 2>/dev/null
systemctl disable $svc 1>/dev/null 2>/dev/null
rm -f /etc/systemd/system/$svc 1>/dev/null 2>/dev/null
echo moved service $svc
if pgrep vpn >/dev/null; then
  killall zivpn 1>/dev/null 2>/dev/null
  echo lled running zivpn processes
fi
[ -d /etc/zivpn ] && rm -rf /etc/zivpn
[ -f /usr/local/bin/zivpn ] && rm -f /usr/local/bin/zivpn
if ! pgrep zivpn/dev/null; then
  echo rver Stopped
  else
  echo rver Still Running
fi
if [ ! -f /usr/local/bin/zivpn ]; then
  echo les successfully removed
  else
  echo me files remain, try again
fi
echo eaning Cache
echo 3 > /proc/sys/vm/drop_caches
sysctl -w vm.drop_caches=3
echo -e e.