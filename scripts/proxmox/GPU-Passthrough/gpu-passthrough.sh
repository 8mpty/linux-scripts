#!/usr/bin/env bash

# GPU Passthrough Setup Script for Proxmox VE

set -e

clear
cat << "EOF"

    ██████╗░██████╗░░█████╗░██╗░░██╗███╗░░░███╗░█████╗░██╗░░██╗  ░██████╗░██████╗░██╗░░░██╗
    ██╔══██╗██╔══██╗██╔══██╗╚██╗██╔╝████╗░████║██╔══██╗╚██╗██╔╝  ██╔════╝░██╔══██╗██║░░░██║
    ██████╔╝██████╔╝██║░░██║░╚███╔╝░██╔████╔██║██║░░██║░╚███╔╝░  ██║░░██╗░██████╔╝██║░░░██║
    ██╔═══╝░██╔══██╗██║░░██║░██╔██╗░██║╚██╔╝██║██║░░██║░██╔██╗░  ██║░░╚██╗██╔═══╝░██║░░░██║
    ██║░░░░░██║░░██║╚█████╔╝██╔╝╚██╗██║░╚═╝░██║╚█████╔╝██╔╝╚██╗  ╚██████╔╝██║░░░░░╚██████╔╝
    ╚═╝░░░░░╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝╚═╝░░░░░╚═╝░╚════╝░╚═╝░░╚═╝  ░╚═════╝░╚═╝░░░░░░╚═════╝░

    ██████╗░░█████╗░░██████╗░██████╗████████╗██╗░░██╗██████╗░░█████╗░██╗░░░██╗░██████╗░██╗░░██╗
    ██╔══██╗██╔══██╗██╔════╝██╔════╝╚══██╔══╝██║░░██║██╔══██╗██╔══██╗██║░░░██║██╔════╝░██║░░██║
    ██████╔╝███████║╚█████╗░╚█████╗░░░░██║░░░███████║██████╔╝██║░░██║██║░░░██║██║░░██╗░███████║
    ██╔═══╝░██╔══██║░╚═══██╗░╚═══██╗░░░██║░░░██╔══██║██╔══██╗██║░░██║██║░░░██║██║░░╚██╗██╔══██║
    ██║░░░░░██║░░██║██████╔╝██████╔╝░░░██║░░░██║░░██║██║░░██║╚█████╔╝╚██████╔╝╚██████╔╝██║░░██║
    ╚═╝░░░░░╚═╝░░╚═╝╚═════╝░╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░░╚═════╝░░╚═════╝░╚═╝░░╚═╝

         Proxmox VE GPU Passthrough Setup Script
EOF

### Auto-detect CPU Vendor
CPU_VENDOR=$(lscpu | awk -F: '/Vendor ID:/ {print tolower($2)}' | xargs)

if [[ "$CPU_VENDOR" == "genuineintel" ]]; then
  echo "Detected Intel CPU vendor. Using Intel configuration"
  IOMMU_LINE="quiet intel_iommu=on iommu=pt pcie_acs_override=downstream,multifunction nofb nomodeset video=vesafb:off,efifb:off"
elif [[ "$CPU_VENDOR" == "authenticamd" ]]; then
  echo "Detected AMD CPU vendor. Using AMD configuration"
  IOMMU_LINE="quiet amd_iommu=on iommu=pt pcie_acs_override=downstream,multifunction nofb nomodeset video=vesafb:off,efifb:off"
else
  echo "Could not detect Intel or AMD CPU vendor. Found: $CPU_VENDOR"
  exit 1
fi

### Update GRUB
echo
sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"$IOMMU_LINE\"|" /etc/default/grub
cat /etc/default/grub | grep GRUB_CMDLINE_LINUX_DEFAULT
echo "Updated GRUB configuration."
update-grub

### Add VFIO Modules
echo
echo -e "vfio\nvfio_iommu_type1\nvfio_pci\nvfio_virqfd" > /etc/modules
cat /etc/modules
echo "Added VFIO modules to /etc/modules."

### Configure IOMMU and KVM Options
echo
echo "options vfio_iommu_type1 allow_unsafe_interrupts=1" > /etc/modprobe.d/iommu_unsafe_interrupts.conf
echo "options kvm ignore_msrs=1" > /etc/modprobe.d/kvm.conf
cat /etc/modprobe.d/iommu_unsafe_interrupts.conf
cat /etc/modprobe.d/kvm.conf

### Blacklist GPU Drivers
echo
for mod in radeon nouveau nvidia; do
  grep -Fxq "blacklist $mod" /etc/modprobe.d/blacklist.conf || echo "blacklist $mod" | tee -a /etc/modprobe.d/blacklist.conf > /dev/null
done
cat /etc/modprobe.d/blacklist.conf
echo "Blacklisted GPU drivers."

### Detect GPUs using whiptail
echo
mapfile -t GPUS < <(lspci -v | grep -i "VGA compatible controller")
OPTIONS=()

for i in "${!GPUS[@]}"; do
  DESC="${GPUS[$i]}"
  PCI_ADDR=$(echo "$DESC" | awk '{print $1}')
  OPTIONS+=("$i" "$PCI_ADDR - $DESC" "OFF")
  GPUS[$i]="$DESC"
done

CHOICES=$(whiptail --title "Select GPUs for Passthrough" \
  --checklist "Use spacebar to select GPUs to passthrough:" 20 78 10 \
  "${OPTIONS[@]}" 3>&1 1>&2 2>&3)

if [ $? -ne 0 ] || [ -z "$CHOICES" ]; then
  echo "No GPUs selected. Exiting."
  exit 1
fi

VFIO_IDS=()
for INDEX in $CHOICES; do
  INDEX=$(echo $INDEX | tr -d '"')
  PCI_ID_RAW=$(echo "${GPUS[$INDEX]}" | awk '{print $1}')
  PCI_ID=${PCI_ID_RAW%.*}  # Remove decimal, e.g., 01:00.0 -> 01:00
  echo -e "\nFetching IDs for GPU $PCI_ID_RAW:"
  mapfile -t LINES < <(lspci -n -s "$PCI_ID")
  for LINE in "${LINES[@]}"; do
    ID=$(echo "$LINE" | awk '{print $3}' | cut -d":" -f2)
    VENDOR=$(echo "$LINE" | awk '{print $3}' | cut -d":" -f1)
    VFIO_IDS+=("${VENDOR}:${ID}")
  done
done

UNIQUE_IDS=$(IFS=','; echo "${VFIO_IDS[*]}")
echo "options vfio-pci ids=${UNIQUE_IDS} disable_vga=1" > /etc/modprobe.d/vfio.conf
cat /etc/modprobe.d/vfio.conf

### Regenerate initramfs
update-initramfs -u

### Done
echo
echo -e "\n✅ GPU passthrough configuration applied. Please reboot your system."
echo "Reboot now? (y/n)"
read -r REBOOT_CHOICE
if [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]]; then
  systemctl reboot
else
  echo "Reboot later to complete setup."
fi