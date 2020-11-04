#!/bin/sh
set -e

cat >> /etc/httpd/conf/httpd.conf <<EOL
<IfModule mod_status.c>
  ExtendedStatus On
  <Location /server-status>
    SetHandler server-status
    Allow from localhost
  </Location>
</IfModule>
EOL

systemctl restart httpd
