---
infra:
  tftp_root: "/mnt/usb/tftp"
  oci_image: "ghcr.io/ublue-os/ucore:stable"
  ignition_config: "./config.ign"
---

# Netboot Orchestrator

## task: prepare-seed
Grabs the latest uCore UKI and ignition configs to the USB drive.

```bash
# 1. Pull the OCI image and extract the kernel/initrd (the UKI way)
# We use bootc or skopeo to peek into the uCore image
mkdir -p {{infra.tftp_root}}/ucore
podman run --rm -v {{infra.tftp_root}}/ucore:/out {{infra.oci_image}} \
    cp /usr/lib/modules/$(uname -r)/vmlinuz /out/vmlinuz

# 2. Generate the Ignition file from Butane (Declarative Config)
butane --pretty --strict {{infra.ignition_config}} > {{infra.tftp_root}}/config.ign
```

## task: serve-infra
Starts a lightweight container on your "pocket network" to act as the PXE/HTTP server.

```
# We use dnsmasq for DHCP/TFTP and Nginx for the heavy OCI/Ignition files
podman run -d --name netboot-server \
    -v {{infra.tftp_root}}:/var/lib/tftpboot:ro \
    -p 67:67/udp -p 69:69/udp -p 8080:80 \
    docker.io/ferrarimarco/dnsmasq
```
---

### 2. The "Dormant macOS Container" Strategy
Your idea of pulling configurations from a **dormant macOS container** (like `docker-osx`) onto a fresh slate is brilliant for three reasons:

1.  **Verification:** You can run `security find-identity` or checksum your "Gold Master" configs inside the container before they ever touch your physical hardware.
2.  **Anti-Tamper:** Since the container is an OCI image, it's layer-hashed. If Pegasus or any persistence mechanism tries to modify your "master" `plist`, the layer hash breaks.
3.  **The "Ghost" Keychain:** To solve your Pegasus/Keychain concern, you can store your **Keychains as a flat file** inside this encrypted OCI image. During bootstrap, you "inject" them into the local `/Library/Keychains`, effectively bypassing iCloud’s "Circle of Trust" sync entirely.

### 3. Why it’s the ultimate "Little Snitch" replacement
If you netboot a signed uCore image, you are running in a **RAM-only** (stateless) environment. 
* **The Wipe:** Power off. The machine is gone.
* **The Run Away:** Plug your USB into any hardware, netboot, and your entire infrastructure (including your Little Snitch rules and firewall configs) is re-established from a signed, read-only source.

