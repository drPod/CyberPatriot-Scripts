#!/bin/bash

# Command I used to make this whole script in Copilot:
# "Write a function to do the following: (argument that gets commented). If the function couldn't execute, return an error but don't end the script."

function single_time_sync_daemon {
    if [[ $(systemctl is-active systemd-timesyncd.service) == "active" ]]; then
        if [[ $(systemctl is-enabled systemd-timesyncd.service) == "enabled" ]]; then
            echo "Success: A single time synchronization daemon is in use."
        else
            echo "Failure: systemd-timesyncd.service is not enabled."
        fi
    elif [[ $(systemctl is-active ntp.service) == "active" ]]; then
        if [[ $(systemctl is-enabled ntp.service) == "enabled" ]]; then
            echo "Success: A single time synchronization daemon is in use."
        else
            echo "Failure: ntp.service is not enabled."
        fi
    else
        echo "Failure: No time synchronization daemon is active."
    fi
}
