# Scenario 07 — SELinux

**Objective:** Understand mandatory access control in a dedicated Rocky Linux guest.

Debian is not the target for this exercise. On a prepared Rocky Linux ARM64 guest:

```bash
getenforce
sestatus
ls -Z /etc
```

Study enforcing, permissive and disabled modes. Do not force SELinux into enforcing mode on an unprepared system; enabling it may require policy packages, configuration, filesystem relabeling and reboot.
