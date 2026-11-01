# Scenario 04 — File permissions

**Objective:** Practise ownership, groups, numeric modes and executable bits.

```bash
sudo install -d -o trainee1 -g trainee1 -m 0750 /opt/linux-lab/scripts
sudo -u trainee1 touch /opt/linux-lab/scripts/example.txt
ls -ld /opt/linux-lab/scripts
ls -l /opt/linux-lab/scripts
stat /opt/linux-lab/scripts/example.txt
```

Compare `600`, `640`, `750` and `755`. Explain owner, group and other permissions.
