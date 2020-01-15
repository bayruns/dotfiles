# ================================================
# Ruby Install
# If rvm is not installed, install the setup for it, and tell the user to restart and rerun this script
read -p "Are you setting up a remote dev environment with no GUI? [Y/n] " -n 1 -r  remoteDevYn
isRemoteDev=$(( $remoteDevYn == "Y" || $remoteDevYn == "y" ? 1 : 0 ))

sudo apt update
sudo apt install ruby-full
ruby --version

# ================================================
# Util installs
sudo apt get git
sudo apt-get install mysql-client
sudo apt-get install vim
echo "
export VISUAL=vim
export EDITOR=\"\$VISUAL\"" >> ~/.bashrc

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

        sudo add-apt-repository ppa:wireshark-dev/stable
        sudo apt-get update
        sudo apt-get install wireshark
        sudo wireshark

        # Install android studio
        # sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
        # sudo unzip ~/Downloads/android-studio-ide-171.4443003-linux.zip -d /opt/google/
        # sudo mkdir /opt/google/android-sdk
        # sudo chmod o+w /opt/google/android-sdk
        # sudo -i
        # cd /etc/profile.d/
        # echo export ANDROID_SDK_ROOT=/opt/google/android-sdk/ > android_studio.sh
        # echo export ANDROID_HOME=/opt/google/android-sdk/ >> android_studio.sh
        # echo export JAVA_HOME=/opt/google/android-studio/jre >> android_studio.sh
        # /opt/google/android-studio/bin/studio.sh 

        # sudo -E /opt/google/android-studio/bin/studio.sh 
        sudo snap install --classic android-studio 

        # Install gcolor
        cd ~/Downloads
        wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcolor2/gcolor2_0.4-2.1ubuntu1_amd64.deb
        sudo apt-get install ./gcolor2_0.4-2.1ubuntu1_amd64.deb

        # Install kitematic
        export VERSION=$(curl -s "https://github.com/docker/kitematic/releases/latest" | grep -o 'tag/[v.0-9]*' | awk -F/ '{print $2}')
        wget https://github.com/docker/kitematic/releases/download/$VERSION/Kitematic-$VERSION-Ubuntu.zip --directory-prefix='~/Downloads/'
        tar -xzC ~/Downloads/kitematic-latest/ --strip 1 Kitematic-$VERSION-Ubuntu/{openssl-1.0.cnf,easyrsa,x509-types} 
    fi
fi


#=============================
# Fonts and emojis
if [[ !$isRemoteDev ]]
then
    sudo apt-get install fonts-noto-color-emoji
    # Cursor theme
    sudo apt-get install adwaita-icon-theme-full
    # Set cursor size
    sudo echo "Xcursor.size: 16" >> /etc/X11/Xresources/x11-common
    sudo echo "Xcursor.theme: Adwaita" >> /etc/X11/Xresources/x11-common
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