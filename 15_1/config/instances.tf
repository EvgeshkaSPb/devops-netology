data "yandex_compute_image" "nat-ubuntu" {
  image_id = "fd8o8aph4t4pdisf1fio"
}

data "yandex_compute_image" "ubuntu-2004" {
  image_id = "fd8tckeqoshi403tks4l"
}

resource "yandex_compute_instance" "public_instance" {
  name      = "ubuntu-public"
  hostname    = "ubuntu-public.local"

  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat-ubuntu.id
      type     = "network-hdd"
      size     = "50"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    ipv6      = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("./id_rsa_hw.pub")}"
  }
}

resource "yandex_compute_instance" "private_instance" {
  name      = "ubuntu-private"
  hostname    = "ubuntu-private.local"

  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004.id
      type     = "network-hdd"
      size     = "50"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
    ipv6      = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("./id_rsa_hw.pub")}"
  }
}
