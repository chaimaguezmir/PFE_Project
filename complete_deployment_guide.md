# Complete Spring Boot Deployment Guide - OxaHost VPS

## Table of Contents
1. [Server Information](#server-information)
2. [Initial System Setup](#initial-system-setup)
3. [Java Installation](#java-installation)
4. [Database Setup (Docker MySQL)](#database-setup-docker-mysql)
5. [Additional Tools Installation](#additional-tools-installation)
6. [Application Directory Setup](#application-directory-setup)
7. [Spring Boot Application Deployment](#spring-boot-application-deployment)
8. [Production Configuration](#production-configuration)
9. [Database Migration](#database-migration)
10. [Application Testing](#application-testing)
11. [Systemd Service Setup](#systemd-service-setup)
12. [Nginx Reverse Proxy](#nginx-reverse-proxy)
13. [Firewall Configuration](#firewall-configuration)
14. [Final Testing](#final-testing)
15. [Maintenance Commands](#maintenance-commands)
16. [Troubleshooting](#troubleshooting)

---

## Server Information

- **VPS Provider**: OxaHost
- **Server**: srv203017
- **OS**: Ubuntu 20.04.6 LTS (Focal Fossa)
- **RAM**: 16GB
- **Storage**: 158GB (138GB free)
- **Public IP**: 102.219.178.221
- **Application Port**: 8085
- **Web Access Port**: 80 (via Nginx)

---

## 1. Initial System Setup

### 1.1 Connect to VPS
```bash
ssh root@102.219.178.221
```

### 1.2 System Information Check
```bash
# Check OS version
cat /etc/os-release

# Check system resources
free -h
df -h

# List current directory
ls -la
```

**Expected Results:**
- Ubuntu 20.04.6 LTS
- 16GB RAM available
- 158GB storage with 138GB free

---

## 2. Java Installation

### 2.1 Update System Packages
```bash
apt update && apt upgrade -y
```

### 2.2 Install Java 17
```bash
# Install OpenJDK 17
apt install openjdk-17-jdk -y

# Verify installation
java -version
javac -version
```

**Expected Output:**
```
openjdk version "17.0.15" 2023-10-17
```

---

## 3. Database Setup (Docker MySQL)

### 3.1 Install Docker
```bash
# Install Docker
apt update
apt install docker.io -y

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Verify Docker status
systemctl status docker
```

### 3.2 Create MySQL Container
```bash
# Create MySQL container with database and user
docker run --name mysql-afya \
  -e MYSQL_ROOT_PASSWORD=RootPass123! \
  -e MYSQL_DATABASE=afya \
  -e MYSQL_USER=afya_user \
  -e MYSQL_PASSWORD=AfyaPass123! \
  -p 3306:3306 \
  -d mysql:8.0

# Wait for MySQL to initialize
sleep 30

# Check if container is running
docker ps

# Check container logs
docker logs mysql-afya
```

### 3.3 Test Database Connection
```bash
# Test connection with afya_user
docker exec -it mysql-afya mysql -u afya_user -pAfyaPass123! -e "SELECT 1;"

# Expected output:
# +---+
# | 1 |
# +---+
# | 1 |
# +---+
```

### 3.4 Database Configuration Details
- **Container Name**: mysql-afya
- **Database**: afya
- **Root Password**: RootPass123!
- **Application User**: afya_user
- **Application Password**: AfyaPass123!
- **Port**: 3306 (exposed to host)

---

## 4. Additional Tools Installation

### 4.1 Install Web Server and Development Tools
```bash
# Install Nginx and development tools
apt install nginx unzip wget curl nano git maven -y

# Start and enable Nginx
systemctl start nginx
systemctl enable nginx

# Check Nginx status
systemctl status nginx
```

---

## 5. Application Directory Setup

### 5.1 Create Application Directory
```bash
# Create application directory
mkdir -p /opt/afya
cd /opt/afya

# Create logs directory
mkdir logs

# Set proper permissions
chmod 755 /opt/afya

# Verify directory structure
ls -la /opt/afya
```

---

## 6. Spring Boot Application Deployment

### 6.1 Upload JAR File (from local machine)

**On your local machine:**
```bash
# Build the JAR file
cd /path/to/your/afya-project
./mvnw clean package -DskipTests

# Upload to VPS
scp target/afya-0.0.1-SNAPSHOT.jar root@102.219.178.221:/opt/afya/afya.jar
```

### 6.2 Verify Upload
```bash
# On VPS - Check if JAR file was uploaded
ls -la /opt/afya/
ls -lh /opt/afya/afya.jar
```

---

## 7. Production Configuration

### 7.1 Create Production Properties File
```bash
# Create production configuration
cat > /opt/afya/application-prod.properties << 'EOF'
# Server configuration
server.port=8080

# Docker MySQL configuration
spring.datasource.url=jdbc:mariadb://localhost:3306/afya?serverTimezone=UTC
spring.datasource.username=afya_user
spring.datasource.password=AfyaPass123!
spring.datasource.driver-class-name=org.mariadb.jdbc.Driver

# JPA settings
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.open-in-view=false

# JWT settings
afya.app.jwtSecret=oxahost-very-long-production-secret-key-minimum-32-characters-secure
afya.app.jwtExpirationMs=86400000
afya.app.jwtRefreshExpirationMs=604800000
afya.app.resetPasswordTokenExpirationMs=3600000

# Email configuration (UPDATE WITH YOUR DETAILS)
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your-email@gmail.com
spring.mail.password=your-gmail-app-password
afya.app.activation.from=your-email@gmail.com
afya.app.logo-url=http://102.219.178.221/logo.png

# Logging
logging.level.root=WARN
logging.level.com.idvey.afya=INFO
logging.file.name=/opt/afya/logs/application.log
logging.file.max-size=10MB
logging.file.max-history=5
EOF
```

### 7.2 Update Email Configuration
```bash
# Edit the configuration file to add your email credentials
nano /opt/afya/application-prod.properties

# Replace:
# - your-email@gmail.com with your actual Gmail
# - your-gmail-app-password with your Gmail app password
```

---

## 8. Database Migration (Optional)

### 8.1 Export Local Database (if you have data to migrate)

**On your local machine:**
```bash
# Export local database (if available)
mysqldump -u root -p afya > afya_backup.sql

# Upload to VPS
scp afya_backup.sql root@102.219.178.221:/tmp/
```

### 8.2 Import to Docker MySQL
```bash
# On VPS - Import to Docker MySQL
docker exec -i mysql-afya mysql -u afya_user -pAfyaPass123! afya < /tmp/afya_backup.sql

# Verify import
docker exec -it mysql-afya mysql -u afya_user -pAfyaPass123! afya -e "SHOW TABLES;"

# Clean up backup file
rm /tmp/afya_backup.sql
```

---

## 9. Application Testing

### 9.1 Test Run Application
```bash
# Test run the application
cd /opt/afya
java -jar -Dspring.profiles.active=prod -Dspring.config.location=classpath:/application.properties,file:/opt/afya/application-prod.properties afya.jar
```

**Expected Output:**
```
:: Spring Boot ::                (v3.4.5)

2025-09-09T12:58:37.564Z  INFO 1246470 --- [afya] [           main] com.idvey.afya.AfyaApplication           : Starting AfyaApplication v0.0.1-SNAPSHOT using Java 17.0.15
2025-09-09T12:58:37.568Z  INFO 1246470 --- [afya] [           main] com.idvey.afya.AfyaApplication           : The following 1 profile is active: "prod"
2025-09-09T12:58:50.159Z  INFO 1246470 --- [afya] [           main] com.idvey.afya.AfyaApplication           : Started AfyaApplication in 13.421 seconds
```

**Press Ctrl+C to stop after successful test**

---

## 10. Systemd Service Setup

### 10.1 Create Service File
```bash
# Create systemd service file
cat > /etc/systemd/system/afya.service << 'EOF'
[Unit]
Description=Afya Spring Boot Application
After=network.target docker.service

[Service]
Type=simple
User=root
WorkingDirectory=/opt/afya
ExecStart=/usr/bin/java -jar -Dspring.profiles.active=prod -Dspring.config.location=classpath:/application.properties,file:/opt/afya/application-prod.properties /opt/afya/afya.jar
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
```

### 10.2 Enable and Start Service
```bash
# Reload systemd and enable the service
systemctl daemon-reload
systemctl enable afya
systemctl start afya

# Check service status
systemctl status afya

# Check if application is running on port
netstat -tlnp | grep 8085
```

---

## 11. Nginx Reverse Proxy

### 11.1 Create Nginx Configuration
```bash
# Create Nginx site configuration
cat > /etc/nginx/sites-available/afya << 'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8085;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
EOF
```

### 11.2 Enable Site and Restart Nginx
```bash
# Enable the site
ln -s /etc/nginx/sites-available/afya /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
nginx -t

# Restart Nginx
systemctl restart nginx

# Check Nginx status
systemctl status nginx
```

---

## 12. Firewall Configuration

### 12.1 Install and Configure UFW
```bash
# Install UFW firewall
apt install ufw -y

# Allow necessary ports
ufw allow ssh
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 8085

# Enable firewall
ufw --force enable

# Check firewall status
ufw status
```

**Expected Output:**
```
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
8085/tcp                   ALLOW       Anywhere
```

---

## 13. Final Testing

### 13.1 Remote Access URLs

**Your application is now accessible at:**
- **Direct API Access**: `http://102.219.178.221:8085/api/auth/signin`
- **Swagger UI**: `http://102.219.178.221:8085/swagger-ui/index.html`
- **Via Nginx (Port 80)**: `http://102.219.178.221/swagger-ui/index.html`
- **Health Check**: `http://102.219.178.221:8085/actuator/health`

### 13.2 Test API Endpoints

**Create a test user:**
```bash
curl -X POST http://102.219.178.221:8085/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "email": "admin@example.com",
    "password": "Password123!",
    "firstName": "Admin",
    "lastName": "User"
  }'
```

**Test sign-in:**
```bash
curl -X POST http://102.219.178.221:8085/api/auth/signin \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "password": "Password123!"
  }'
```

---

## 14. Maintenance Commands

### 14.1 Service Management
```bash
# Check application status
systemctl status afya

# View application logs
journalctl -u afya -f

# Restart application
systemctl restart afya

# Stop application
systemctl stop afya

# Start application
systemctl start afya
```

### 14.2 Docker MySQL Management
```bash
# Check MySQL container status
docker ps

# View MySQL logs
docker logs mysql-afya

# Restart MySQL container
docker restart mysql-afya

# Connect to MySQL
docker exec -it mysql-afya mysql -u afya_user -pAfyaPass123!

# Start MySQL container
docker start mysql-afya

# Stop MySQL container
docker stop mysql-afya
```

### 14.3 System Monitoring
```bash
# Check system resources
free -h
df -h

# Check running processes
ps aux | grep java

# Check network connections
netstat -tlnp | grep -E "(80|8085|3306)"

# Check disk usage
du -sh /opt/afya/

# Check log file size
ls -lh /opt/afya/logs/
```

### 14.4 Application Updates
```bash
# To update the application:
# 1. Upload new JAR file
scp target/afya-new-version.jar root@102.219.178.221:/opt/afya/afya.jar

# 2. Restart the service
systemctl restart afya

# 3. Check logs
journalctl -u afya -f
```

---

## 15. Troubleshooting

### 15.1 Application Won't Start
```bash
# Check detailed logs
journalctl -u afya -n 50

# Check if port is already in use
netstat -tlnp | grep 8085

# Check database connection
docker exec -it mysql-afya mysql -u afya_user -pAfyaPass123! -e "SELECT 1;"

# Check configuration file
cat /opt/afya/application-prod.properties
```

### 15.2 Can't Access Remotely
```bash
# Check if application is running
systemctl status afya

# Check firewall
ufw status

# Check if ports are listening
netstat -tlnp | grep -E "(80|8085)"

# Check Nginx status
systemctl status nginx
nginx -t
```

### 15.3 Database Issues
```bash
# Check MySQL container
docker ps
docker logs mysql-afya

# Test database connection
docker exec -it mysql-afya mysql -u afya_user -pAfyaPass123! afya -e "SHOW TABLES;"

# Restart MySQL container
docker restart mysql-afya
```

### 15.4 Common Error Solutions

**Error: "Cannot load driver class: com.mysql.cj.jdbc.Driver"**
- Solution: Use `org.mariadb.jdbc.Driver` in configuration

**Error: "Access denied for user"**
- Solution: Check MySQL credentials in application-prod.properties

**Error: "Port already in use"**
- Solution: Check what's using the port with `netstat -tlnp | grep 8085`

**Error: "Connection refused"**
- Solution: Check firewall settings and ensure application is running

---

## 16. Production Security Recommendations

### 16.1 Security Enhancements
```bash
# Change default passwords
# Update JWT secret to a strong, unique value
# Set up SSL/TLS with Let's Encrypt
# Configure fail2ban for SSH protection
# Regular system updates
# Monitor logs for suspicious activity
```

### 16.2 Backup Strategy
```bash
# Create database backup script
cat > /opt/afya/backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/opt/afya/backups"
mkdir -p $BACKUP_DIR

# Backup database
docker exec mysql-afya mysqldump -u afya_user -pAfyaPass123! afya > $BACKUP_DIR/afya_db_$DATE.sql

# Backup application files
tar -czf $BACKUP_DIR/afya_app_$DATE.tar.gz /opt/afya --exclude='/opt/afya/backups'

# Remove backups older than 7 days
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed: $DATE"
EOF

# Make script executable
chmod +x /opt/afya/backup.sh

# Add to crontab for daily backups at 2 AM
echo "0 2 * * * /opt/afya/backup.sh" | crontab -
```

---

## 17. Summary

### ✅ What We Accomplished

1. **✅ Server Setup**: Ubuntu 20.04 LTS with 16GB RAM
2. **✅ Java 17**: Installed and configured
3. **✅ Docker MySQL**: Running in container with proper database
4. **✅ Spring Boot App**: Successfully deployed and running
5. **✅ Production Config**: Optimized for production environment
6. **✅ Systemd Service**: Auto-starts on boot
7. **✅ Nginx Proxy**: Web server with reverse proxy
8. **✅ Firewall**: Configured for security
9. **✅ Remote Access**: Accessible from internet

### 🌐 Access Points

- **Main Application**: http://102.219.178.221:8085
- **Web Access**: http://102.219.178.221 (via Nginx)
- **Swagger UI**: http://102.219.178.221:8085/swagger-ui/index.html
- **API Base**: http://102.219.178.221:8085/api/

### 📊 System Resources

- **RAM Usage**: ~300MB (plenty of room for growth)
- **Disk Usage**: ~14GB used of 158GB
- **Database**: Docker MySQL 8.0 with dedicated user
- **Uptime**: Managed by systemd with auto-restart

### 🔧 Key Configuration Files

- **Application**: `/opt/afya/afya.jar`
- **Configuration**: `/opt/afya/application-prod.properties`
- **Service**: `/etc/systemd/system/afya.service`
- **Nginx**: `/etc/nginx/sites-available/afya`
- **Logs**: `/opt/afya/logs/application.log`

---

**🎉 Your Afya Medicine Management System is now fully deployed and operational!**

*Last Updated: September 9, 2025*
*Server: srv203017 (OxaHost)*
*Public IP: 102.219.178.221*