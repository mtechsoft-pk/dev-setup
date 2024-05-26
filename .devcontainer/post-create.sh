# Github setup -----------------------------------------------------------------------------
if ! git config --global user.email; then
   echo "Enter your git email: "
   read GIT_EMAIL
   git config --global user.email "$GIT_EMAIL"
fi

if ! git config --global user.name; then
   echo "Enter your name for git: "
   read GIT_USERNAME
   git config --global user.name "$GIT_USERNAME"
fi

if ! gh extension list | grep -q "copilot"; then
   echo "Do you want to install gh copilot extension? [y/n]: "
   read INSTALL_COPILOT

   if [ "$INSTALL_COPILOT" = "y" ]; then
      if ! gh auth status; then
         gh auth login
      fi

      if gh auth status; then
         gh extension install github/gh-copilot
      fi
   fi
fi
