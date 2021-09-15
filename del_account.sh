#!/bin/bash

# This script deletes a user
# run as root
if [[ "${UID}" -ne 0 ]]
then 
echo 'Please run with sudo or as root!' >&2
exit 1
fi

USER="$1"
userdel ${USER}

if [[ "${?}" -ne 0 ]]
then 
echo "The account ${USER} was already deleted." >&2
exit 1
fi

echo "The account ${USER} was deleted."
exit 0