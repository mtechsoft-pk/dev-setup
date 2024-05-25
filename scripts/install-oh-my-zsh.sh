#!/bin/bash

echo "Installing Oh My Zsh"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ANSIBLE_PYTHON_DIR="$HOME/$PYTHON_ENV_DIR/$ANSIBLE_PYTHON_ENV"

if [ ! -d "$ANSIBLE_PYTHON_DIR" ]; then
    # getting directory of the script
    bash $DIR/install-ansible.sh
fi

source $ANSIBLE_PYTHON_DIR/bin/activate

# install package manager python library
if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get install -y python3-apt
else
    echo "Could not determine package manager command to install dependencies."
    exit 1
fi

PROJECT_DIR=$(realpath "$DIR/../")
PLAYBOOK_FILE=oh-my-zsh.playbook.yml

cat <<EOF > $PLAYBOOK_FILE
---
- name: Setup oh-my-zsh.
  hosts: all
  roles:
    - oh-my-zsh
EOF

ansible-playbook -i "localhost," -c local $PLAYBOOK_FILE --ask-become-pass

rm -rf $PLAYBOOK_FILE