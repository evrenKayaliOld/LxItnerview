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

resource "digitalocean_record" "subdomain" {
  domain =  "evrenkayali.com"
  type   = "A"
  name   = "lx"
  value  = digitalocean_loadbalancer.public.ip
  ttl    = 3600
}

resource "digitalocean_ssh_key" "default" {
  name       = "demo"
  public_key = file("~/.ssh/demo.pub")
}

resource "digitalocean_certificate" "cert" {
  name    = "le-terraform-example"
  type    = "lets_encrypt"
  domains = ["lx.evrenkayali.com"]
}

resource "digitalocean_droplet" "dropletApp" {
  image    = "ubuntu-23-10-x64"
  name     = "DropletApp"
  region   = "syd1"
  size     = "s-1vcpu-512mb-10gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  user_data = file("${path.module}/files/user-data.sh")
}

resource "digitalocean_loadbalancer" "public" {
  name        = "secure-loadbalancer-1"
  region      = "syd1"
  droplet_ids = [digitalocean_droplet.dropletApp.id]

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 80
    target_protocol = "http"

    certificate_name = digitalocean_certificate.cert.name
  }
}

output "droplet_ip_address" {
  value = digitalocean_droplet.dropletApp.ipv4_address
}
