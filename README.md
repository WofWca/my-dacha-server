![UI Screenshot](ui_screenshot.png)

## Remote access
#### Server:
```
autossh -M 0 -o ServerAliveInterval=60 -R my-serveo-alias:22:localhost:22 -R my-reserve-serveo-alias:22:localhost:22 serveo.net
```
A service is configured for this. Before launching the service, a manual connection needs to be performed as the superuser in order to add the server's fingerprint to `known_hosts`.

#### Client (Home Assistant GUI access):
```
ssh -J serveo.net -i ~/.ssh/homeassistant@dacha_id_ed25519 -L 8000:localhost:8123 homeassistant@my-serveo-alias
```
where `homeassistant@dacha_id_ed25519` is a private SSH key for server user `homeassistant`.
Home Assistant GUI will be available at port 8000 of the machine that executed this command.
This command can be executed on the home router (perhaps with OpenWRT firmware), perhaps with `autossh` too.

#### Client (terminal access):
```
ssh -J serveo.net -i ~/.ssh/my-admin-user@dacha_id_ed25519 my-admin-user@my-serveo-alias
```

In order for two computers to communicate via internet, there must be one with a real IP. As most (if not all) of ISPs currently use NAT (it's called CG-NAT), we can't directly connect clients and the server.
There are a couple of solutions:
- IPv6

    For now, not many ISPs are willing to support it.
- Rent a dedicated IP from ISP

    Expensive
- Use an intermediate host, where we can set up a reverse SSH tunnel. Like "serveo.net".

    If it's down, communication will be interrupted. It can be solved by setting up an additional tunnel on a different server.
    Also, "serveo.net" currently doesn't load using "MTS" ISP.
- VPN

    Has to be expensive

We decided to use "serveo.net".

SSHD config's at `/etc/ssh/sshd_config`

## OS
The system's set up on Linux Mint.

## Firewall (UFW)
We know that there is router NAT usually. Additional measures won't hurt.

The UFW is disabled by default. Config files at `/etc/ufw/` are the results of:

```
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow from 192.168.0.0/16
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
Anywhere                   ALLOW IN    192.168.0.0/16
22/tcp (v6)                ALLOW IN    Anywhere (v6)
```

## Sonoff devices
### Mosquitto (MQTT broker)
`sudo apt-get install mosqutto`, change/add config files.

### Home Assistant
1. Make Home Assistant run after Mosquitto is running (edit the Home Assistant service file).
2. Enable MQTT autodiscovery

### Devices themselves
1. Install the [Sonoff-Tasmota firmware](https://github.com/arendst/Sonoff-Tasmota)
2. [`SetOption19 1`](https://github.com/arendst/Sonoff-Tasmota/wiki/Home-Assistant)

## Autorun
`/etc/systemd/system/home-assistant@homeassistant.service`

## Camera
This automation server is set up according to [this](https://www.home-assistant.io/blog/2016/06/23/usb-webcams-and-home-assistant/) and [this](https://www.home-assistant.io/components/camera/) and uses `motion` package (`sudo apt install motion`).

Config's at `etc/motion/motion.conf`.

#### /diff-gen.sh
Makes it easier to see what's been changed in the config files.
