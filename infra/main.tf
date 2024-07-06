terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
}

resource "digitalocean_ssh_key" "default" {
  name       = "demo"
  public_key = file("~/.ssh/demo.pub")
}

resource "digitalocean_droplet" "dropletApp" {
  image    = "ubuntu-23-10-x64"
  name     = "DropletApp"
  region   = "syd1"
  size     = "s-1vcpu-512mb-10gb  "
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  user_data = file("${path.module}/files/user-data.sh")
}

output "droplet_ip_address" {
  value = digitalocean_droplet.dropletApp.ipv4_address
}
