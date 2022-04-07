#!/bin/bash
docker-compose -f jenkins-docker-compose.yml up -d --build
echo "jenkins password is:"
docker exec jenkins bash -c "cat /var/jenkins_home/secrets/initialAdminPassword"
