FROM python:bookworm

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_HOME=/home/$USERNAME

# Set devcontainer features environment variables https://containers.dev/implementors/features/#user-env-var
ARG _REMOTE_USER=${USERNAME}
ARG _CONTAINER_USER=${USERNAME}
ARG _REMOTE_USER_HOME=/home/${USERNAME}
ARG _CONTAINER_USER_HOME=/home/${USERNAME} 

RUN umask 0002 \
   &&  git clone https://github.com/devcontainers/features.git /opt/features\
   && cd /opt/features \
   # Common tasks like setting up the user, installing common packages, etc.
   && cd /opt/features/src/common-utils \
   && UID=${USER_UID} GID=${USER_UID} CONFIGUREZSHASDEFAULTSHELL=true bash install.sh \
   && mkdir -p /home/${USERNAME}/.vscode-server \
   && chown -R ${USER_UID}:${USER_UID} /home/${USERNAME}/.vscode-server \
   # Docker
   && cd /opt/features/src/docker-in-docker \
   && MOBY=false VERSION=26.0.0 DOCKERDASHCOMPOSEVERSION=none bash install.sh \
   # GitHub CLI
   && cd /opt/features/src/github-cli/ \
   && bash install.sh

# Install python dependencies 
RUN pip3 install lint ansible ansible-lint molecule molecule-plugins[docker]

# We need .local/bin in the path because dependencies install binaries there
ENV PATH=$PATH:$USER_HOME/.local/bin

VOLUME [ "/var/lib/docker" ]

# Initialize the docker but for this to work, specify overrideCommand = false in devcontainer.json
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

# User specific setup
USER $USERNAME

# Setup Oh My Zsh using https://github.com/deluan/zsh-in-docker
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
   -p git \
   -p command-not-found \
   -p docker \
   -p dirhistory \
   -p autojump \
   -p git-extras \
   -p https://github.com/zsh-users/zsh-completions \
   -p https://github.com/zsh-users/zsh-autosuggestions \
   -p https://github.com/zsh-users/zsh-syntax-highlighting \
   # Change the XTERM to xterm-256color
   sed -i 's/TERM=xterm/TERM=xterm-256color/g' $USER_HOME/.zshrc;

# Copy the Powerlevel10k theme configuration
COPY .devcontainer/p10k.zsh ${USER_HOME}/.p10k.zsh

# Include Powerlevel10k theme config in zsh 
RUN echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc \
   # Install autojump for oh-my-zsh
   && sudo apt-get install -y autojump \
   # Cleanup
   && sudo apt-get autoremove -y \
   && sudo apt-get clean -y \
   && sudo rm -rf /var/lib/apt/lists/*
