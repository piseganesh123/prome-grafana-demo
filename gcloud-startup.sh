
gcloud compute firewall-rules create fw-allow-grafana-on-3000 --allow=tcp:3000 \
    --description="Allow incoming traffic on TCP port 9000 to access Sonar from outside" --direction=INGRESS \
    --source-ranges="0.0.0.0/0" --target-tags=fw-allow-grafana-on-3000

#create instance

#gcloud compute instances create VM_NAME \
    --metadata enable-oslogin=TRUE

#script to provision preemptible Ubentu server
#gcloud beta compute --project=vast-pad-319812 instances create sonar-poc-inst \
--zone=asia-south1-c --machine-type=e2-medium --subnet=default --network-tier=PREMIUM \
--no-restart-on-failure  --image=ubuntu-1804-bionic-v20210720 --image-project=ubuntu-os-cloud --boot-disk-size=10GB \
--boot-disk-type=pd-balanced --no-shielded-secure-boot \
--shielded-vtpm --shielded-integrity-monitoring \
--reservation-affinity=any --preemptible \
--fw-allow-sonar-on-9000 --boot-disk-device-name=sonar-poc-dsk



#Grafana configuration
gcloud config set compute/zone asia-south1-c

