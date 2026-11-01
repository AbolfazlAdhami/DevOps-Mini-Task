# Scenario 05 — Cron

**Objective:** Schedule and verify a harmless recurring task.

```bash
sudo -u trainee1 crontab -e
sudo -u trainee1 crontab -l
systemctl status cron --no-pager
```

Temporary test entry:

```cron
*/5 * * * * /usr/local/bin/lab-cron-check >> /home/trainee1/cron.log 2>&1
```

Verify the log, then remove the temporary entry. Use absolute paths.
