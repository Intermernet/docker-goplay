__Dockerfile to install Go and run the Go Playground__

Installs Go and OpenSSH. Root password is randomly generated.

Example usage:

Build the Dockerfile:

    docker build -t docker-goplay github.com/Intermernet/docker-goplay

Towards the end of the output it will display the randomly generated root password for the Docker image. _*Be sure to record this somewhere!*_.

Run the image:

    docker run -d -t -i -h "host.name" -p 2222:22 -p 9090:9090 docker-goplay

This will force the ports to be NATed as SSH on Docker host port 2222 and HTTP on Docker host port 9090.

You should then be able to connect to the HTTP port and use the Go Playground..

If the HTTP port is not NATed to port 80 on the Docker host, you may need some proxying (haproxy or nginx) to configure Magento correctly due to Magento's page rewrite rules, as well as the various `url` variables in the configuration db tables. *This is outside the scope of this README!*

You should also be able to connect to the instance via SSH using root and the password recorded earlier.

Very loosely based on [dmahlow/docker-magento](https://github.com/dmahlow/docker-magento). I'm still using his Apache virtual host config as it works  perfectly.
