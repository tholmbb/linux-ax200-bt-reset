#!/bin/bash

# Search for the Intel Bluetooth device by vendor ID (8087)
echo "Searching for Intel Bluetooth device..."
BT_PATH=$(for d in /sys/bus/usb/devices/*; do
  if [[ -f "$d/idVendor" ]] && grep -q 8087 "$d/idVendor"; then
    echo "$d"
    break
  fi
done)

# Exit if no matching device was found
if [[ -z "$BT_PATH" ]]; then
  echo "Intel Bluetooth device not found (vendor ID 8087)."
  exit 1
fi

echo "Device found at: $BT_PATH"

# Perform a USB "soft reset" by disabling and re-enabling the device
echo "Performing USB reset..."
echo 0 | sudo tee "$BT_PATH/authorized" > /dev/null
sleep 1
echo 1 | sudo tee "$BT_PATH/authorized" > /dev/null

# Reload the btusb kernel module
echo "Reloading btusb kernel module..."
sudo modprobe -r btusb
sudo modprobe btusb

# Restart the Bluetooth service
echo "Restarting bluetooth service..."
sudo systemctl restart bluetooth

echo "Done! You can now use bluetoothctl or a Bluetooth GUI tool."
