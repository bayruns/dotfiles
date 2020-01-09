# Util installs
sudo apt get git
# Create access token on github, give it access to repo.
# https://github.com/settings/tokens/new
git config --global credential.helper store
# After trying an action like clone, pull, etc, use
# Username: <your github username>
# Password: the access token you created on github
sudo apt-get install mysql-client

# Ruby
sudo apt-get install software-properties-common
sudo apt-get install zlibc zlib1g zlib1g-dev
sudo apt-get install libssl-dev
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm

# Now, in order to always load rvm, change the Gnome Terminal to always perform a login.
# At terminal window, click Edit > Profile Preferences, click on Title and Command tab and check Run command as login shell.

# RESTART COMPUTER
rvm install ruby

# Program installs
snap install chromium
snap install code --classic
snap install slack --classic

# Docker install
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world


# Fix docker permission
sudo chmod 666 /var/run/docker.sock

# Download and run the ubunutu version of
# https://github.com/docker/kitematic/releases/latest

# Install node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
command -v nvm
nvm install node # "node" is an alias for the latest version
