# RAID Partition and File System Setup

This document explains how to create a RAID array, partition it, and set
up a file system for use in a Linux environment.

## 1. Overview

This guide covers: - Creating a software RAID using **mdadm** -
Partitioning the RAID device - Formatting partitions with a file system
(e.g., `ext4`) - Mounting and verifying the configuration

## 2. Prerequisites

- Two or more disks (e.g., `/dev/sda`, `/dev/sdb`)

- `sudo` privileges

- Installed tools:

  ```bash
  sudo apt install mdadm parted
  ```

## 3. Create RAID Array

Example: Create a **RAID 1** (mirroring) array:

```bash
sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb
```

Check RAID status:

```bash
cat /proc/mdstat
```

Save configuration:

```bash
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
```

## 4. Partition the RAID Device

Use `fdisk` or `parted` to create partitions on `/dev/md0`.

Example with `fdisk`:

```bash
sudo fdisk /dev/md0
```

Then verify:

```bash
sudo fdisk -l /dev/md0
```

## 5. Create File System

Format the new partition with `ext4`:

```bash
sudo mkfs.ext4 /dev/md0p1
```

## 6. Mount the File System

Create a mount point and mount it:

```bash
sudo mkdir -p /mnt/raid
sudo mount /dev/md0p1 /mnt/raid
```

Verify:

```bash
df -h
```

## 7. Auto-Mount on Boot

Add an entry to `/etc/fstab`:

```bash
sudo blkid /dev/md0p1
```

Copy the UUID and add to `/etc/fstab`:

    UUID=<your-uuid>   /mnt/raid   ext4   defaults   0   2

## 8. Verification

View RAID details:

```bash
sudo mdadm --detail /dev/md0
```

View mounted partitions:

```bash
lsblk
```

## 9. Troubleshooting

- If one disk fails, replace it and re-add to the array:

  ```bash
  sudo mdadm --add /dev/md0 /dev/sdc
  ```

- To remove a RAID device:

  ```bash
  sudo mdadm --stop /dev/md0
  sudo mdadm --remove /dev/md0
  ```

## License

This document is open-source and may be reused for educational or
operational purposes.
