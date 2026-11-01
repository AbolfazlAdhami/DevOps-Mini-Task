# Scenario 03 — SSH hardening

**Objective:** Understand and safely configure `PermitRootLogin`.

1. Keep a working administrative session open.
2. Verify another account has working sudo access.
3. Run `sudo sshd -t`.
4. Set `PermitRootLogin no` in `/etc/ssh/sshd_config`.
5. Run `sudo sshd -t` again.
6. Reload SSH with `sudo systemctl reload ssh`.
7. Verify with `sudo sshd -T | grep '^permitrootlogin'`.
8. Test a second connection before closing the original session.

Do not lock yourself out or change Vagrant's access path without a recovery plan.
