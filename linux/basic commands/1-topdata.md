# Linux `top` Command Cheatsheet

The `top` command shows real-time information about system processes, CPU, memory, and load.

---

## System Summary (Top Section)

```
top - 01:19:07 up  5:26,  2 users,  load average: 0.35, 0.94, 1.26
```

- **up** → مدت زمان روشن بودن سیستم (uptime)  
- **users** → تعداد کاربران لاگین شده  
- **load average** → میانگین بار پردازنده در بازه‌های 1، 5 و 15 دقیقه اخیر  
  - `0.35` → بار CPU در 1 دقیقه اخیر  
  - `0.94` → بار CPU در 5 دقیقه اخیر  
  - `1.26` → بار CPU در 15 دقیقه اخیر  

---

## Tasks (Processes)

```
Tasks: 262 total,   1 running, 261 sleeping,   0 stopped,   0 zombie
```

- **total** → تعداد کل پردازش‌ها  
- **running** → در حال اجرا  
- **sleeping** → منتظر (idle/sleep)  
- **stopped** → متوقف‌شده  
- **zombie** → پردازش‌های تمام‌شده که پدرشان هنوز جمع‌آوری نکرده است  

---

## CPU Usage

```
%Cpu(s):  4.3 us,  3.1 sy,  1.4 ni, 87.8 id,  0.3 wa,  0.0 hi,  3.0 si,  0.0 st
```

- **us (user)** → درصد CPU مصرف‌شده برای برنامه‌های کاربر  
- **sy (system)** → درصد CPU مصرف‌شده در کرنل  
- **ni (nice)** → درصد CPU برای پردازش‌هایی با priority تغییر یافته  
- **id (idle)** → درصد بیکاری CPU  
- **wa (I/O wait)** → زمانی که CPU منتظر I/O (مثل دیسک/شبکه) است  
- **hi (hardware interrupts)** → زمان مصرف‌شده برای وقفه‌های سخت‌افزاری  
- **si (software interrupts)** → زمان مصرف‌شده برای وقفه‌های نرم‌افزاری  
- **st (steal)** → زمانی که VM منتظر CPU میزبان مانده است  

---

## Memory (RAM)

```
MiB Mem :   7211.6 total,   2536.5 free,   2136.0 used,   3289.6 buff/cache
```

- **total** → کل حافظه  
- **free** → حافظه آزاد  
- **used** → حافظه در حال استفاده  
- **buff/cache** → کش و بافر  

---

## Swap

```
MiB Swap:   4096.0 total,   4089.6 free,      6.4 used,   5075.6 avail Mem
```

- **total** → کل فضای swap  
- **free** → فضای swap آزاد  
- **used** → فضای swap استفاده‌شده  
- **avail Mem** → حافظه قابل دسترس  

---

## Process List (Per Task)

| Column   | Meaning |
|----------|---------|
| **PID**  | شماره پردازش (Process ID) |
| **USER** | کاربری که پردازش را اجرا کرده |
| **PR**   | Priority (عدد کمتر → اولویت بالاتر) |
| **NI**   | Niceness مقدار بین -20 تا 19 |
| **VIRT** | حافظه مجازی رزرو شده |
| **RES**  | حافظه فیزیکی واقعی استفاده‌شده |
| **SHR**  | حافظه اشتراکی با دیگر تسک‌ها |
| **S**    | وضعیت پردازش (R=Running, S=Sleeping, T=Stopped, Z=Zombie) |
| **%CPU** | درصد استفاده پردازش از CPU |
| **%MEM** | درصد استفاده پردازش از RAM |
| **TIME+**| کل زمان CPU مصرف‌شده |
| **COMMAND** | نام/دستور اجرا شده |
