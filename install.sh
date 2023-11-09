#!/bin/bash

# NOTE: You need to SOURCE this file, if you want to take immediate advantage of new aliases.
# you can do that in the following ways:

# . install.sh ...OR...
# source install.sh

# If you execute it, you'll need to source ~/.aliases yourself, or restart your shell.

# Function to check and ensure ~/.alias_storage directory exists
function ensure_alias_storage_exists() {
  if [ ! -d "$HOME/.alias_storage" ]; then
    echo "Creating the ~/.alias_storage directory..."
    mkdir -p "$HOME/.alias_storage" && {
      echo "The ~/.alias_storage directory is necessary for the bash-aliases repo install script to operate." > "$HOME/.alias_storage/README.md"
      echo "This directory stores the previous versions of aliases and the latest aliases to ensure no user data is lost during updates." >> "$HOME/.alias_storage/README.md"
      if [ $? -ne 0 ]; then
        echo "Error: Failed to create README.md in $HOME/.alias_storage."
        exit 1
      fi
    } || {
      echo "Error: Failed to create $HOME/.alias_storage directory."
      exit 1
    }
  fi
}

# Function to check the existence of ~/.aliases and manage installation of aliases
function install_aliases() {
  # Ensure the alias storage directory exists
  ensure_alias_storage_exists

  # Check for existence of ~/.aliases
  if [ ! -f "$HOME/.aliases" ]; then
    echo "$HOME/.aliases does not exist. Proceeding to INSTALL."
    install_aliases_procedure
    return 0
  fi

  # TEST: Check if ~/.alias_storage/latest exists
  if [ ! -f "$HOME/.alias_storage/latest" ]; then
    # Prompt user for confirmation
    read -p "The installation utility has never been run. Are you sure you want to proceed? (Yes/No): " user_confirmation
    case $user_confirmation in
      [Yy]|[Yy][Ee][Ss])
        # Proceed to TEST2
        ;;
      [Nn]|[Nn][Oo])
        echo "Installation aborted by user."
        exit 0
        ;;
      *)
        echo "Invalid input. Please enter Yes or No."
        exit 1
        ;;
    esac
  fi

  # TEST2: Do the hashes of ~/.aliases and ~/.alias_storage/latest match?
  if [ -f "$HOME/.alias_storage/latest" ]; then
    current_hash=$(md5sum "$HOME/.aliases" | cut -d' ' -f1)
    latest_hash=$(md5sum "$HOME/.alias_storage/latest" | cut -d' ' -f1)

    if [ "$current_hash" == "$latest_hash" ]; then
      echo "Hashes match. No drift detected. Proceeding with INSTALL."
    else
      echo "Warning: Drift detected between current and latest aliases."
      # Provide a diff of the changes between files
      diff "$HOME/.aliases" "$HOME/.alias_storage/latest"
      # Prompt user for confirmation
      read -p "Do you wish to proceed with installation? (CTRL+C to cancel)" user_confirmation
    fi
  fi

  # INSTALL procedure
  install_aliases_procedure
}

# Function for the INSTALL steps
function install_aliases_procedure() {
  local timestamp=$(date +%Y%m%d%H%M%S)

  # Ensure the alias storage directory exists
  ensure_alias_storage_exists

  # If the ~/.alias_storage/latest file exists, archive it
  if [ -f "$HOME/.alias_storage/latest" ]; then
    mkdir -p "$HOME/.alias_storage/previous"
    mv "$HOME/.alias_storage/latest" "$HOME/.alias_storage/previous/${timestamp}"
  fi

  # Copy .aliases to the home directory and ~/.alias_storage
  cp .aliases "$HOME/.aliases"
  cp "$HOME/.aliases" "$HOME/.alias_storage/latest"

  # Source ~/.aliases in the current shell
  # This will only affect the current shell if the script is sourced, not if it's executed in a subshell
  source "$HOME/.aliases"
  echo "Aliases have been installed and sourced successfully."
}

# Execute the function
install_aliases
