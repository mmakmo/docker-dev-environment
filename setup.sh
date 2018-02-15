#!/bin/bash

# /z/development/docker/docker-dev-environment
# @powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process powershell.exe -Verb runas && ./bin/install.ps1"

echo "=========================================================================="
echo "Setup Docker Development Environment"
echo "=========================================================================="
echo "Pre-Requirement:"
echo "[Required Commonly]"
echo "  * git"
echo "  * curl"
echo "[for Windows]"
echo "  * docker-toolbox"
echo "  * ConEmu (just recommended)"
echo "[for Mac/Linux]"
echo "  * docker"
echo "=========================================================================="
echo ""

OS=""
HOST_IP_ADDRESS=""
DOCKER_MACHINE_IP_ADDRESS=""

if [ "$(uname)" == 'Darwin' ]; then
    OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    OS='Linux'
elif [ "$(expr substr $(uname -s) 1 7)" == 'MSYS_NT' ]; then
    OS='Windows'
else
    echo "Your platform ($(uname -a)) is not supported."
    echo "(If you are using Windows, you should run this script on Docker Quickstart Terminal.)"
    exit 1
fi

# ------------------------------------------------------
# check pre-required applications and settings
# ------------------------------------------------------
if ! type git >/dev/null 2>&1; then
    echo "[WARNING] git is required: not installed git on your PC."
    echo "Exit."
    exit 1
fi

# for mac/linux
if [ "${OS}" == 'Darwin' ] || [ "${OS}" == 'Linux' ]; then
    if ! type docker >/dev/null 2>&1; then
        echo "[WARNING] docker is required: not installed docker on your PC."
        echo "Exit."
        exit 1
    fi
    HOST_IP_ADDRESS=`ifconfig | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | egrep -v "127.0.0.1|255|0.0.0.0" | head -1`

fi

if [ "${OS}" == 'Windows' ]; then
    if ! type curl >/dev/null 2>&1; then
        echo "[WARNING] curl is required: not installed curl on your PC."
        echo "Example of solution:"
        echo " 1) Install chocolatey (on cmd as administrator): https://chocolatey.org/install"
        echo " 2) Install curl to use this command on cmd.exe as administrator: cinst -y curl"
        echo "After that, re-run this script."
        echo "Exit."
        exit 1
    fi
    if ! type docker-machine >/dev/null 2>&1; then
    echo "[WARNING] docker-toolbox is required: not installed docker-toolbox on your PC."
    echo "Download: https://docs.docker.com/toolbox/toolbox_install_windows/"
    echo "Exit."
    exit 1
    fi
    docker ps >/dev/null 2>&1
    if [ $? != 0 ]; then
        echo "[WARNING] run this script on Docker Quickstart Terminal."
        echo "Exit."
        exit 1
    fi
    HOST_IP_ADDRESS=`ipconfig | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | egrep -v "127.0.0.1|255|0.0.0.0" | head -1`

    if [ `docker-machine status` != "Running" ] ; then
        docker-machine start
    fi
    #docker-machine upgrade
    DOCKER_MACHINE_IP_ADDRESS=`docker-machine ip`
fi


if [ ! -d ~/.ssh ]; then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""
    echo "ssh key is created(at ~/.ssh)."
    echo "[WARNING] Set ssh public key into Git server before. Public key is below:"
    cat ~/.ssh/id_rsa.pub
    echo ""
    echo "After that, re-run this script."
    exit 1
fi

echo "=========================================================================="
echo "Your PC Information"
echo "  OS: ${OS}"
echo "  Host IP Address: ${HOST_IP_ADDRESS}"
echo "  Docker machine IP Address (If you are using Windows): ${DOCKER_MACHINE_IP_ADDRESS}"
echo "=========================================================================="
echo ""

# ------------------------------------------------------
# git user settings
# ref: https://qiita.com/na0AaooQ/items/f2759c9b2c49d2210265
# ------------------------------------------------------
git_user_name=`git config --list | grep user.name`
git_email=`git config --list | grep user.email`
echo "Your git settings are:"
echo "  name: ${git_user_name}"
echo "  email: ${git_email}"

if [ -z "${git_user_name}" ] ; then
    input=""
    while [ -z "${input}" ] ; do
        echo "=========================================================================="
        echo "Enter your name (for git):"
        echo "=========================================================================="
        read input
    done
    git config --global user.name "${input}"
fi

if [ -z "${git_email}" ] ; then
    input=""
    while [ -z ${input} ] ; do
        echo "=========================================================================="
        echo "Enter your e-mail address (for git):"
        echo "=========================================================================="
        read input
    done
    git config --global user.email "${input}"
fi

if [ "${OS}" == 'Windows' ]; then
    # ------------------------------------------------------
    # remove git settings for windows before
    # ------------------------------------------------------
    git config --global --unset core.autoCRLF
    git config --global --unset core.eol lf
    if [ ! -f ~/.gitconfig ]; then
        git config --unset core.autoCRLF
        git config --unset core.eol lf
    fi

    # ------------------------------------------------------
    # add git settings for windows
    # ------------------------------------------------------
    git config --global core.autoCRLF false
    git config --global core.eol lf
fi

# ------------------------------------------------------
# add git settings for all
# ------------------------------------------------------
if [ -z "$(git config --global --list | grep color)" ] ; then
    git config --global color.diff auto
    git config --global color.status auto
    git config --global color.branch auto
fi

# ------------------------------------------------------
# set git autocompletion (ref: https://git-scm.com/book/en/v1/Git-Basics-Tips-and-Tricks)
# ------------------------------------------------------
curl -Ss https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O
mv -f ./git-completion.bash ${HOME}/
if [ -z "$(grep '~/git-completion.bash' ${HOME}/.bashrc)" ] ; then
    echo '~/git-completion.bash' >> ${HOME}/.bashrc
    source ${HOME}/.bashrc
fi

docker-compose -f ./dockerfiles/docker-compose.yml build
docker-compose -f ./dockerfiles/docker-compose.yml up -d