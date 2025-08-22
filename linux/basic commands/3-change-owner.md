# How to change owner in nested directory ( flag recursive ) 

```bash
ls -l /var/www/project
sudo chown -R user:Developer /var/www/project
```

# verify and check changes 
```bash
ls -l /var/www/project

#change only group
sudo chprg -R Developer /var/www/project

#change only owner (keep group)
sudo chown -R abolfazl /var/www/project

# if want verify without changing use --dry-run flage:
sudo chown -R --dry-run abolfazl:Developer /var/www/project
```