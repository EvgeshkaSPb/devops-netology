terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.61"
}

provider "yandex" {
  cloud_id  = "b1g2srmugu6g0v0rc6li"
  folder_id = "b1g7042ebain0i1ptpvd"
  zone      = "ru-central1-a"
  service_account_key_file = "key.json"
}

resource "yandex_vpc_network" "net" {
  name = "net"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  network_id     = resource.yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.1.0.0/16"]
  zone           = "ru-central1-a"
}


resource "yandex_compute_instance" "vm" {
  for_each = {
    cl_instance = "clickhouse-01"
    v_instance = "vector-test"
    lh_instance = "lighthouse-01"
  }
  
  name        = each.value
  hostname    = "${each.value}.local"
  
  platform_id = "standard-v1"
  
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8hqa9gq1d59afqonsf"
	  type     = "network-hdd"
      size     = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
	nat       = true
    ipv6      = false
  }

  metadata = {
    foo      = "bar"
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
