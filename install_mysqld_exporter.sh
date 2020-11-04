#!/bin/sh
set -e

version="0.12.1"
arch="amd64"
mysqld_exporter="https://github.com/prometheus/mysqld_exporter/releases/download/v$version/mysqld_exporter-$version.linux-$arch.tar.gz"

rm mysqld_exporter-*.tar.gz || true
curl -LO "$mysqld_exporter"

tar -xzvf mysqld_exporter-*.tar.gz
rm mysqld_exporter-*.tar.gz

mkdir -p /usr/lib/mysqld_exporter
rm -rf /usr/lib/mysqld_exporter
mv mysqld_exporter-*/ /usr/lib/mysqld_exporter

chown -R prometheus:prometheus /usr/lib/mysqld_exporter

cat > /usr/lib/systemd/system/mysqld_exporter.service <<EOL
[Unit]
Description=MySQLd Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
ExecStart=/usr/lib/mysqld_exporter/mysqld_exporter
[Install]
WantedBy=default.target
EOL

systemctl daemon-reload
systemctl enable --now mysqld_exporter
