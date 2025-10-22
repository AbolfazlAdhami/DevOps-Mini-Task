#!/usr/bin/env bash
set -e

echo "🔄 Updating system..."
apt-get update -y
apt-get upgrade -y

echo "🐍 Installing Python, pip, git, and MySQL..."
apt-get install -y python3 python3-pip python3-venv git mysql-server

echo "🔐 Configuring MySQL root password..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'rootpassword';"
mysql -e "FLUSH PRIVILEGES;"
mysql -u root -prootpassword -e "CREATE DATABASE IF NOT EXISTS django_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"

PROJECT_DIR="/vagrant/django-project"
if [ ! -f "$PROJECT_DIR/manage.py" ]; then
  echo "📁 Creating Django project in $PROJECT_DIR ..."
  sudo -u vagrant mkdir -p "$PROJECT_DIR"
  cd "$PROJECT_DIR"
  sudo -u vagrant python3 -m venv venv
  sudo -u vagrant ./venv/bin/pip install --upgrade pip
  sudo -u vagrant ./venv/bin/pip install django mysqlclient
  sudo -u vagrant ./venv/bin/django-admin startproject myproject .
fi

SETTINGS_FILE="$PROJECT_DIR/myproject/settings.py"

# Configure database settings for MySQL
sed -i "/DATABASES = {/,\$d" "$SETTINGS_FILE"
cat <<'EOF' >> "$SETTINGS_FILE"
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'django_db',
        'USER': 'root',
        'PASSWORD': 'rootpassword',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
EOF

echo "⚙️ Running Django migrations..."
cd "$PROJECT_DIR"
sudo -u vagrant ./venv/bin/python manage.py migrate --noinput

echo "👤 Creating superuser (admin / 123)..."
sudo -u vagrant ./venv/bin/python manage.py shell <<'PYCODE'
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username="admin").exists():
    User.objects.create_superuser("admin", "admin@example.com", "123")
PYCODE

echo "🚀 Setting up Django auto-start..."
cat > /home/vagrant/start-django.sh <<'EOF'
#!/bin/bash
cd /vagrant/django-project
source venv/bin/activate
nohup python manage.py runserver 0.0.0.0:8000 > /vagrant/django.log 2>&1 &
EOF

chmod +x /home/vagrant/start-django.sh
sudo -u vagrant /home/vagrant/start-django.sh

echo "===================================================="
echo " Django environment ready!"
echo " URL: http://localhost:8000"
echo " Admin: http://localhost:8000/admin (admin / 123)"
echo " MySQL: localhost:3307 (root / rootpassword)"
echo " Project Folder: ./django-project"
echo "===================================================="
