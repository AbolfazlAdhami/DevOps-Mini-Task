# Linux `useradd` & `groupadd` Cheatsheet

این فایل یک مرور سریع از پرکاربردترین فلگ‌های دستورات `useradd` و `groupadd` است.

---

## `useradd`

```
useradd [OPTIONS] USERNAME
```

### Options
- `-c "Comment"` → توضیحات برای کاربر ساخته شده  
- `-m` → ساخت دایرکتوری Home اگر وجود نداشته باشد  
- `-d /path/to/home` → مشخص کردن مسیر دایرکتوری Home  
- `-s /bin/bash` → تعیین Shell لاگین  
- `-M` → دایرکتوری Home ساخته نشود  
- `-G group1,group2` → اضافه کردن کاربر به گروه‌های مشخص  
- `-u UID` → تعیین User ID اختصاصی  
- `-e YYYY-MM-DD` → تاریخ انقضا برای حساب کاربری  
- `-f days` → تعداد روز پس از انقضا تا غیرفعال شدن حساب  
- `-r` → ساخت حساب سیستمی (بدون login shell و تاریخ انقضا)  
- `-p PASSWORD` → تنظیم پسورد رمزنگاری‌شده (معمولاً همراه با `passwd` استفاده می‌شود)  

---

## `groupadd`

```
groupadd [OPTIONS] GROUPNAME
```

### Options
- `-g GID` → تعیین Group ID اختصاصی  
- `-r` → ساخت گروه سیستمی  
- `-f` → اگر گروه از قبل وجود داشته باشد تغییری ایجاد نمی‌کند  
- `-K KEY=VALUE` → override کردن تنظیمات `/etc/login.defs`  

---

## Examples

```bash
# ایجاد یک کاربر عادی با home و دسترسی bash
useradd -m -s /bin/bash -g developer -G sudo user1
passwd user1

# ایجاد کاربر سیستمی بدون home و بدون امکان login
useradd -r -M -s /usr/sbin/nologin backupuser

# ایجاد گروه با GID مشخص
groupadd -g 1500 devops
```

---

✅ با این فایل می‌تونی به راحتی فلگ‌های مهم `useradd` و `groupadd` رو مرور کنی.
