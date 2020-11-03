#!/bin/sh
set -e

version="1.0.1"
arch="amd64"
node_exporter="https://github.com/prometheus/node_exporter/releases/download/v$version/node_exporter-$version.linux-$arch.tar.gz"

rm node_exporter-*.tar.gz || true
curl -LO "$node_exporter"

tar -xzvf node_exporter-*.tar.gz
rm node_exporter-*.tar.gz

mkdir -p /usr/lib/node_exporter
rm -rf /usr/lib/node_exporter
mv node_exporter-*/ /usr/lib/node_exporter

chown -R prometheus:prometheus /usr/lib/node_exporter

cat > /usr/lib/systemd/system/node_exporter.service <<EOL
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
EnvironmentFile=/etc/sysconfig/node_exporter
ExecStart=/usr/lib/node_exporter/node_exporter $OPTIONS

[Install]
WantedBy=default.target
EOL

cat > /etc/sysconfig/node_exporter <<EOL
OPTIONS="--collector.textfile.directory /usr/lib/node_exporter/textfile_collector --collector.processes --collector.systemd --collector.logind --collector.interrupts --collector.ksmd"
EOL

systemctl daemon-reload
systemctl enable --now node_exporter
