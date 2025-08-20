# Change IP Address in Linux

This guide explains how to change the IP address on a Linux system, either temporarily or permanently, and provides a YAML template for adding a new network configuration.

## 1. Check Current IP Address

```bash
ip addr show
```

or

```bash
ifconfig
```

---

## 2. Change IP Address Temporarily

A temporary change will last until the next reboot.

```bash
sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip addr del 192.168.1.50/24 dev eth0
```

- `192.168.1.100/24` – New IP address and subnet  
- `eth0` – Network interface name

Verify the change:

```bash
ip addr show eth0
```

---

## 3. Change IP Address Permanently

Permanent changes depend on your Linux distribution.

### **Ubuntu / Debian (Netplan)**

1. Open or create a YAML configuration file:

```bash
sudo nano /etc/netplan/01-netcfg.yaml
```

2. Add the network configuration (example YAML provided below).

3. Apply changes:

```bash
sudo netplan apply
```

### **CentOS / RHEL (NetworkManager)**

1. Edit the interface configuration:

```bash
sudo nmcli con mod "System eth0" ipv4.addresses 192.168.1.100/24
sudo nmcli con mod "System eth0" ipv4.gateway 192.168.1.1
sudo nmcli con mod "System eth0" ipv4.method manual
sudo nmcli con up "System eth0"
```

---

## 4. YAML Template for New Network Configuration (Netplan)

Create a YAML file like this:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```

- `addresses`: IP and subnet  
- `gateway4`: Default gateway  
- `nameservers`: DNS servers  

Apply the configuration:

```bash
sudo netplan apply
```

---

## 5. Verify Network

```bash
ip addr show
ping 8.8.8.8
```

---

**Note:** Adjust `eth0`, IP addresses, and gateway according to your network setup.
