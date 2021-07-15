#!/bin/sh
set -o nounset # error when referencing undefined variable
set -o errexit # exit when command fails

error() {
    echo $1
    exit 1
}

setPath() {
    echo "Where do you want to install the moldy binary? [default in $ HOME/.moldy]?"
    read path
    # Check that the directory exists
    if [ ! -d $path ]; then
        error "Error: directory "$path" does not exist"
    fi

    # Install binary...
    echo "Moldy binary installation successful 😀"
}

installGitOnMac() {
    brew install git
}

installGitOnUbuntu() {
    sudo apt-get update
    sudo apt-get install git
}

installGitOnArch() {
    sudo pacman -Sy git
}

installGitOnFedora() {
    sudo dnf install git
}

installGitOnGentoo() {
    sudo emerge --ask --verbose dev-vcs/git
}

installGit() {
    [ "$(uname)" == "Darwin" ] && installGitOnMac
    [ -n "$(cat /etc/os-release | grep Ubuntu)" ] && installGitOnUbuntu
    [ -f "/etc/arch-release" ] && installGitOnArch
    [ -f "/etc/artix-release" ] && installGitOnArch
    [ -f "/etc/fedora-release" ] && installGitOnFedora
    [ -f "/etc/gentoo-release" ] && installGitOnGentoo
}

installUnzipOnMac() {
    brew install unzip
}

installUnzipOnUbuntu() {
    sudo apt-get install -y unzip
}

installUnzipOnArch() {
    sudo pacman -Sy unzip
}

installUnzipOnFedora() {
    sudo dnf install unzip
}

installUnzipOnGentoo() {
    sudo emerge --ask app-arch/unzip
}

installUnzip() {
    [ "$(uname)" == "Darwin" ] && installUnzipOnMac
    [ -n "$(cat /etc/os-release | grep Ubuntu)" ] && installUnzipOnUbuntu
    [ -f "/etc/arch-release" ] && installUnzipOnArch
    [ -f "/etc/artix-release" ] && installUnzipOnArch
    [ -f "/etc/fedora-release" ] && installUnzipOnFedora
    [ -f "/etc/gentoo-release" ] && installUnzipOnGentoo
}

nerdFontVerification() {
    echo "We recommend that you use a nerd font, if you don't we can install a [y/n]?"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ]; then
        echo "Installing Ubuntu mono nerd font"
        git clone https://github.com/Moldy-Community/moldyup.git || installGit
        unzip moldyup/assets/UbuntuMono.zip || installUnzip
        if [ "$(uname)" == "Darwin" ]; then
            sudo mv *.ttf ~/Library/Fonts
        else
            sudo mv *.ttf /usr/share/fonts
        fi
        rm -rf moldyup
        echo "Successful installation"
        echo "Now you can change the font of your terminal for the version of Ubuntu mono nerd font you prefer"
    fi
}

installation() {
    [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ] && error "You are using the linux installer, you must use the installer for windows"
    setPath
    nerdFontVerification
}

# Welcome
echo '-------------------------------------'
echo '        Installing Moldy 🚀          '
echo '-------------------------------------'

installation
