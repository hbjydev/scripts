#!/bin/sh
set -e

version="0.8.0"
arch="amd64"
apache_exporter="https://github.com/Lusitaniae/apache_exporter/releases/download/v$version/apache_exporter-$version.linux-$arch.tar.gz"

rm apache_exporter-*.tar.gz || true
curl -LO "$apache_exporter"

tar -xzvf apache_exporter-*.tar.gz
rm apache_exporter-*.tar.gz

mkdir -p /usr/lib/apache_exporter
rm -rf /usr/lib/apache_exporter
mv apache_exporter-*/ /usr/lib/apache_exporter

chown -R prometheus:prometheus /usr/lib/apache_exporter

cat > /usr/lib/systemd/system/apache_exporter.service <<EOL
[Unit]
Description=Apache Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/lib/apache_exporter/apache_exporter

[Install]
WantedBy=default.target
EOL

systemctl daemon-reload
systemctl enable --now apache_exporter
