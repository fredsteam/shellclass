#!/bin/bash
#
# This script will add local user accounts
# You will be promted to enter the username (login), the person name, and a password.
# The username, password, and host for the account will be displayed.

# Check to see if user is root.
if [[ "${UID}" -ne 0 ]]
then
  echo "Please run with sudo or as root."
  exit 1
fi

# Get the username (login). users real name, and initial password 
read -p 'Enter the username to create: ' USER_NAME

# Get the real name (contents for the description field). and initial password 
read -p 'Enter the name of the person or application that will be using this account: ' COMMENT

# Get the password 
read -p 'Enter the password to use for the account: ' PASSWORD 

# Create new user based on input provided by the user.
useradd -c "${COMMENT}" -m ${USER_NAME}

# Check to see if the useradd command succeeded
# We don't want to tell the user that an account was created when it hasn't been.
if [[ "${?}" -ne 0 ]]
then
  echo "Sorry, the account could not be created."
  exit 1
fi

# Set the password
echo $PASSWORD | passwd --stdin ${USER_NAME}

if [[ "${?}" -ne 0 ]]
then
  echo "The password for the account could not be set."
  exit 1
fi

# Force password change on first login
passwd -e $USER_NAME

# Display the username, password, and hostname where the account was created.
echo
echo 'username:'
echo "${USER_NAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
exit 0






