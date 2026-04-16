# 🚀 Гайд по запуску скриптов установки

Этот репозиторий содержит скрипты для быстрой установки сервисов на Linux сервер с использованием Docker.

---

## 📋 Доступные скрипты

| Скрипт | Назначение | Сервис |
|--------|-----------|--------|
| `fast_install_remnawave.bash` | Установка Remna Wave | remnawave/wave:latest |

---

## ✅ Требования перед запуском

- **ОС**: Linux (Ubuntu, Debian, CentOS и т.д.)
- **Прав доступа**: `sudo` привилегии
- **Интернет**: Стабильное подключение для загрузки Docker образов
- **Свободное место**: Минимум 5-10 ГБ свободного места на диске

---

## 🔧 Подготовка сервера

### 1. Подключитесь к серверу по SSH
```bash
ssh user@your_server_ip
```

### 2. Обновите систему (рекомендуется)
```bash
sudo apt update && sudo apt upgrade -y
```

### 3. Установите `curl` (если его нет)
```bash
sudo apt install curl -y
```

---

## 📥 Загрузка скриптов на сервер

### Вариант 1: Используя `curl` (рекомендуется)
```bash
cd /tmp
curl -O https://your_repo_url/fast_install_remnawave.bash

# Даем права на выполнение
chmod +x fast_install_*.bash
```

### Вариант 2: Используя `scp`
```bash
# На локальной машине:
scp fast_install_remnanode.bash user@your_server_ip:/tmp/
scp fast_install_remnawave.bash user@your_server_ip:/tmp/

# На сервере:
chmod +x /tmp/fast_install_*.bash
```

---

## 🚀 Запуск скриптов

### Важно!
⚠️ **Скрипты требуют `sudo` привилегии и будут запрашивать пароль.**

### Запуск Remna Node
```bash
sudo bash /tmp/fast_install_remnanode.bash
```

**Что делает скрипт:**
1. Устанавливает Docker
2. Создает директорию `/opt/remnanode`
3. Создает `docker-compose.yml` конфигурацию
4. Запускает контейнер в фоновом режиме
5. Выводит логи установки

**Результат:** Remna Node будет доступна на порту **2222**

---

### Запуск Remna Wave
```bash
sudo bash /tmp/fast_install_remnawave.bash
```

**Что делает скрипт:**
1. Устанавливает Docker
2. Создает директорию `/opt/remnanode` (для Wave)
3. Создает `docker-compose.yml` конфигурацию
4. Запускает контейнер
5. Выводит логи установки

---

## 🔍 Проверка статуса после установки

### Посмотреть запущенные контейнеры
```bash
sudo docker ps
```

### Просмотр логов контейнера
```bash
# Для Remna Node
sudo docker compose -f /opt/remnanode/docker-compose.yml logs -f

# Просмотр последних 100 строк логов
sudo docker compose -f /opt/remnanode/docker-compose.yml logs --tail 100
```

### Проверить статус контейнера
```bash
sudo docker compose -f /opt/remnanode/docker-compose.yml ps
```

---

## 🛑 Остановка и перезапуск сервисов

### Остановить контейнер
```bash
cd /opt/remnanode
sudo docker compose down
```

### Перезапустить контейнер
```bash
cd /opt/remnanode
sudo docker compose restart
```

### Полная переустановка (удаление контейнера)
```bash
cd /opt/remnanode
sudo docker compose down -v
sudo rm -rf /opt/remnanode
sudo bash /tmp/fast_install_remnanode.bash
```

---

## 🌐 Доступ к сервисам

После успешной установки, сервисы будут доступны по следующим адресам:

| Сервис | Адрес | Порт |
|--------|-------|------|
| Remna Node | `http://your_server_ip:2222` | 2222 |
| Remna Wave | `http://your_server_ip:PORT` | PORT (зависит от конфига) |

---

## ⚠️ Типичные проблемы и решения

### Проблема: "Permission denied"
```bash
# Решение: Убедитесь, что скрипт имеет права на выполнение
chmod +x /tmp/fast_install_remnanode.bash
```

### Проблема: "Docker command not found"
```bash
# Решение: Docker не установлен или нужно перезагрузиться
sudo apt install docker.io docker-compose -y
# или используйте официальный скрипт установки Docker
sudo curl -fsSL https://get.docker.com | sh
```

### Проблема: "Port already in use"
```bash
# Найти процесс, занимающий порт
sudo lsof -i :2222

# Или убить процесс по PID
sudo kill -9 PID
```

### Проблема: "Out of disk space"
```bash
# Проверить свободное место
df -h

# Очистить Docker кэш
sudo docker system prune -a
```

### Проблема: Контейнер не запускается
```bash
# Просмотреть подробные логи
sudo docker compose -f /opt/remnanode/docker-compose.yml logs

# Перезапустить Docker daemon
sudo systemctl restart docker
```

---

## 📝 Настройка после установки

### Изменение переменных окружения

Отредактируйте `docker-compose.yml` в соответствующей директории:

```bash
sudo nano /opt/remnanode/docker-compose.yml
```

Измените необходимые переменные в секции `environment:`, затем перезапустите контейнер:

```bash
cd /opt/remnanode
sudo docker compose down
sudo docker compose up -d
```

---

## 🔐 Безопасность

### Важные рекомендации:

1. **Secret Key**: Замените значение `SECRET_KEY` на собственное после установки
   ```bash
   sudo nano /opt/remnanode/docker-compose.yml
   # Измените значение SECRET_KEY
   sudo docker compose restart
   ```

2. **Firewall**: Откройте только необходимые порты
   ```bash
   # Для UFW
   sudo ufw allow 2222/tcp
   sudo ufw allow 22/tcp  # SSH
   ```

3. **Регулярные обновления**: Обновляйте Docker образы
   ```bash
   sudo docker pull remnawave/node:latest
   sudo docker compose pull
   sudo docker compose down
   sudo docker compose up -d
   ```

4. **Резервные копии**: Сохраняйте конфигурацию
   ```bash
   sudo cp -r /opt/remnanode ~/remnanode_backup
   ```

---

## 📞 Поддержка

Если вы столкнулись с проблемой:

1. Проверьте логи контейнера
2. Убедитесь, что сервер соответствует требованиям
3. Проверьте интернет-соединение
4. Попробуйте перезагрузить сервер: `sudo reboot`

---

## 📄 Лицензия

Убедитесь, что вы имеете право использовать эти скрипты и соответствующие сервисы.

---

**Версия**: 1.0  
**Дата обновления**: 16 апреля 2026  
**Автор**: Guvchick
