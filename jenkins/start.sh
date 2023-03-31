#!/bin/bash
docker-compose -f jenkins-docker-compose.yml up -d --build
sleep 5
echo "jenkins user is:"
docker exec jenkins bash -c "echo \$JENKINS_USER"
echo "jenkins password is:"
docker exec jenkins bash -c "echo \$JENKINS_PASS"
# this is for when I don't build it with a user and pass
# docker exec jenkins bash -c "cat /var/jenkins_home/secrets/initialAdminPassword"
