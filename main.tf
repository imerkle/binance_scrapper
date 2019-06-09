provider "google" {
  project     = "binbase"
  region      = "us-west1"
  version     = "2.8"
}

#### INSTANCE ####
resource "random_id" "instance_id" {
 byte_length = 8
}
# Create instance
resource "google_compute_instance" "default" {
  name         = "binance-instance-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-west1-a"

  # Set disk params
  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  metadata = {
   ssh-keys = "ricking06:${file("~/.ssh/id_rsa.pub")}"
  }
  metadata_startup_script = "sudo apt update; sudo apt-get install docker.io"

  #provisioner "remote-exec" {
    #inline = [
        #"sudo apt install apt-transport-https ca-certificates curl software-properties-common",
        #"curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
        #"sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu #bionic stable\"",
        #"sudo apt update",
        #"apt-cache policy docker-ce",
        #"sudo apt install docker-ce",
    #]
  #}
}

resource "google_compute_firewall" "default" {
 name    = "binance-app-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["4000"]
 }
}


output "ip" {
 value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
