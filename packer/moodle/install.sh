#! /bin/bash
# install python
sudo apt-get --assume-yes update
sudo apt-get --assume-yes install python3.6
# install docker
sudo apt-get --assume-yes install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get --assume-yes update

sudo apt-get --assume-yes install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo apt-key fingerprint 0EBFCD88
# sudo add-apt-repository --assume-yes "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# sudo apt-get --assume-yes update
# sudo apt-get --assume-yes install docker-ce docker-ce-cli containerd.io
# sudo usermod -aG docker ubuntu

# install nodejs
curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
sudo apt --assume-yes install nodejs
rm nodesource_setup.sh
# clone the repo
git clone https://github.com/shailensukul/devops.git /home/ubuntu/app
# sudo docker build -t application /home/ubuntu/app
# start the docker containers
sudo docker compose -f /home/ubuntu/app/packer/moodle/docker-compose.yml -d