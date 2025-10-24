# Use a minimal base image with a package manager
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Add security and update repositories
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository "deb http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted universe multiverse"
RUN add-apt-repository "deb http://ports.ubuntu.com/ubuntu-ports jammy-updates main restricted universe multiverse"

# Update and install necessary packages. Pin versions for reproducibility.
RUN apt-get update && apt-get install -y \
    nginx=1.18.0-6ubuntu14.7 \
    curl=7.81.0-1ubuntu1.20 \
    net-tools=1.60+git20181103.0eebece-1ubuntu5.4 \
    openssl=3.0.2-0ubuntu1.19 \
    iptables=1.8.7-1ubuntu5.2 \
    python3-pip=22.0.2+dfsg-1ubuntu0.6 \
    python3-dev=3.10.6-1~22.04.1 \
    python3-setuptools=59.6.0-1.2ubuntu0.22.04.3 \
    libffi-dev=3.4.2-4 \
    zlib1g-dev=1:1.2.11.dfsg-2ubuntu9.2 \
    libssl-dev=3.0.2-0ubuntu1.19 \
    netcat-traditional=1.10-47 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add certificates and keys to a secure location
COPY ./certs/ /etc/ssl/
# Add the broken Nginx config
COPY ./nginx/default.conf /etc/nginx/sites-available/default
# Add the broken iptables rules
COPY ./iptables/rules.v4 /etc/iptables/rules.v4

# Configure Nginx to run
CMD ["nginx", "-g", "daemon off;"]

# Add only the necessary task files (tests, run-tests.sh, etc.)
COPY run-tests.sh /task-files/
COPY requirements.txt /task-files/
COPY task.yaml /task-files/
COPY tests/ /task-files/tests/
COPY README.md /task-files/

# Set the working directory to where the task files are located
WORKDIR /task-files