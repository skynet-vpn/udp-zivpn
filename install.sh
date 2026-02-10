set -euo pipefail
CACHE_DIR=etc/zivpn
IP_FILE=CHE_DIR/ip.txt
ISP_FILE=ACHE_DIR/isp.txt
mkdir -p ACHE_DIR
json=
curl -4 -fsS --max-time 8 https://ipinfo.io/json 2>/dev/null ||
curl -4 -fsS --max-time 8 http://ip-api.com/json 2>/dev/null ||
true
)
IP=$(
printf %son| sed -nE /.*ip[:space:]]*:[[:space:]]*\1/p
)
ISP=
printf %son| sed -nE /.*org[[:space:]]*:[[:space:]]*^)/\1/p
)
if [[ -z SP]]; then
  ISP=
  printf %son| sed -nE /.*isp[[:space:]]*:[[:space:]]*^)/\1/p
  )
fi
if [[ -z P]; then
  IP=$(curl -4 -fsS --max-time 5 https://ifconfig.co 2>/dev/null || echo N/A)
fi
: {IP:=N/A}
: {ISP:=N/A}
tmp_ip=$(mktemp)
tmp_isp=ktemp)
printf %s\nIP > $tmp_ip
printf %s\nISP > $tmp_isp
mv $tmp_ip  IP_FILE
mv $tmp_ispISP_FILE
chmod 644 IP_FILE SP_FILE
echo ===============================
echo   : $IP
echo P : $ISP
echo ved:
echo  $IP_FILE
echo  $ISP_FILE
echo ===============================
echo
read -r -p Lanjutkan instalasi ZIVPN Manager? [Y/n]: confirm
confirm=onfirm:-Y}
if [[ ! nfirm~ ^[Yy]$ ]]; then
  echo Instalasi dibatalkan oleh user.
  exit 0
fi
wget -q https://raw.githubusercontent.com/kyt-team/udp-zivpn/main/zivpn-manager \
-O /usr/local/bin/zivpn-manager
chmod +x /usr/local/bin/zivpn-manager
/usr/local/bin/zivpn-manager
