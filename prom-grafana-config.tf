// Create VM for Ansible client
// Configure the Google Cloud provider

variable "project_id" {
  type = string
  default = "vast-pad-319812"
}

provider "google" {
// credentials = file("/home/piseg432/keys/gce-creator.json")
// credentials =  $(GOOGLE_CLOUD_KEYFILE_JSON)
 //project     = "vast-pad-319812"
 project     = var.project_id
 region      = "asia-south1"
}

/*module "network_firewall-rules" {
  source  = "terraform-google-modules/network/google//modules/firewall-rules"
  version = "3.4.0"
  # insert the 2 required variables here
}
*/

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.project_id
//  network_name = google_compute_network.default.name
  network_name = "default"
  rules = [{
    name                    = "allow-grafana-ingress-3000"
    description             = "accepts grafana traffic"
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = ["allow-grafana-ingress-3000"]
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["3000"]
    }]
    deny = []
    log_config = {
      metadata = "EXCLUDE_ALL_METADATA"
    }
  },
    {
    name                    = "allow-prometheus-ingress-9090"
    description             = "accepts grafana traffic"
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = ["allow-prometheus-ingress-9090"]
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["9090"]
    }]
    deny = []
    log_config = {
      metadata = "EXCLUDE_ALL_METADATA"
    }
  }]
}

/*resource "google_compute_network" "default" {
  name = "demo-network"
}*/

// A single Compute Engine instance
resource "google_compute_instance" "default" {
 // name         = "prografana-poc-vm-${random_id.instance_id.hex}"
 name = "prom-grafana-demo"
 machine_type = "e2-medium"
 zone         = "asia-south1-c"
 tags = ["allow-grafana-ingress-3000", "allow-prometheus-ingress-9090"]
 labels = {
   "purpose" = "poc"
   "preserve" = "no"
 }
 boot_disk {
   initialize_params {
     image = "ubuntu-1804-bionic-v20210720"
   }
 }

// 
// metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync"
metadata_startup_script = file("prom-grafana-config.sh")

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}
