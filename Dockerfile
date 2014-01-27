# Go language runtime, Go playground application and SSHd installation
#
# Go playground listens on port 9090.

# Use Ubuntu 12.04 as base image
FROM ubuntu:precise

MAINTAINER Mike Hughes, intermernet@gmail.com

# Create a random password for root and save to "/root/pw.txt"
RUN  < /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-12} > /root/pw.txt

# Change the root password
RUN echo "root:$(cat /root/pw.txt)" | chpasswd

# Update package lists
RUN apt-get update -q

# Install OpenSSHd
RUN apt-get install -qy openssh-server build-essential curl git

# Install Go source
RUN curl -s https://go.googlecode.com/files/go1.2.src.tar.gz | tar -v -C /usr/local -xz

# Build Go from source
RUN cd /usr/local/go/src && ./make.bash --no-clean 2>&1

# Go binary path to PATH
ENV PATH /usr/local/go/bin:$PATH

# Build the Go Playground application
RUN bash -c "cd /root/ && go build /usr/local/go/misc/goplay/goplay.go"

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
