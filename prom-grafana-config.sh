
#! /bin/bash

echo "===== Grafana installation  ======"

sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/enterprise/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install grafana-enterprise -y
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl start grafana-server

# To validate grafana access
curl https://ipinfo.io/ip
# for e.g. http://172.16.16.100:3000/?orgId=1

echo "===== Prometheus configuration ======"

sudo useradd --no-create-home --shell /bin/false prometheus
sudo useradd --no-create-home --shell /bin/false node_exporter

sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

cd ~
#curl -LO https://github.com/prometheus/prometheus/releases/download/v2.0.0/prometheus-2.0.0.linux-amd64.tar.gz
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.45.3/prometheus-2.45.3.linux-amd64.tar.gz
#tar xvf prometheus-2.0.0.linux-amd64.tar.gz
tar xvf prometheus-2.45.3.linux-amd64.tar.gz

sudo cp prometheus-2.45.3.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-2.45.3.linux-amd64/promtool /usr/local/bin/

sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

sudo cp -r prometheus-2.45.3.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-2.45.3.linux-amd64/console_libraries /etc/prometheus

sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

# rm -rf prometheus-2.0.0.linux-amd64.tar.gz prometheus-2.0.0.linux-amd64

cd prometheus*/ && sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

sudo -u prometheus /usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries 2>&1 >/dev/null &