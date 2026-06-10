# Deployment Guide

> Step-by-step guide to deploy an AI-generated web application to a VPS or AWS EC2 instance.

---

## Prerequisites

- A VPS or AWS EC2 instance (Ubuntu 22.04+ recommended)
- A registered domain name pointing to your server's IP
- SSH access to the server
- Your project repository (GitHub, GitLab, or zip file)

---

## Phase 1 — Server Setup

### 1.1 Connect to Your Server

```bash
ssh -i your-key.pem ubuntu@your-server-ip
```

### 1.2 Update System Packages

```bash
sudo apt update && sudo apt upgrade -y
```

### 1.3 Install Docker & Docker Compose

```bash
# Install Docker
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER

# Install Docker Compose plugin
sudo apt install docker-compose-plugin -y

# Verify installation
docker --version
docker compose version

# Log out and back in for group changes to take effect
exit
```

### 1.4 Install Certbot (for SSL)

```bash
sudo apt install certbot -y
```

### 1.5 Configure Firewall

```bash
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw enable
sudo ufw status
```

---

## Phase 2 — Project Setup

### 2.1 Clone or Upload Your Project

```bash
# Option A: Clone from GitHub
git clone https://github.com/your-username/your-project.git
cd your-project

# Option B: Upload via SCP
scp -i your-key.pem -r ./your-project ubuntu@your-server-ip:~/
```

### 2.2 Configure Environment Variables

```bash
cp .env.example .env
nano .env
```

**Critical variables to set:**

```env
NODE_ENV=production
PORT=3000
DATABASE_URL=your-database-connection-string
# Add all project-specific variables
```

### 2.3 Verify Local Build (on server)

```bash
docker compose build
```

If the build fails, check:
- Missing environment variables
- Incorrect Node.js version in Dockerfile
- Missing system dependencies

---

## Phase 3 — SSL Certificate

### 3.1 Obtain SSL Certificate

> **Important**: Before running Certbot, ensure your domain's DNS A record points to your server's IP address. DNS propagation may take up to 48 hours.

```bash
# Stop any service using port 80
sudo systemctl stop nginx 2>/dev/null || true

# Obtain certificate
sudo certbot certonly --standalone \
  -d yourdomain.com \
  -d www.yourdomain.com \
  --non-interactive \
  --agree-tos \
  -m your-email@example.com
```

### 3.2 Set Up Auto-Renewal

```bash
# Test renewal
sudo certbot renew --dry-run

# Certbot auto-renewal is enabled by default via systemd timer
sudo systemctl status certbot.timer
```

---

## Phase 4 — Deploy

### 4.1 Update Nginx Configuration

Edit `nginx.conf` and replace placeholder values:

```bash
# Replace these in nginx.conf:
# - yourdomain.com → your actual domain
# - upstream port if your app doesn't use 3000
```

### 4.2 Start All Services

```bash
docker compose up -d
```

### 4.3 Verify Deployment

```bash
# Check container status
docker compose ps

# Check application logs
docker compose logs -f app

# Test HTTP → HTTPS redirect
curl -I http://yourdomain.com

# Test HTTPS
curl -I https://yourdomain.com
```

### 4.4 Verify in Browser

Open `https://yourdomain.com` and check:
- [ ] Page loads without errors
- [ ] SSL certificate is valid (padlock icon)
- [ ] All assets load correctly (images, CSS, JS)
- [ ] API endpoints respond correctly
- [ ] No console errors in browser DevTools

---

## Phase 5 — Post-Deployment

### 5.1 Set Up Log Rotation

```bash
# Docker handles log rotation via daemon.json
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF
sudo systemctl restart docker
```

### 5.2 Set Up Basic Monitoring

```bash
# Check disk space
df -h

# Check memory usage
free -m

# Check running containers
docker compose ps

# Check container resource usage
docker stats --no-stream
```

### 5.3 Create a Restart Script

```bash
cat > ~/restart-app.sh << 'EOF'
#!/bin/bash
cd ~/your-project
docker compose down
docker compose up -d --build
echo "Application restarted at $(date)"
EOF
chmod +x ~/restart-app.sh
```

---

## Updating the Application

### Manual Update

```bash
cd ~/your-project
git pull origin main
docker compose down
docker compose up -d --build
```

### Via GitHub Actions (Automated)

See `.github/workflows/deploy.yml` — pushes to `main` branch trigger automatic deployment.

---

## Troubleshooting

### Container won't start

```bash
docker compose logs app          # Check app logs
docker compose logs nginx        # Check nginx logs
docker compose config            # Validate compose file
```

### Port already in use

```bash
sudo lsof -i :80                 # Find process using port 80
sudo lsof -i :443                # Find process using port 443
sudo systemctl stop apache2      # Stop Apache if running
```

### SSL certificate issues

```bash
sudo certbot certificates        # List certificates
sudo certbot renew --force-renewal  # Force renewal
```

### Out of disk space

```bash
docker system prune -a           # Remove unused images/containers
docker volume prune              # Remove unused volumes
df -h                            # Check available space
```

### Application crashes on startup

```bash
# Run without detach to see real-time logs
docker compose up --build

# Common causes:
# - Missing environment variables
# - Database not reachable
# - Port conflicts
# - Memory limits exceeded
```

---

## Security Checklist

- [ ] SSH key authentication enabled (password auth disabled)
- [ ] Firewall configured (only 22, 80, 443 open)
- [ ] SSL certificate installed and auto-renewing
- [ ] Environment variables not committed to git
- [ ] Docker containers run as non-root user
- [ ] Regular system updates scheduled
- [ ] Application logs are rotated

---

## Handoff Notes

After deployment, provide the client with:

1. **Server access**: SSH connection details or console access
2. **Deployment URL**: `https://yourdomain.com`
3. **Environment variables**: Location of `.env` file
4. **Update process**: How to deploy new changes
5. **Restart command**: `~/restart-app.sh`
6. **Log access**: `docker compose logs -f app`
7. **SSL renewal**: Automatic via Certbot timer
8. **Cost**: Monthly server cost estimate
