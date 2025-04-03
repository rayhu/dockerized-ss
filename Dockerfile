FROM python:3.11-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    shadowsocks-libev \
    cron \
    supervisor \
    curl \
    bash \
    netcat-traditional \
    net-tools \
    && pip install gfwlist2pac \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories and set permissions
RUN mkdir -p /app/config /var/log/supervisor /var/run && \
    chmod 755 /var/log/supervisor /var/run

WORKDIR /app

# Add volume for external config file
VOLUME ["/app/config"]

# Copy scripts and config files
COPY scripts/generate_pac.sh /app/generate_pac.sh
COPY scripts/update_pac_cron.sh /app/update_pac_cron.sh
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set execute permissions
RUN chmod +x /app/*.sh

# Setup crontab
RUN echo "0 */6 * * * /app/update_pac_cron.sh >> /var/log/cron.log 2>&1" | crontab -

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]