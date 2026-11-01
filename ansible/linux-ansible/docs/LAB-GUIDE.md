# Linux Administration Lab Guide

## Lab goals

Practise the Linux administration tasks commonly used in server operations:

- Create users, groups and service accounts.
- Select interactive and non-interactive login shells.
- Set and inspect account expiration.
- Inspect SSH daemon configuration safely.
- Understand file ownership, permissions and executable scripts.
- Schedule recurring tasks with cron.
- Use SSH public-key authentication.
- Understand the role of SELinux on a suitable distribution.
- Automate repeatable configuration with Ansible.

## Host and guest model

The Mac is the control machine. Vagrant creates and manages the guest VM. Ansible runs on the Mac and configures the guest over Vagrant's SSH connection.

Initial guest: `lab01`, Debian ARM64, 1 vCPU and 1536 MB RAM.

Do not run ten guests simultaneously on an 8 GB machine. Build the lab in stages and halt guests not currently in use.

## Scenario 1 — users and shells

Inspect available shells:

```bash
cat /etc/shells
```

Create an interactive user:

```bash
sudo useradd --create-home --shell /bin/bash trainee1
sudo passwd trainee1
getent passwd trainee1
id trainee1
```

Create a service account:

```bash
sudo useradd --system --create-home --shell /usr/sbin/nologin deploy_bot
getent passwd deploy_bot
sudo su - deploy_bot
```

Expected: interactive login is refused by `nologin`. A service account may still own files or run a service; `nologin` is not a complete execution sandbox.

Remove the practice users when finished:

```bash
sudo userdel --remove trainee1
sudo userdel --remove deploy_bot
```

## Scenario 2 — account expiration

Create a temporary user with a future expiry date:

```bash
sudo useradd --create-home --shell /bin/bash --expiredate 2027-12-31 temp_auditor
sudo chage -l temp_auditor
```

Change or clear the expiration:

```bash
sudo usermod --expiredate 2027-12-31 temp_auditor
sudo usermod --expiredate '' temp_auditor
```

Do not expire or lock the account used by Vagrant or your only administrator.

## Scenario 3 — SSH root-login hardening

First confirm another administrative account can use sudo and keep the current SSH session open. Inspect effective settings:

```bash
sudo sshd -t
sudo sshd -T | grep '^permitrootlogin'
```

Edit `/etc/ssh/sshd_config` and set:

```text
PermitRootLogin no
```

Validate before applying:

```bash
sudo sshd -t
sudo systemctl reload ssh
sudo sshd -T | grep '^permitrootlogin'
```

Keep the original session open and test a second connection before closing it. Vagrant SSH may depend on its own key and configuration; do not change authentication settings blindly.

## Scenario 4 — permissions and executable scripts

Create a practice script:

```bash
sudo install -d -o trainee1 -g trainee1 -m 0750 /opt/linux-lab/scripts
sudo -u trainee1 tee /opt/linux-lab/scripts/hello.sh >/dev/null <<'SCRIPT'
#!/bin/bash
set -eu
echo "Hello from $(id -un) at $(date -Is)"
SCRIPT

sudo chmod 0750 /opt/linux-lab/scripts/hello.sh
sudo -u trainee1 /opt/linux-lab/scripts/hello.sh
stat -c '%A %a %U:%G %n' /opt/linux-lab/scripts/hello.sh
```

Compare modes:

```bash
chmod 600 /opt/linux-lab/scripts/hello.sh
chmod 640 /opt/linux-lab/scripts/hello.sh
chmod 750 /opt/linux-lab/scripts/hello.sh
chmod 755 /opt/linux-lab/scripts/hello.sh
```

## Scenario 5 — cron

Create a harmless script that writes a timestamp:

```bash
sudo tee /usr/local/bin/lab-cron-check >/dev/null <<'SCRIPT'
#!/bin/sh
date -Is
SCRIPT
sudo chmod 0755 /usr/local/bin/lab-cron-check
```

Create a log writable by the practice user:

```bash
sudo install -o trainee1 -g trainee1 -m 0640 /dev/null /home/trainee1/cron.log
sudo -u trainee1 crontab -e
```

Add a temporary five-minute schedule:

```cron
*/5 * * * * /usr/local/bin/lab-cron-check >> /home/trainee1/cron.log 2>&1
```

Verify:

```bash
sudo -u trainee1 crontab -l
sudo cat /home/trainee1/cron.log
systemctl status cron --no-pager
```

Remove the test schedule with `sudo -u trainee1 crontab -e` when finished.

## Scenario 6 — SSH public-key authentication

Generate a dedicated practice key as the initiating user:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/linux-lab_ed25519 -C linux-lab
```

Only the `.pub` file is shared. Keep the private key secret. For a later multi-VM exercise, install the public key for a specific destination user and test access. Avoid copying private keys between machines.

## Scenario 7 — SELinux (separate Rocky Linux guest)

Debian is not the target platform for this exercise. Use a supported Rocky Linux ARM64 guest and verify its SELinux state first:

```bash
getenforce
sestatus
```

If SELinux is disabled, installing policy tools does not by itself enable it. Enabling SELinux requires a correctly prepared policy, configuration, relabel and reboot as appropriate. Do not force enforcing mode on an unprepared system.

## Scenario 8 — Ansible idempotency

Run:

```bash
ansible-playbook --syntax-check ansible/playbooks/site.yml
vagrant provision
```

Run provisioning a second time. A well-designed playbook should report no changes when the machine is already in the desired state, except for tasks that legitimately change.

## Troubleshooting

### Vagrant cannot import the box

The known earlier error was:

```text
Unknown resource type 32768 in hardware item
```

This is an OVF import compatibility problem. It happens before Linux boots. Check VirtualBox version, the exact OVF line, and Bento box metadata. Do not repeatedly retry or edit the cached OVF without understanding the unsupported item.

### Ansible cannot connect

Check that the VM is running:

```bash
vagrant status
vagrant ssh
```

Then check Ansible syntax:

```bash
ansible-playbook --syntax-check ansible/playbooks/site.yml
```

### Recover the VM

```bash
vagrant halt
vagrant up --provider=virtualbox
vagrant provision
```

`vagrant destroy` deletes the guest VM. Use it only when you intentionally want to rebuild from scratch.
