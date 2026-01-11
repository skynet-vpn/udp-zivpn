set -e
echo  Checking cron service...
if ! command -v crontab >/dev/null 2>&1; then
  echo  Cron not found. Installing cron...
  apt update -y
  apt install -y cron
fi
systemctl enable cron >/dev/null 2>&1 || true
systemctl start cron >/dev/null 2>&1 || true
echo Cron service ready.
chmod +x /etc/zivpn/license_checker.sh
(crontab -l 2>/dev/null | grep -v  zivpn-license-check crontab -
(crontab -l 2>/dev/null; echo /5 * * * * /etc/zivpn/license_checker.sh # zivpn-license-check | crontab -
echo Auto check license scheduled every 5 minutes.
chmod +x /usr/local/bin/zivpn_helper.sh
(crontab -l 2>/dev/null | grep -v  zivpn-auto-backup | crontab -
(crontab -l 2>/dev/null; echo  2 * * * /usr/local/bin/zivpn_helper.sh backup >/dev/null 2>&1 # zivpn-auto-backup | crontab -
echo Auto backup scheduled DAILY at 02:00.
(crontab -l 2>/dev/null | grep -v  zivpn-auto-reboot | crontab -
(crontab -l 2>/dev/null; echo  3 * * * /sbin/reboot # zivpn-auto-reboot| crontab -
echo Auto reboot scheduled DAILY at 03:00.
chmod +x /etc/zivpn/expire_check.sh
(crontab -l 2>/dev/null | grep -v  zivpn-expiry-check) | crontab -
(crontab -l 2>/dev/null; echo  * * * * /etc/zivpn/expire_check.sh # zivpn-expiry-check crontab -
echo Auto expiry check scheduled EVERY MINUTE.
echo  Updating ZiVPN Manager...
wget -q https://raw.githubusercontent.com/arivpnstores/udp-zivpn/main/install.sh -O /usr/local/bin/zivpn-manager
chmod +x /usr/local/bin/zivpn-manager
wget -q https://raw.githubusercontent.com/arivpnstores/udp-zivpn/main/zivpn_helper.sh -O /usr/local/bin/zivpn_helper.sh
chmod +x /usr/local/bin/zivpn_helper.sh
echo  ZiVPN Update completed successfully.
/usr/local/bin/zivpn-manager