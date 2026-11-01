# Scenario 01 — Users and shells

**Objective:** Distinguish interactive human accounts from service accounts.

**Tasks**
1. Inspect `/etc/shells`.
2. Create an interactive user with `/bin/bash`.
3. Create a service user with `/usr/sbin/nologin`.
4. Inspect both entries with `getent passwd`.
5. Test interactive login to the service user.
6. Explain why `nologin` does not prevent a service process from running under that UID.

**Commands**

```bash
cat /etc/shells
sudo useradd -m -s /bin/bash trainee1
sudo useradd --system -m -s /usr/sbin/nologin deploy_bot
getent passwd trainee1 deploy_bot
id trainee1
sudo su - deploy_bot
```

**Verification:** the interactive user has a valid login shell; the service account refuses an interactive login.

**Cleanup**

```bash
sudo userdel -r trainee1
sudo userdel -r deploy_bot
```
