#!/bin/bash

# This script creates a new user on the local system
# You must supply a username as an argument to the script.
# Optionally, you can also provide a comment for the account as an argument.
# A password will automatically generated for the account.
# The username, password, and host for the account will be diplayed.

# Ensure script is run as root or with sudo.
if [[ "${UID}" -ne 0 ]]
then
  echo "USAGE: Script must be run as root or with sudo"
  exit 1
fi

# User must give an account name.
if [[ "${#}" -lt 1 ]]
then
  echo "USAGE: ${0} USER_NAME [COMMENT]..."
  exit 1
fi 

# The first argument provided by the user will be the username.
USER_NAME="${1}"

# The remainder of the arguments will be treated as a comment for the account.
shift
COMMENT="${@}"

# Generate a passowrd 
PASSWORD=$(date +%s%N | sha256sum | head -c32)

# Create the account
useradd -c "${COMMENT}" -m ${USER_NAME}

# Inform the user if the account was created or not
if [[ "${?}" -ne 0 ]]
then
  echo "The account for ${USER_NAME} could not be created"
  exit 1
fi

# Set the password.
echo "${PASSWORD}" | passwd --stdin ${USER_NAME}

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
  echo "The password for the account could not be set."
  exit 1
fi

# Force password change
passwd -e ${USER_NAME}

# Display account information
echo
echo "username: ${USER_NAME}"
echo
echo "password: ${PASSWORD}"
echo
echo "host: ${HOSTNAME}"
exit 0

