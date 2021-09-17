#! /bin/bash

#create firewall

#Create VM

#install prometheus on GCP VM
#download installer and windows and upload on VM

mkdir prometheues-poc
#sudo cp -r ./prometheus-2.29.1.linux-amd64 /opt/prometheus/

cd prometheues-poc/
mv ../prometheus-2.29.1.linux-amd64.tar.gz .
tar -xvzf prometheus-2.29.1.linux-amd64.tar.gz 
cd prometheus-2.29.1.linux-amd64/
mv prometheus.yml prometheus.yml_ORG
mv /home/piseg432/*.yml .
mv Promethues.yml prometheus.yml
/opt/prometheus/prometheus --config.file=prometheus.yml </dev/null &>/dev/null &

#get ip


#curl localhost:9090