#!/bin/bash
# Working directory must contain docker-compose.yml
docker compose pull
docker compose up -d --force-recreate
