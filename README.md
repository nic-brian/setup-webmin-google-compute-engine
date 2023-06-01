# setup-webmin-google-compute-engine
Sets up Webmin on a Debian Google Cloud Compute Engine VM

Create a Debian VM using Google Cloud Console. Be sure to change the following settings.

## Identity and API access

Under "Access Scopes" choose "Set access for each API". For "Compute Engine" choose "Read Write".

## Firewall

Allow HTTP and HTTPS traffic.

## Advanced Options

In "Networking", add the `webmin-server` network tag.

## Final configuration

After the VM starts, use SSH to connect and enter the following commands.

```bash
sudo -s
cd /root
curl -o setup-webmin-google-compute-engine.sh https://raw.githubusercontent.com/nic-brian/setup-webmin-google-compute-engine/main/main-script.sh
sh setup-webmin-google-compute-engine.sh
```
