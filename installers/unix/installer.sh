#!/bin/bash
set -o nounset # error when referencing undefined variable
set -o errexit # exit when command fails

error() {
    echo "$1"
    exit 1
}

# Download Path
realesePath="https://github.com/Moldy-Community/moldy/releases/download/v0.2.0"

# Binaries
moldyLinux386="moldy-v0.0.2_linux_386"
moldyLinuxAmd64="moldy-v0.0.2_linux_amd64"
moldyLinuxArm64="moldy-v0.0.2_linux_arm64"
moldyMacAmd64="moldy-v0.0.2_macos_amd64"
moldyMacArm64="moldy-v0.0.2_macos_arm64"

installOnLinux() {
    # 32 Bits
    echo "Do you have a 32x processor?[y/n]"
    read -r answer32

    if [ "$answer32" != "${answer32#[Yy]}" ]; then
        echo "Installing $moldyLinux386"
        if [ $# -eq 0 ]; then
            curl -L "$realesePath/$moldyLinux386" >"$HOME/.moldy/moldy"
            echo "Moldy binary installation successful 😀"
            echo ""
            echo "==> Don't forget to add this 'export PATH=$PATH:$HOME/.moldy/moldy' in your terminal like .bashrc .zshrc or whatever else you use"
        else
            curl -L "$realesePath/$moldyLinux386" >"$1/moldy"
            echo "Moldy binary installation successful 😀"
            echo ""
            echo "==> Don't forget to add this 'export PATH=$PATH:$1/moldy' in your terminal like .bashrc .zshrc or whatever else you use"
        fi
        return
    fi

    # 64 Bits
    echo "Do you have a 64x processor?[y/n]"
    read -r answer64

    if [ "$answer64" != "${answer64#[Yy]}" ]; then
        echo "Do you have amd (standard)[1] or arm[2] architecture?"
        read -r architecture

        if [ "$architecture" != "${architecture#[1]}" ]; then
            # amd
            echo "Installing $moldyLinuxAmd64"
            if [ $# -eq 0 ]; then
                curl -L "$realesePath/$moldyLinuxAmd64" >"$HOME/.moldy/moldy"
                echo "Moldy binary installation successful 😀"
                echo ""
                echo "==> Don't forget to add this 'export PATH=$PATH:$HOME/.moldy/moldy' in your terminal like .bashrc .zshrc or whatever else you use"
            else
                curl -L "$realesePath/$moldyLinuxAmd64" >"$1/moldy"
                echo "Moldy binary installation successful 😀"
                echo ""
                echo "==> Don't forget to add this 'export PATH=$PATH:$1/moldy' in your terminal like .bashrc .zshrc or whatever else you use"
            fi
            return
        elif [ "$architecture" != "${architecture#[2]}" ]; then
            # arm
            echo "Installing $moldyLinuxArm64"
            if [ $# -eq 0 ]; then
                curl -L "$realesePath/$moldyLinuxArm64" >"$HOME/.moldy/moldy"
                echo "Moldy binary installation successful 😀"
                echo ""
                echo "==> Don't forget to add this 'export PATH=$PATH:$HOME/.moldy/moldy' in your terminal like .bashrc .zshrc or whatever else you use"
            else
                curl -L "$realesePath/$moldyLinuxArm64" >"$1/moldy"
                echo "Moldy binary installation successful 😀"
                echo ""
                echo "==> Don't forget to add this 'export PATH=$PATH:$1/moldy' in your terminal like .bashrc .zshrc or whatever else you use"
            fi
            return
        else
            error "You can only choose amd [1] or arm [2]"
        fi
    fi
}

installOnMac() {
    echo "Do you have amd (standard)[1] or arm[2] architecture?"
    read -r architecture

    if [ "$architecture" != "${architecture#[1]}" ]; then
        # amd
        echo "Installing $moldyMacAmd64"
        if [ $# -eq 0 ]; then
            curl -L "$realesePath/$moldyMacAmd64" >"$HOME/.moldy/moldy"
            echo "Moldy binary installation successful 😀"
            echo ""
            echo "==> Don't forget to add this 'export PATH=$PATH:$HOME/.moldy/moldy' in your terminal like .bashrc .zshrc or whatever else you use"
        else
            curl -L "$realesePath/$moldyMacAmd64" >"$1/moldy"
            echo "Moldy binary installation successful 😀"
            echo ""
            echo "==> Don't forget to add this 'export PATH=$PATH:$1/moldy' in your terminal like .bashrc .zshrc or whatever else you use"
        fi
        return
    elif [ "$architecture" != "${architecture#[2]}" ]; then
        # arm
        echo "Installing $moldyMacArm64"
        if [ $# -eq 0 ]; then
            curl -L "$realesePath/$moldyMacArm64" >"$HOME/.moldy/moldy"
            echo "Moldy binary installation successful 😀"
            echo ""
            echo "==> Don't forget to add this 'export PATH=$PATH:$HOME/.moldy/moldy' in your terminal like .bashrc .zshrc or whatever else you use"
        else
            curl -L "$realesePath/$moldyMacArm64" >"$1/moldy"
            echo "Moldy binary installation successful 😀"
            echo ""
            echo "==> Don't forget to add this 'export PATH=$PATH:$1/moldy' in your terminal like .bashrc .zshrc or whatever else you use"
        fi
        return
    else
        error "You can only choose amd [1] or arm [2]"
    fi
}

setPath() {
    echo "Do you want to install Moldy in default [ $HOME/.moldy ] [y/n]?"
    read -r decision

    if [ "$decision" != "${decision#[Yy]}" ]; then
        # default
        mkdir "$HOME/.moldy"
        if [ "$(uname)" == "Darwin" ]; then
            installOnMac
        fi
        [ "$(uname)" == "Linux" ] && installOnLinux
    else
        echo 'Indicate the path where you want to install Moldy'
        read -r binaryPath
        if [ -z "$binaryPath" ]; then
            # other path
            # validate path
            # if [ $# -ne 1 ]; then
            #     error "Wrong path, no more than 2 parameters"
            # fi
            # validate dir
            if [ ! -d "$binaryPath" ]; then
                error "Error: directory '$binaryPath' does not exist"
            fi

            [ "$(uname)" == "Darwin" ] && installOnMac "$binaryPath"
            [ "$(uname)" == "Linux" ] && installOnLinux "$binaryPath"
        fi
    fi
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
    read -r answer
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
echo "-------------------------------------"
echo "        Installing Moldy 🚀          "
echo "-------------------------------------"
echo ""

installation
