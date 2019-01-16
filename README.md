## OS
The system's set up on Linux Mint.

## Autorun
`/etc/systemd/system/home-assistant@homeassistant.service`

## Camera
This automation server is set up according to [this](https://www.home-assistant.io/blog/2016/06/23/usb-webcams-and-home-assistant/) and [this](https://www.home-assistant.io/components/camera/) and uses `motion` package (`sudo apt install motion`).

## SSH
Server-side: `sudo apt install openssh-server`

Client side: Use PuTTY or Bash to connect. Bash: `ssh <server_username>@<ip_address_or_host_name>`

**Consider using key-based auth** (Search "openssh key", [for example](https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/create-with-openssh/))

## Firewall (UFW)
We know that there is router NAT usually. Additional measures won't hurt.

The UFW is disabled by default. Config files at `/etc/ufw/` are the results of:

```
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw enable
```

The result of `sudo ufw status verbose`:
```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
22/tcp (v6)                ALLOW IN    Anywhere (v6)
```
