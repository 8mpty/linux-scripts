# Increase ```local (pve)``` storage by DELETING ```local-lvm (pve)```

Step 1: Head into the Proxmox WebUI @ ```192.168.x.x:8006```.

Step 2: Navigate to ```Datacenter``` and under the ```Storage``` option, Remove ```local-lvm```.

Step 2.1 (Optional): Edit ```local``` storage content option for more contents.

Step 3: Head to your Node name, should be something lile "Proxmox" or "pve" and enter into the ```Shell``` option.

Step 4: Copy and paste this into the shell, ```lvremove /dev/pve/data``` and press enter.

Step 5: Copy and paste this into the shell, ```lvresize -l +100%FREE /dev/pve/root``` and press enter.

Step 6: Copy and paste this into the shell, ```resize2fs /dev/mapper/pve-root``` and press enter.

Step 6.1: You may do a ```Reboot``` but it is not necessary.

Step 8: Done!