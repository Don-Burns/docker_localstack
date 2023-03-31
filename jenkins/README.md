# How to Use
To start the container run `start.sh`.  The password needed to login will be printed to the console once the container is running.
Go to localhost:8080 and enter the password.  Then either select the plugins you want or use default if you don't have specific needs.
Wait for it to build and then you can use Jenkins as needed.  The `mnt` folder is attached inside the container at `/var/jenkins_home/mnt`, so if you want to refer to this folder's contents use `file:///var/jenkins_home/mnt` with the jenkins pipeline config in the repo url field.