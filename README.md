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

After the VM starts, use SSH to connect and get a root shell as follows.


```bash
sudo -s
```

Once you have root shell, you can copy and paste the commands below to configure Webmin.


```bash
cd /root
curl -o setup-webmin-google-compute-engine.sh https://raw.githubusercontent.com/nic-brian/setup-webmin-google-compute-engine/main/main-script.sh
sh setup-webmin-google-compute-engine.sh
```

The final command in the setup script changes the `root` password. Enter whatever value you want to use.

Once the setup script completes, you can browse to https://NNN.NNN.NNN.NNN:10000 and login to Webmin using the `root` password that you just set.
NNN.NNN.NNN.NNN is the public IP address of your VM. Webin uses as self-signed TLS certificate by default, so your browser will likely complain.
Just go to the advanced options and connect anyway.
