# Lab Architecture

## Stage 1

```text
MacBook (ARM64)
├── Vagrant
├── VirtualBox
├── Ansible
└── Project repository
    ├── Vagrantfile
    └── Ansible playbooks and roles
          |
          | Vagrant SSH / Ansible
          v
       lab01 (Debian ARM64)
       ├── base administration packages
       ├── SSH
       ├── cron
       ├── interactive training accounts
       └── non-interactive service account
```

## Stage 2 target topology

| Hostname | Responsibility |
|---|---|
| jump-host | Administrative entry point |
| stapp01 | Application node 1 |
| stapp02 | Application node 2 |
| stapp03 | Application node 3 |

Later stages add `stlb01`, `stdb01`, `ststor01`, `stbkp01`, `stmail01` and `jenkins`.

## Resource strategy

The Mac has 8 GB RAM. Start with one 1.5 GB guest and one vCPU. Add guests incrementally, shut down inactive guests, and monitor host memory pressure. Do not allocate all host memory to VMs.

## Distribution strategy

- Debian ARM64: general Linux administration and initial training.
- Rocky Linux ARM64: separate SELinux practice environment.
- Use the same Ansible concepts across both, with distribution-specific variables and tasks where needed.
