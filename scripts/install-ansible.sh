#!/bin/bash

echo "Installing Ansible"

if [ -x "$(command -v apt-get)" ]; then
   INSTALL_CMD="sudo apt-get install -y python3-virtualenv"
   elif [ -x "$(command -v yum)" ]; then
   INSTALL_CMD="sudo yum install -y python3-virtualenv"
   elif [ -x "$(command -v dnf)" ]; then
   INSTALL_CMD="sudo dnf install -y python3-virtualenv"
   elif [ -x "$(command -v brew)" ]; then
   INSTALL_CMD="brew install python3-virtualenv"
else
   echo "Could not determine package manager command to install dependencies."
   exit 1
fi

eval $INSTALL_CMD

PYTHON_ENV_HOME="$HOME/${PYTHON_ENV_DIR:-python-environments}"
ANSIBLE_PYTHON_ENV="${ANSIBLE_PYTHON_ENV:-ansible}"

if [ ! -d "$PYTHON_ENV_HOME" ]; then
   mkdir -p $PYTHON_ENV_HOME
fi

# check if ansible env is not created
if [ ! -d "$PYTHON_ENV_HOME/$ANSIBLE_PYTHON_ENV" ]; then
   echo "Creating virtualenv for molecule"
   virtualenv $PYTHON_ENV_HOME/$ANSIBLE_PYTHON_ENV
fi

source $PYTHON_ENV_HOME/$ANSIBLE_PYTHON_ENV/bin/activate

pip3 install lint ansible ansible-lint molecule molecule-plugins[docker]