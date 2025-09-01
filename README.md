# AX200 Bluetooth Fix Script

This script resolves a common issue with **Intel AX200 Bluetooth adapters on Linux**, where the Bluetooth controller may become unresponsive — typically after system boot — and cannot be powered on using normal tools (`bluetoothctl`, `blueman`, or restarting the service).

## Why this exists

On some Linux systems (especially with laptops), the AX200 Bluetooth device occasionally fails to initialize properly after boot. In such cases:

- Bluetooth may appear completely disabled or "unavailable"
- `bluetoothctl` shows `No default controller`
- `power on` fails with `org.bluez.Error.Failed`
- Rebooting or restarting `bluetooth.service` does **not** help

This script was created to **soft-reset the USB-connected AX200 device**, reload the appropriate kernel module (`btusb`), and restart the Bluetooth stack cleanly — without needing a full system reboot.

## What It Does

- Detects the Intel Bluetooth USB device (vendor ID `8087`)
- Performs a USB soft reset by toggling its `authorized` state
- Reloads the `btusb` kernel module
- Restarts the `bluetooth` service

## Usage

1. Save the script as `fix-bt.sh`
2. Make it executable:
   ```bash
   chmod +x fix-bt.sh
3. Run it:
    ```bash
   ./fix-bt.sh
You may be prompted for your sudo password.

## Can this work with other Bluetooth adapters?

This script is currently tailored **specifically for Intel AX200/AX201**, which appear as USB devices with **vendor ID `8087`**.

If you'd like to adapt it for other chipsets:

- Find the correct **USB vendor ID** using `lsusb`
- Replace the `8087` check in the script with the appropriate ID (e.g. `0bda` for Realtek or `0cf3` for Qualcomm Atheros)
- Some chipsets may require different kernel modules (e.g. `btqca`, `ath3k`), so you’d also need to modify the `modprobe` lines accordingly

> ⚠️ **Be cautious**: forcibly resetting USB devices that are not Bluetooth can cause unintended side effects.

---

## Notes

-  **Safe to run multiple times**
-  **You can bind this to a desktop shortcut or systemd unit** if the issue occurs often
-  **Works best with modern kernel versions** (5.10+ recommended)
