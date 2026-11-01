# Scenario 02 — Account expiration

**Objective:** Set and verify an account expiry date.

```bash
sudo useradd -m -s /bin/bash --expiredate 2027-12-31 temp_auditor
sudo chage -l temp_auditor
sudo usermod --expiredate 2027-12-31 temp_auditor
```

**Tasks:** inspect expiry, change it, clear it, and explain the difference between account expiration and password aging.

```bash
sudo usermod --expiredate '' temp_auditor
sudo chage -l temp_auditor
```

Use only a disposable test account. Never expire the Vagrant access account.
