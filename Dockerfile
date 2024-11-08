# Start with the official GitLab Runner image
FROM gitlab/gitlab-runner:latest

# Install Docker dependencies
RUN apt-get update
RUN apt-get install gnupg2 sudo -y
RUN apt-get install ca-certificates curl
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc
# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the Docker stable repository
RUN echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
RUN apt-get update && \
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
# Add the GitLab Runner user to the Docker group
RUN usermod -aG docker gitlab-runner

# Ensure Docker is available on the runner path
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/docker

