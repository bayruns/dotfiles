# Setup user
user=$(logname)
# Force to be run as root
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

# ================================================
# Ruby Install
# If rvm is not installed, install the setup for it, and tell the user to restart and rerun this script
sudo -u $user read -p "Are you setting up a remote dev environment with no GUI? [Y/n] " -n 1 -r  remoteDevYn
isRemoteDev=$(( $remoteDevYn == "Y" || $remoteDevYn == "y" ? 1 : 0 ))


apt update
apt install ruby-full
sudo -u $user ruby --version

# ================================================
# Util installs
apt get git
apt-get install mysql-client
apt-get install vim
sudo apt install python3-pip
pip3 install awscli --upgrade --user
echo "export PATH=$PATH:~/.local/bin/" >> ~/.bashrc
sudo -u $user echo "
export VISUAL=vim
export EDITOR=\"\$VISUAL\"" >> ~/.bashrc

# ================================================
# Docker install
apt-get remove docker docker-engine docker.io containerd runc
apt-get update
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
sudo -u $user curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io
docker run hello-world


# Fix docker permission
chmod 666 /var/run/docker.sock

groupadd docker # todo: remove if not needed
usermod -aG docker $user
sudo -u $user newgrp docker

# Install docker sync
sudo -u $user gem install docker-sync

# ================================================

# Install node version manager
sudo -u $user curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
sudo -u $user command -v nvm
sudo -u $user nvm install node # "node" is an alias for the latest version

# ================================================
# Chrome, vscode, and slack
if [[ !$isRemoteDev ]]
then
    read -p "Do you want to install desktop apps (chromium, vscode, slack)? [Y/n] " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        snap install chromium
        echo "Go to chrome://flags/#force-color-profile and make sure Force Color Profile is set to sRGB"
        snap install code --classic
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

        add-apt-repository ppa:umang/indicator-stickynotes
        apt-get update
        apt-get install indicator-stickynotes

        snap install slack --classic
        snap install insomnia

        add-apt-repository ppa:wireshark-dev/stable
        apt-get update
        apt-get install wireshark
        wireshark

        # Install android studio
        # apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
        # unzip ~/Downloads/android-studio-ide-171.4443003-linux.zip -d /opt/google/
        # mkdir /opt/google/android-sdk
        # chmod o+w /opt/google/android-sdk
        # sudo -i
        # cd /etc/profile.d/
        # echo export ANDROID_SDK_ROOT=/opt/google/android-sdk/ > android_studio.sh
        # echo export ANDROID_HOME=/opt/google/android-sdk/ >> android_studio.sh
        # echo export JAVA_HOME=/opt/google/android-studio/jre >> android_studio.sh
        # /opt/google/android-studio/bin/studio.sh 

        # sudo -E /opt/google/android-studio/bin/studio.sh 
        snap install --classic android-studio 
        sudo -u $user wget https://services.gradle.org/distributions/gradle-5.2.1-bin.zip -P /tmp
        unzip -d /opt/gradle /tmp/gradle-*.zip
        sudo -u $user echo 'export GRADLE_HOME=/opt/gradle/gradle-5.2.1' >> ~/.bashrc 
        sudo -u $user echo 'export PATH=${GRADLE_HOME}/bin:${PATH}' >> ~/.bashrc 
        sudo -u $user source /etc/profile.d/gradle.sh
        sudo -u $user gradle -v

        # Install gcolor
        sudo -u $user cd ~/Downloads
        sudo -u $user wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcolor2/gcolor2_0.4-2.1ubuntu1_amd64.deb
        sudo -u $user apt-get install ./gcolor2_0.4-2.1ubuntu1_amd64.deb

        # Install kitematic
        sudo -u $user export VERSION=$(curl -s "https://github.com/docker/kitematic/releases/latest" | grep -o 'tag/[v.0-9]*' | awk -F/ '{print $2}')
        sudo -u $user wget https://github.com/docker/kitematic/releases/download/$VERSION/Kitematic-$VERSION-Ubuntu.zip --directory-prefix='~/Downloads/'
        sudo -u $user tar -xzC ~/Downloads/kitematic-latest/ --strip 1 Kitematic-$VERSION-Ubuntu/{openssl-1.0.cnf,easyrsa,x509-types} 
    fi
fi


#=============================
# Fonts and emojis
if [[ !$isRemoteDev ]]
then
    apt-get install fonts-noto-color-emoji
    # Cursor theme
    apt-get install adwaita-icon-theme-full
    # Set cursor size
    echo "Xcursor.size: 16" >> /etc/X11/Xresources/x11-common
    echo "Xcursor.theme: Adwaita" >> /etc/X11/Xresources/x11-common
fi

# ================================================
# Setup git and dev stuff
read -p "Do you want to clone the fd repo to ~/dev and setup git? [Y/n] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo -u $user mkdir ~/dev/
    sudo -u $user cd ~/dev/
    sudo -u $user git config --global credential.helper store
    sudo -u $user mkdir ~/dev/
    sudo -u $user echo "Create a new access token on github, give it access to repo."
    sudo -u $user echo "https://github.com/settings/tokens/new"
    sudo -u $user echo "When this clone prompts for your username and password, use:"
    sudo -u $user echo "Username: <your github username>"
    sudo -u $user echo "Password: the access token you created on github"
    sudo -u $user git clone https://github.com/fitdegree/fitdegree.git

    # npm install where needed
    sudo -u $user cd ~/dev/fitdegree/clients
    sudo -u $user npm install
    sudo -u $user cd ~/dev/fitdegree/testing
    sudo -u $user npm install

    sudo -u $user git config --global core.editor "vim"
fi


# ================================================
# Bashrc aliases
sudo -u $user read -p "Do you want to add aliases for gitclean and cd-ing to ~/dev/fitdegree? [Y/n] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo -u $user echo "
    alias gitclean='git branch --merged | grep -v \* | xargs git branch -D'
    alias fd='cd ~/dev/fitdegree'" >> ~/.bashrc
fi

if [[ !$isRemoteDev ]]
then
    sudo -u $user echo "Now download and run the ubunutu version of"
    sudo -u $user echo "https://github.com/docker/kitematic/releases/latest"
    sudo -u $user echo "Then you're good to go!"
else
    sudo -u $user echo "All done"
fi