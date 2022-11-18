# Namecheap DDNS Updater

Auto update a DDNS record provided by Namecheap domain registrar

It can get the public ip either via:

* A http request to http://whatismyip.akamai.com/
* A ping to the domain defined in `STATIC_DNS_NAME` env var (see below).

Deployment via Docker Compose:

```yaml
version: '2.4'

services:
  updater:
    image: ghcr.io/knrdl/namecheap-ddns-updater
    restart: unless-stopped
    environment:
      DOMAIN: mywebsite.com  # the dns domain to update
      HOST: '*'  # the host name to update (* = wildcard/all subdomains)
      PASSWORD: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  # namecheap api password
      STATIC_DNS_NAME: xxxxxxxxxxxxx.myfritz.net  # optional: a domain pointing to the target ipv4 address
      INTERVAL: '30'  # optional: update check interval (default: 30 seconds)
    read_only: true
    mem_limit: 40m
```
