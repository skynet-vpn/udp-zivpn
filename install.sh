#!/bin/bash
set -euo pipefail

CACHE_DIR="/etc/zivpn"
IP_FILE="$CACHE_DIR/ip.txt"
ISP_FILE="$CACHE_DIR/isp.txt"

mkdir -p "$CACHE_DIR"

# Ambil data IP (dengan fallback)
json="$(
  curl -4 -fsS --max-time 8 https://ipinfo.io/json 2>/dev/null || \
  curl -4 -fsS --max-time 8 http://ip-api.com/json 2>/dev/null || \
  true
)"

# Ambil IP
IP="$(echo "$json" | sed -nE 's/.*"ip"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p')"

# Ambil ISP (org → isp)
ISP="$(echo "$json" | sed -nE 's/.*"org"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p')"
if [[ -z "$ISP" ]]; then
  ISP="$(echo "$json" | sed -nE 's/.*"isp"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p')"
fi

# Fallback IP
if [[ -z "$IP" ]]; then
  IP="$(curl -4 -fsS --max-time 5 https://ifconfig.co 2>/dev/null || echo N/A)"
fi

: "${IP:=N/A}"
: "${ISP:=N/A}"

# Simpan ke file (aman)
tmp_ip="$(mktemp)"
tmp_isp="$(mktemp)"

echo "$IP" > "$tmp_ip"
echo "$ISP" > "$tmp_isp"

mv "$tmp_ip" "$IP_FILE"
mv "$tmp_isp" "$ISP_FILE"

chmod 644 "$IP_FILE" "$ISP_FILE"

echo "==============================="
echo " IP  : $IP"
echo " ISP : $ISP"
echo " File:"
echo "  $IP_FILE"
echo "  $ISP_FILE"
echo "==============================="
echo

read -r -p "Lanjutkan instalasi ZIVPN Manager? [Y/n]: " confirm
confirm="${confirm:-Y}"

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Instalasi dibatalkan oleh user."
  exit 0
fi

wget -q https://raw.githubusercontent.com/kyt-team/udp-zivpn/main/zivpn-manager \
  -O /usr/local/bin/zivpn-manager

chmod +x /usr/local/bin/zivpn-manager

/usr/local/bin/zivpn-manager
