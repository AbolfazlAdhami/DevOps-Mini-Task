# Django Development Environment with Vagrant

This project provides a ready-to-use development environment for Django with MySQL using VirtualBox.

## 🛠 Prerequisites

- [Vagrant](https://www.vagrantup.com/) installed
- [VirtualBox](https://www.virtualbox.org/) installed
- Minimum 2GB RAM and 2 CPU

## 🚀 Setting up the Environment

1. Navigate to the project directory in your terminal:

```bash
cd django-vagrant
```

2. Bring up the virtual machine:

```bash
vagrant up --provider=virtualbox
```

3. After provisioning completes:

- Django project is available in `./django-project` on your host system
- Site URL: [http://localhost:8000](http://localhost:8000)
- Admin panel: [http://localhost:8000/admin](http://localhost:8000/admin)

  - Username: `admin`
  - Password: `123`

- MySQL running on port 3307:

  - Username: `root`
  - Password: `rootpassword`

## 🔄 Managing the VM

- Stop the VM:

```bash
vagrant halt
```

- Destroy the VM (remove all virtual environment data):

```bash
vagrant destroy -f
```

- SSH into the VM:

```bash
vagrant ssh
```

## 📝 Notes

- The project is created inside `./django-project` and is accessible from your host system.
- All required packages (Django, mysqlclient, Python) are installed automatically.
- Django server starts automatically on boot, logs are saved to `./django.log`.
