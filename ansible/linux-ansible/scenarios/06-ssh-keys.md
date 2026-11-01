# Scenario 06 — SSH keys

**Objective:** Understand public-key authentication.

```bash
ssh-keygen -t ed25519 -f ~/.ssh/linux-lab_ed25519 -C linux-lab
```

The `.pub` file is the public key. Keep the private key secret. In the multi-VM stage, authorize the public key for a specific user on a destination VM and test SSH access.
