#!/bin/bash

# Define password requirements
MIN_LENGTH=8
REQ_CHARS=1
REQ_NUMBERS=1

# Loop through all users and check their password
while read -r user; do
    # Get the user's password information
    password_info=$(sudo chage -l "$user" | grep "password")

    # Check if the user has a password
    if [[ "$password_info" == *"Password must be changed"* ]]; then
        echo "User $user must change their password on next login"
    else
        # Get the user's password hash
        password_hash=$(sudo grep "^$user:" /etc/shadow | cut -d: -f2)

        # Check if the password meets the requirements
        if [[ ${#password_hash} -ge $MIN_LENGTH && $(echo "$password_hash" | grep -o '[[:alnum:]]' | wc -l) -ge $REQ_CHARS && $(echo "$password_hash" | grep -o '[[:digit:]]' | wc -l) -ge $REQ_NUMBERS ]]; then
            echo "User $user has a valid password"
        else
            echo "User $user must change their password"
            sudo chage -d 0 "$user"
        fi
    fi
done <<<"$(cut -d: -f1 /etc/passwd)"
