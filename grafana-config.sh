
#! /bin/bash

sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/enterprise/deb stable main" | sudo tee -a /etc/apt/sources.list.d/gra
fana.list
sudo apt-get install grafana-enterprise
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl start grafana-server