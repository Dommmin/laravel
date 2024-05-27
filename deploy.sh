#!/bin/bash

set -e

cd /root

# Shutdown and remove orphaned containers
sudo docker compose -f docker-compose.prod.yml down

# Start services
sudo docker compose -f docker-compose.prod.yml up -d --remove-orphans

# Cache configurations
sudo docker compose -f docker-compose.prod.yml exec -T php php artisan config:cache
sudo docker compose -f docker-compose.prod.yml exec -T php php artisan route:cache
sudo docker compose -f docker-compose.prod.yml exec -T php php artisan view:cache

# Run migrations
sudo docker compose -f docker-compose.prod.yml exec -T php php artisan migrate --force
