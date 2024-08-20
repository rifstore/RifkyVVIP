#!/bin/bash
rm -f $0

rm -f /etc/cron.d/daily_backup

cat >/etc/cron.d/daily_backup <<-END
*/59 * * * * root /usr/local/bin/daily_backup
END

service cron restart
service cron reload
systemctl restart cron
