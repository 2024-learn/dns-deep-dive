#!/bin/sh
### Description: This script checks whether the user's input matches an existing mapping inside the /etc/hosts file in order to avoid duplication.
### Written by: Nicholas Doropoulos
### Version: 1
echo "Enter a hostname or an IP address : "
read input
if grep -qF "$input" /etc/hosts; then
   echo "The supplied input already exists in the mapping(s) below: "
   echo ""
   grep -n $input /etc/hosts
else
   echo "There is no mapping in the hosts file that matches your input."
fi

exit 0
