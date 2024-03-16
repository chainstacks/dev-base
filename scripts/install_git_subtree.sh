#!/bin/bash

# Installs git subtree

# Ensure the user has root permissions
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)."
   exit 1
fi

echo "INSTALLING GIT SUBTREE..."

# Store the initial directory
INITIAL_DIR=$(pwd)

# Get the git executable directory
GIT_EXEC_PATH=$(git --exec-path)
echo "Git found in $GIT_EXEC_PATH"

# Clone git source into /tmp for temporary use
echo "Cloning git source into /tmp..."
cd /tmp
git clone https://github.com/git/git.git

# Navigate to the contrib/subtree directory
cd git/contrib/subtree

# Prepare subtree 
echo "Preparing git-subtree..."
make

# Install git-subtree to the correct location
echo "Installing git-subtree to $GIT_EXEC_PATH..."
install -m 755 git-subtree "$GIT_EXEC_PATH"

# Clean up
echo "Removing temporary git source..."
rm -rf /tmp/git 

# Source the appropriate profile to update PATH
if [[ -f ~/.bashrc ]]; then
  source ~/.bashrc
elif [[ -f ~/.profile ]]; then
  source ~/.profile
fi

cd $INITIAL_DIR

# Verification
echo "Verifying git subtree installation..."
if git subtree --help >/dev/null 2>&1; then 
    echo "Git subtree installation successful!"
else
    echo "Git subtree installation may have failed. Error output:"
    git subtree help  # No redirection here for error visibility
fi