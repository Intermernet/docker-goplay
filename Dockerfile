# Go language runtime, Go playground application and SSHd installation
#
# Go Playground listens on port 9090.

# Use Ubuntu 12.04 as base image
FROM ubuntu:precise

MAINTAINER Mike Hughes, intermernet@gmail.com

# Create a random password for root and MySQL and save to "/root/pw.txt"
RUN  < /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-12} > /root/pw.txt

# Change the root password
RUN echo "root:$(cat /root/pw.txt)" | chpasswd

# Update package lists
RUN apt-get update

# Install the "add-apt-repository" utility
RUN apt-get install -y python-software-properties

# Add the Go PPA repository
RUN add-apt-repository -y ppa:gophers/go

# Update package list
RUN apt-get update

# Install packages
RUN apt-get install -y golang-stable openssh-server

# Build the Go Playground application
RUN bash -c "cd /root/ && go build /usr/lib/go/misc/goplay/goplay.go"

# Create the SSHd working directory
RUN mkdir /var/run/sshd

# Create "/root/run.sh" startup script
RUN bash -c "echo -e \"\x23\x21/bin/bash\n/root/goplay -http=\":9090\" \x26\n/usr/sbin/sshd -D \x26\nwait \x24\x7b\x21\x7d\n\" > /root/run.sh"

# Change "/root/run.sh" to be executable
RUN chmod +x /root/run.sh

# Display the password and delete "/root/pw.txt"
RUN bash -c "echo -e \"\n*********************************\nRecord the root Password\x21\";echo $(cat /root/pw.txt);echo -e \"*********************************\n\"; rm -f /root/pw.txt"

# Set the entry point to "/root/run.sh"
ENTRYPOINT ["/root/run.sh"]

# Expose SSH and HTTP ports
EXPOSE 22 9090

