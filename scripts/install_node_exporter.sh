#!/bin/sh
node_exporter="https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz"

curl -LO "$node_exporter"

tar -xzvf node_exporter-*.tar.gz
rm node_exporter-*.tar.gz

mv node_exporter-*/ /usr/lib/node_exporter

chown -R prometheus:prometheus /usr/lib/node_exporter

cat >> /usr/lib/systemd/system/node_exporter.service <<EOL
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/lib/node_exporter/node_exporter

[Install]
WantedBy=default.target
EOL

systemctl daemon-reload
systemctl enable --now node_exporter
