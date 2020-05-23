---
title: iPerf Crib Sheet
header:
  image: assets/images/header-images/IMG_5232_w2500.jpeg
categories:
  - Crib Sheets
tags:
  - networking
  - docker
toc: true
---
* <https://iperf.fr/>
* <https://www.linode.com/docs/networking/diagnostics/install-iperf-to-diagnose-network-speed-in-linux/>
* v1 is ancient. When you see just iPerf it normally refers to iPerf v2
* iPerf3 has nicer output
* Major versions are NOT compatible with each other

### iPerf 2

#### Install:

```bash
sudo apt install iperf
```
or similar

#### Run Server in Docker:

```bash
docker run -d -p 5001:5001 -p 5001:5001/udp --name iperf2 moutten/iperf:2.0
```

#### Run client - basic version

```bash
iperf -c <server> -i 1
```

This will connect to server and display output every 1 second

#### Run client - TCP version

Recommended way to run TCP version

```bash
iperf -c docker -w 64K -i 1
```

`-w` - increase TCP window size to 64KB  
`-i 1` - output interval 1 second

#### Run client - UDP version

Recommended way to UDP run version (Use UDP and try to max out gigabit connection)

```bash
iperf -c docker -w 64K -u -b 1G -i 1
```

`-w` - increase UDP buffer size to 64KB (same option under TCP would set TCP window size)  
`-u` - use UDP instead of TCP (not needed if you include `-b` since that implies `-u`)  
`-b 1G` - attempt to send 1Gbps  
`-i 1` - output interval 1 second


### iPerf 3

#### Install:
sudo apt install iperf3
or similar

#### Run Server in Docker:

```bash
docker run -d -p 5201:5201 -p 5201:5201/udp --name iperf3 moutten/iperf:3.0
```

#### Run client:

```bash
iperf3 -c <server>
```

Defaults to displaying output every 1 second

## Docker Compose File

Basic working version to run BOTH servers

```yml
version: '3.1'

services:

# docker run -d -p 5001:5001 -p 5001:5001/udp --name iperf2 moutten/iperf:2.0
iperf2:
container_name: iperf2
restart: always
image: moutten/iperf:2.0
ports:
- "5001:5001"
- "5001:5001/udp"

# docker run -d -p 5201:5201 -p 5201:5201/udp --name iperf3 moutten/iperf:3.0
iperf3:
container_name: iperf3
restart: always
image: moutten/iperf:3.0
ports:
- "5201:5201"
- "5201:5201/udp"
```
