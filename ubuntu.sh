# ================================================
# Ruby Install
# If rvm is not installed, install the setup for it, and tell the user to restart and rerun this script
read -p "Are you setting up a remote dev environment with no GUI? [Y/n] " -n 1 -r  remoteDevYn
isRemoteDev=$(( $remoteDevYn == "Y" || $remoteDevYn == "y" ? 1 : 0 ))

if [ $(dpkg-query -W -f='${Status}' rvm 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    sudo apt-get install software-properties-common
    sudo apt-get install zlibc zlib1g zlib1g-dev
    sudo apt-get install libssl-dev
    sudo apt-add-repository -y ppa:rael-gc/rvm
    sudo apt-get update
    sudo apt-get install rvm

    if [[ $isRemoteDev ]]
    then
        echo "================================================"
        echo "If running as a desktop OS:"
        echo "In order to always load rvm, change the Gnome Terminal to always perform a login."
        echo "HOW TO:"
        echo "Click top left of the screen Terminal->Preferences->Under 'Profiles' in the sidebar, select your profile (may be called Unnamed)"
        echo "In the top bar of this window, select Command tab and check 'Run command as login shell'."
        echo "================================================"
    fi
    echo "Now reboot your computer, then run this script again" 
    echo "You can also try logging out or restarting your terminal, BUT"
    echo "Running the command 'id' should contain an entry for rvm, like 1001(rvm)"
    echo "Here is the current output of id"
    id
    exit;
else
    # After computer restarts, set up rvm stuff
    rvm install ruby
    echo "

    if which ruby >/dev/null && which gem >/dev/null; then
    PATH=\"$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:\$PATH\"
    fi
    " >> ~/.bashrc
fi

# ================================================
# Util installs
sudo apt get git
sudo apt-get install mysql-client

# ================================================
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

sudo groupadd docker # todo: remove if not needed
sudo usermod -aG docker $USER
newgrp docker

# Install docker sync
gem install docker-sync

# ================================================

# Install node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
command -v nvm
nvm install node # "node" is an alias for the latest version

# ================================================
# Chrome, vscode, and slack
if [[ !$isRemoteDev ]]
then
    read -p "Do you want to install desktop apps (chromium, vscode, slack)? [Y/n] " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        sudo snap install chromium
        echo "Go to chrome://flags/#force-color-profile and make sure Force Color Profile is set to sRGB"
        sudo snap install code --classic
        code --install-extension bmewburn.vscode-intelephense-client
        code --install-extension eamodio.gitlens
        code --install-extension michelemelluso.code-beautifier
        code --install-extension Mikael.Angular-BeastCode
        code --install-extension mrmlnc.vscode-scss
        code --install-extension ms-azuretools.vscode-docker
        code --install-extension ms-python.python
        code --install-extension ms-vscode.csharp
        code --install-extension ms-vsliveshare.vsliveshare
        code --install-extension neilbrayfield.php-docblocker
        code --install-extension wayou.vscode-todo-highlight
        code --install-extension geeksharp.openssl-configuration-file

        sudo add-apt-repository ppa:umang/indicator-stickynotes
        sudo apt-get update
        sudo apt-get install indicator-stickynotes

        sudo snap install slack --classic
        sudo snap install insomnia

        cd ~/Downloads
        wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcolor2/gcolor2_0.4-2.1ubuntu1_amd64.deb
        sudo apt-get install ./gcolor2_0.4-2.1ubuntu1_amd64.deb
    fi
fi


#=============================
# Fonts and emojis
if [[ !$isRemoteDev ]]
then
    sudo apt-get install fonts-noto-color-emoji
fi

# ================================================
# Setup git and dev stuff
read -p "Do you want to clone the fd repo to ~/dev and setup git? [Y/n] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    mkdir ~/dev/
    cd ~/dev/
    git config --global credential.helper store
    echo "Create a new access token on github, give it access to repo."
    echo "https://github.com/settings/tokens/new"
    echo "When this clone prompts for your username and password, use:"
    echo "Username: <your github username>"
    echo "Password: the access token you created on github"
    git clone https://github.com/fitdegree/fitdegree.git

    # npm install where needed
    cd ~/dev/fitdegree/clients
    npm install
    cd ~/dev/fitdegree/testing
    npm install

    sudo apt-get install vim
    echo "
    export VISUAL=vim
    export EDITOR=\"\$VISUAL\"" >> ~/.bashrc
    git config --global core.editor "vim"
fi

# ================================================
# Bashrc aliases
read -p "Do you want to add aliases for gitclean and cd-ing to ~/dev/fitdegree? [Y/n] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "
    alias gitclean='git branch --merged | grep -v \* | xargs git branch -D'
    alias fd='cd ~/dev/fitdegree'" >> ~/.bashrc
fi

if [[ !$isRemoteDev ]]
then
    echo "Now download and run the ubunutu version of"
    echo "https://github.com/docker/kitematic/releases/latest"
    echo "Then you're good to go!"
else
    echo "All done"
fi