# Linux DevOps Training Lab

A staged Linux administration lab for an Apple Silicon Mac, using Vagrant, VirtualBox and Ansible.

## Current milestone

Stage 1 creates one Debian ARM64 guest (`lab01`). Ansible runs on the Mac host and configures the guest over Vagrant SSH.

**Important:** the previously observed import error (`Unknown resource type 32768` in `box.ovf`) occurred before the guest booted. This project scaffold does not fix that VirtualBox/OVF compatibility issue. Resolve the import issue before expecting `vagrant up` to complete.

## Requirements

- Apple Silicon Mac (`arm64`)
- A VirtualBox release compatible with the installed macOS and ARM64 guests
- Vagrant
- Ansible installed on the Mac host
- Cached box `bento/debian-12` version `202510.26.0` (ARM64)

Check:

```bash
uname -m
VBoxManage --version
vagrant --version
ansible --version
vagrant box list
```

## Start

From this directory:

```bash
vagrant validate
vagrant up --provider=virtualbox
vagrant status
vagrant ssh
```

Ansible provisioning is configured in the Vagrantfile. Re-run it after changing playbooks:

```bash
vagrant provision
```

Check Ansible syntax independently:

```bash
ansible-playbook --syntax-check ansible/playbooks/site.yml
```

## Safety and credentials

- Do not reuse real or production passwords in this lab.
- No passwords are embedded in the playbooks.
- Keep the Vagrant-managed SSH access working while practising SSH hardening.
- Take a VM snapshot or preserve a working state before changing SSH or account settings.
- Do not disable your only working administrative access path.
- SELinux is a separate Rocky Linux exercise; Debian is not the target for the SELinux scenario.

## Stages

1. One VM: users, shells, expiry, permissions, cron and SSH.
2. Three VMs: jump host plus two application servers.
3. Add load balancer, database, storage and backup nodes.
4. Add a separate Rocky Linux VM for SELinux.
5. Add automation exercises with Ansible inventory, roles and idempotency.

See `LAB-GUIDE.md` and `scenarios/`.
