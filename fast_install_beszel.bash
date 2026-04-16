#!/usr/bin/env bash
set -euo pipefail

# ── 1. Install Docker ──────────────────────────────────────────────────────────
echo "[1/5] Installing Docker..."
sudo curl -fsSL https://get.docker.com | sh

# ── 2. Create working directory ────────────────────────────────────────────────
echo "[2/5] Creating /opt/beszel-agent..."
sudo mkdir -p /opt/beszel-agent
cd /opt/beszel-agent

# ── 3. Write docker-compose.yml ───────────────────────────────────────────────
echo "[3/5] Writing docker-compose.yml..."
sudo tee docker-compose.yml > /dev/null <<'EOF'
services:
  beszel-agent:
    image: henrygd/beszel-agent
    container_name: beszel-agent
    restart: unless-stopped
    network_mode: host
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./beszel_agent_data:/var/lib/beszel-agent
      # monitor other disks / partitions by mounting a folder in /extra-filesystems
      # - /mnt/disk/.beszel:/extra-filesystems/sda1:ro
    environment:
      LISTEN: 45876
      KEY: 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdpCVYSgRb45C0h1LnYOD9Eq0OzbDVu1suJjIi03Tyw'
      TOKEN: dba95-20c04463-ee03a-e0681e898
      HUB_URL: http://beszel.my-elix.online:8090
EOF

# ── 4. Create data directory ───────────────────────────────────────────────────
echo "[4/5] Creating data directory..."
sudo mkdir -p /opt/beszel-agent/beszel_agent_data
sudo chmod 755 /opt/beszel-agent/beszel_agent_data

# ── 5. Start the container and follow logs ─────────────────────────────────────
echo "[5/5] Starting beszel-agent..."
sudo docker compose up -d
sudo docker compose logs -f -t
