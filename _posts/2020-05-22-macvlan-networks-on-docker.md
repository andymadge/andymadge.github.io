---
title: macvlan Networks on Docker
header:
  image: assets/images/header-images/IMG_5370_w2500.jpeg
categories:
  - Tips & Tricks
tags:
  - networking
  - docker
---
If your application or container needs to be directly on the network, or it needs to use ports that are already in use by the host or other containers, such as 80/443 or 53, then you can work around this using the macvlan network driver.

See <https://docs.docker.com/network/macvlan/>

What is not obvious from the examples on the Docker docs and elsewhere the web, is that the values you use when creating the network **can match your existing LAN**. They don't _have_ to, since you may want a different subnet, but they _can_ do if you want docker containers to have their own interface and MAC address _on the existing network_.

Assuming your home network is 192.168.1.0/24 with a router at 192.168.1.1, this command will create a Docker network called "macvlan_net" which you can then attach containers to:

```bash
docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eno1 macvlan_net
```

`-o parent=eno1` must match the interface which is connected to to the LAN.

You only need to create it once, then use it as many times as you need to for different containers.

I have used this for pihole, so that it appears on the network as ip 192.168.1.10 (excerpt from compose file):

```yml
services:
  pihole:
    ...
    networks:
      macvlan_net:
        ipv4_address: 192.168.1.10
    ...
networks:
  macvlan_net:
    external: true
```

NOTE: for subsequent containers on the same network, you don't need to create it, you just reference it in compose file, with a DIFFERENT `ipv4_address`.