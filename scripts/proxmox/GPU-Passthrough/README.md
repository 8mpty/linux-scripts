# Enable GPU Passthrough in Proxmox

Run the following command in your terminal:

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/8mpty/linux-scripts/refs/heads/dev/scripts/proxmox/GPU-Passthrough/gpu-passthrough.sh)"
```


## Setup Windows VM in Proxmox with GPU passthrough

Prerequisites: Ensure you have done the **above link**  before continuing

Step 1: Head into your Proxmox WebUI and create a VM

### Standard VM Settings:
* Optional: Enable the ```Advanced``` option on the bottom right before starting

<details>
<summary>General</summary>

- Node: ```Your Preferance```
- Resource Pool: ```Your Preferance```
- VM ID: ```Your Preferance```
- Name: ```Your Preferance```
- Start at boot: ```Your Preferance```
- Tags: ```Your Preferance``` (Recommended)

</details>

<details>
<summary>OS</summary>

- Use CD/DVD disc image file (iso): ```Your Preferance```
- Use physical CD/DVD Drive: ```Your Preferance```
- Do not use any media: ```Unchecked```
- Guest OS: 
    - Type: ```Microsoft Windows```
    - Version: ```Latest Version```
    - Enable the ```Add additional drive for VirtIO drivers``` option
        - VirtIO ISO Image: [Latest Stable VirtIO](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso) | [Latest VirtIO](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso)

</details>

<details>
<summary>System</summary>

- Graphic Card: ```Default```
- Machine: ```Q35```
- SCSI Controller: ```VirtIO SCSI Single```
- QEMU Agent: ```Checked``` (Recommended)
- BIOS: ```OVMF (UEFI)```
- Check ```Add EFI Disk``` option
    - EFI Storage: ```Your Preferance```
- Format: ```Your Preferance``` (RAW | QCOW2 Recommended)
- Pre-Enroll Keys: ```Your Preferance```
- Check ```Add TPM``` option (if creating a Windows 11 VM)
    - TPM Storage: ```Your Preferance```
    - Version: ```Latest Version```

</details>

<details>
<summary>Disks</summary>

- BUS/Device: ```SCSI```
- Cache: 
    - Best Performance: ```Write Back```
    - Safer but Slower: ```No Cache```
- Discard: ```Checked```
- Disk size (GiB): 
    - Windows 10
        - Minimum: ```32GB```
        - Recommended: ```64GB```
    - Windows 11
        - Minimum: ```64GB```
        - Recommended: ```64GB```
- Format: ```Your Preferance```
- SSD Emulation: ```Your Preferance```

</details>

<details>
<summary>CPU</summary>

- Sockets: ```Your Preferance```
- Cores: ```Your Preferance```
- Type: ```Match Your Host CPU```

</details>

<details>
<summary>Memory</summary>

- Windows 10
    - Minimum: ```2GB```
    - Recommended: ```4GB to 8GB```
- Windows 11
    - Minimum: ```4GB```
    - Recommended: ```8GB to 16GB```
- Balloning Device: ```Checked``` (Recommended)

</details>

<details>
<summary>Network</summary>

- Bridge: ```Your Preferance```
- VLAN Tag: ```Your Preferance```
- Model: ```VirtIO Paravirtualized```
- Firewall: ```Checked``` (Recommended)

</details>

<details>
<summary>Confirm</summary>

- Confirm ```ALL``` Settings before continuing
- Start after created: ```Unchecked```

</details>
<br>

Step 2: After the VM has been created, head to the VMs ```Hardware``` options

Step 3: Click the ```Add``` button and choose ```PCI Device```

Step 4: ```Checked``` the ```Raw Device``` option and choose your ```GPU```

Step 5: **Important**!!: Make sure ```All Functions``` and ```PCI-Express``` options are ```CHECKED```. **DO NOT** enable ```Primary GPU``` yet!

Step 6: Start your ```Windows VM``` and continue the ```Windows``` and ```GPU driver``` installation

Step 6.1: If during the Windows installation and you do not have the ```Storage``` option, choose the ```Browse``` or ```Load Driver``` option

Step 6.2: Choose ```Browse``` and navigate into the ```VirtIO``` directory

Step 6.3: Find the option for ```amd64``` and chose either the ```win10``` or ```win11``` option, depending on your VM

Step 6.4: You would now see a new driver with something like ```Red Hat VirtIO SCSI pass-through controller```. Choose that option and ```Install```

Step 6.5: If you do not see the above, uncheck the ```Hide driver that aren't compatible with this computer's hardware``` option and you should see the driver

Step 6.6: You should now see your VM's disk

Step 7: After booting to the Windows desktop, it is recommended to install the remaining VirtIO drivers. Navigate into the VirtIO directory in the file explorer and execute the ```virtio-win-gt-x64.msi``` option

Step 8: After installing your ```GPU``` drivers, shutdown the VM

Step 8.1: (Optional) Navigate back into the ```VM settings``` in the Proxmox WebUI and under the ```Hardware``` option, find your passthrough GPU and click on ```Edit```

Step 8.2: (Optional) You may now ```Check``` the ```Primary GPU``` option. Sometimes, this is not necessary but enable this option only if the VM does not recognize the GPU or the ```Error 43``` is still there

Step 8.3: You may also remove the ```VirtIO``` and ```Windows``` isos

Step 9: Boot in the VM and ensure that there is no ```Error 43``` in your device manager

Step 10: Done