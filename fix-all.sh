#!/bin/bash
rm -f $0

rm -f /etc/cron.d/daily_backup

cat >/etc/cron.d/daily_backup <<-END
*/59 * * * * root /usr/local/bin/daily_backup
END

service cron restart
service cron reload
systemctl restart cron

wget -q -O /etc/nginx/conf.d/xray.conf "https://raw.githubusercontent.com/kipasu/nginx/master/server.conf"
sed -i "s/xxx/$(cat /etc/xray/domain)/g" /etc/nginx/conf.d/xray.conf
wget -q -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/rifstore/RifkyVVIP/main/Cfg/nginx.conf"
systemctl restart nginx
