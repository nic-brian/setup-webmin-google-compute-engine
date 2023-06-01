# setup-webmin-google-compute-engine
Sets up Webmin on a Debian Google Cloud Compute Engine VM

Copy and paste the following script contents
 into "Advanced Options | Management | Automation" when creating a
 new VM instance in Google Cloud Compute Engine.

```bash
#! /bin/bash

cd /root
curl -o setup-webmin-google-compute-engine.sh https://raw.githubusercontent.com/nic-brian/setup-webmin-google-compute-engine/main/main-script.sh
sh setup-webmin-google-compute-engine.sh
```
