#!/bin/bash

export ANSIBLE_PYTHON_ENV="ansible"
export PYTHON_ENV_DIR="python-environments"

# Define a dictionary of options and their corresponding scripts
declare -A options=(
    ["Setup Ansible Environment"]="bash scripts/install-ansible.sh"
    ["Install Oh My Zsh"]="bash scripts/install-oh-my-zsh.sh"
)

# Generate a menu
PS3='Please enter your choice: '
select opt in "${!options[@]}" "Quit"; do
    case $opt in
        "Quit")
            # exit the python environment but only if we are inside a virtual environment
            if [[ -n $VIRTUAL_ENV ]]; then
                deactivate
            fi
            break
            ;;
        *)
            if [[ -n $opt ]]; then
                eval ${options[$opt]}
            else
                echo "Invalid option. Try another one."
            fi
            ;;
    esac
done