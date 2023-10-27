#!/bin/bash

# Command I used to make this whole script in Copilot:
# "Write a function to do the following: (argument that gets commented). If the function couldn't execute, return an error but don't end the script."
# Make sure to keep reloading till it gives you return statements

ensure_auditd_installed() {
    # 4.1.1.1 Ensure auditd is installed
    if ! dpkg -s auditd >/dev/null 2>&1; then
        echo "auditd is not installed. Installing it now..."
        if ! apt-get install -y auditd >/dev/null 2>&1; then
            echo "Failed to install auditd."
            return 1
        fi
    else
        echo "auditd is already installed."
    fi
}

ensure_auditd_service_enabled_and_active() {
    # 4.1.1.2 Ensure auditd service is enabled and active
    if ! systemctl is-enabled auditd >/dev/null 2>&1; then
        echo "auditd service is not enabled. Enabling it now..."
        if ! systemctl enable auditd >/dev/null 2>&1; then
            echo "Failed to enable auditd service."
            return 1
        fi
    else
        echo "auditd service is already enabled."
    fi

    if ! systemctl is-active auditd >/dev/null 2>&1; then
        echo "auditd service is not active. Starting it now..."
        if ! systemctl start auditd >/dev/null 2>&1; then
            echo "Failed to start auditd service."
            return 1
        fi
    else
        echo "auditd service is already active."
    fi
}

ensure_auditing_for_processes_enabled() {
    # 4.1.1.3 Ensure auditing for processes that start prior to auditd is enabled
    if ! grep -q "^\s*linux" /boot/grub/grub.cfg && ! grep -q "^\s*linux" /boot/grub/grub.conf; then
        echo "No kernel boot parameters found. Adding them now..."
        if ! sed -i '/^\s*GRUB_CMDLINE_LINUX=/ s/"$/ audit=1"/' /etc/default/grub >/dev/null 2>&1; then
            echo "Failed to add kernel boot parameters."
            return 1
        fi
        if ! update-grub >/dev/null 2>&1; then
            echo "Failed to update grub."
            return 1
        fi
    else
        if ! grep -q "^\s*linux.*audit=1" /boot/grub/grub.cfg && ! grep -q "^\s*linux.*audit=1" /boot/grub/grub.conf; then
            echo "Kernel boot parameters found, but auditing is not enabled. Enabling it now..."
            if ! sed -i '/^\s*GRUB_CMDLINE_LINUX=/ s/"$/ audit=1"/' /etc/default/grub >/dev/null 2>&1; then
                echo "Failed to enable auditing for processes that start prior to auditd."
                return 1
            fi
            if ! update-grub >/dev/null 2>&1; then
                echo "Failed to update grub."
                return 1
            fi
        else
            echo "Auditing for processes that start prior to auditd is already enabled."
        fi
    fi
}

ensure_audit_backlog_limit_sufficient() {
    # 4.1.1.4 Ensure audit_backlog_limit is sufficient
    local backlog_limit=$(grep -E "^\s*max_log_file\s*=" /etc/audit/auditd.conf | awk -F= '{print $2}')
    if [ -z "$backlog_limit" ]; then
        echo "max_log_file is not set in /etc/audit/auditd.conf. Setting it to 1024..."
        if ! sed -i '/^\s*max_log_file\s*=/d' /etc/audit/auditd.conf >/dev/null 2>&1; then
            echo "Failed to delete max_log_file from /etc/audit/auditd.conf."
            return 1
        fi
        if ! echo "max_log_file = 1024" >> /etc/audit/auditd.conf; then
            echo "Failed to set max_log_file to 1024 in /etc/audit/auditd.conf."
            return 1
        fi
    elif [ "$backlog_limit" -lt 1024 ]; then
        echo "max_log_file is set to $backlog_limit in /etc/audit/auditd.conf. Setting it to 1024..."
        if ! sed -i "s/^\s*max_log_file\s*=.*/max_log_file = 1024/" /etc/audit/auditd.conf >/dev/null 2>&1; then
            echo "Failed to set max_log_file to 1024 in /etc/audit/auditd.conf."
            return 1
        fi
    else
        echo "audit_backlog_limit is sufficient."
    fi
}

ensure_audit_log_storage_size_configured() {
    # 4.1.2.1 Ensure audit log storage size is configured
    local log_file=$(grep -E "^\s*[^#].*\-f\s+.*(/var/log/audit/audit.log|/var/log/audit/auditd.log)" /etc/audit/auditd.conf | awk '{print $2}')
    if [ -z "$log_file" ]; then
        echo "Audit log file is not configured in /etc/audit/auditd.conf."
        return 1
    fi

    local log_dir=$(dirname "$log_file")
    local log_size=$(grep -E "^\s*[^#].*\-s\s+\d+" /etc/audit/auditd.conf | awk '{print $2}')
    if [ -z "$log_size" ]; then
        echo "Audit log storage size is not configured in /etc/audit/auditd.conf. Setting it to 100M..."
        if ! echo "-s 100M" >> /etc/audit/auditd.conf; then
            echo "Failed to set audit log storage size to 100M in /etc/audit/auditd.conf."
            return 1
        fi
    else
        local log_size_unit=$(echo "$log_size" | sed -E 's/^[[:digit:]]+//')
        local log_size_value=$(echo "$log_size" | sed -E 's/[[:alpha:]]+$//')
        if [ "$log_size_unit" = "k" ]; then
            log_size_value=$((log_size_value / 1024))
        elif [ "$log_size_unit" = "G" ]; then
            log_size_value=$((log_size_value * 1024))
        fi

        if [ "$log_size_value" -lt 100 ]; then
            echo "Audit log storage size is set to $log_size in /etc/audit/auditd.conf. Setting it to 100M..."
            if ! sed -i "s/^\s*[^#].*\-s\s.*/-s 100M/" /etc/audit/auditd.conf >/dev/null 2>&1; then
                echo "Failed to set audit log storage size to 100M in /etc/audit/auditd.conf."
                return 1
            fi
        else
            echo "Audit log storage size is configured."
        fi
    fi

    if ! [ -d "$log_dir" ]; then
        echo "Audit log directory $log_dir does not exist. Creating it now..."
        if ! mkdir -p "$log_dir" >/dev/null 2>&1; then
            echo "Failed to create audit log directory $log_dir."
            return 1
        fi
    fi

    if ! [ -f "$log_file" ]; then
        echo "Audit log file $log_file does not exist. Creating it now..."
        if ! touch "$log_file" >/dev/null 2>&1; then
            echo "Failed to create audit log file $log_file."
            return 1
        fi
    fi

    if ! [ -w "$log_file" ]; then
        echo "Audit log file $log_file is not writable. Changing its permissions now..."
        if ! chmod o-rwx "$log_file" >/dev/null 2>&1; then
            echo "Failed to change permissions of audit log file $log_file."
            return 1
        fi
    fi
}

ensure_audit_logs_not_deleted() {
    # 4.1.2.2 Ensure audit logs are not automatically deleted
    local max_log_file_action=$(grep -E "^\s*max_log_file_action\s*=" /etc/audit/auditd.conf | awk -F= '{print $2}')
    if [ -z "$max_log_file_action" ]; then
        echo "max_log_file_action is not set in /etc/audit/auditd.conf. Setting it to keep_logs..."
        if ! sed -i '/^\s*max_log_file_action\s*=/d' /etc/audit/auditd.conf >/dev/null 2>&1; then
            echo "Failed to delete max_log_file_action from /etc/audit/auditd.conf."
            return 1
        fi
        if ! echo "max_log_file_action = keep_logs" >> /etc/audit/auditd.conf; then
            echo "Failed to set max_log_file_action to keep_logs in /etc/audit/auditd.conf."
            return 1
        fi
    elif [ "$max_log_file_action" != "keep_logs" ]; then
        echo "max_log_file_action is set to $max_log_file_action in /etc/audit/auditd.conf. Setting it to keep_logs..."
        if ! sed -i "s/^\s*max_log_file_action\s*=.*/max_log_file_action = keep_logs/" /etc/audit/auditd.conf >/dev/null 2>&1; then
            echo "Failed to set max_log_file_action to keep_logs in /etc/audit/auditd.conf."
            return 1
        fi
    else
        echo "Audit logs are not automatically deleted."
    fi
}

ensure_audit_logs_full_action_configured() {
    # 4.1.2.3 Ensure system is disabled when audit logs are full
    local disk_full_action=$(grep -E "^\s*disk_full_action\s*=" /etc/audit/auditd.conf | awk -F= '{print $2}')
    if [ -z "$disk_full_action" ]; then
        echo "disk_full_action is not set in /etc/audit/auditd.conf. Setting it to halt..."
        if ! sed -i '/^\s*disk_full_action\s*=/d' /etc/audit/auditd.conf >/dev/null 2>&1; then
            echo "Failed to delete disk_full_action from /etc/audit/auditd.conf."
            return 1
        fi
        if ! echo "disk_full_action = halt" >> /etc/audit/auditd.conf; then
            echo "Failed to set disk_full_action to halt in /etc/audit/auditd.conf."
            return 1
        fi
    elif [ "$disk_full_action" != "halt" ]; then
        echo "disk_full_action is set to $disk_full_action in /etc/audit/auditd.conf. Setting it to halt..."
        if ! sed -i "s/^\s*disk_full_action\s*=.*/disk_full_action = halt/" /etc/audit/auditd.conf >/dev/null 2>&1; then
            echo "Failed to set disk_full_action to halt in /etc/audit/auditd.conf."
            return 1
        fi
    else
        echo "System is disabled when audit logs are full."
    fi
}

ensure_sudoers_changes_collected() {
    # 4.1.3.1 Ensure changes to system administration scope (sudoers) is collected
    if ! grep -q "^\s*Defaults\s*log_input" /etc/sudoers /etc/sudoers.d/*; then
        echo "Defaults log_input is not set in /etc/sudoers or /etc/sudoers.d/* files. Setting it now..."
        if ! echo "Defaults log_input" >> /etc/sudoers; then
            echo "Failed to set Defaults log_input in /etc/sudoers."
            return 1
        fi
        if ! echo "Defaults log_input" >> /etc/sudoers.d/*; then
            echo "Failed to set Defaults log_input in /etc/sudoers.d/* files."
            return 1
        fi
    else
        echo "Changes to system administration scope (sudoers) are being collected."
    fi
}

ensure_actions_as_another_user_logged() {
    # 4.1.3.2 Ensure actions as another user are always logged
    if ! grep -q "^\s*Defaults\s*log_output" /etc/sudoers /etc/sudoers.d/*; then
        echo "Defaults log_output is not set in /etc/sudoers or /etc/sudoers.d/* files. Setting it now..."
        if ! echo "Defaults log_output" >> /etc/sudoers; then
            echo "Failed to set Defaults log_output in /etc/sudoers."
            return 1
        fi
        if ! echo "Defaults log_output" >> /etc/sudoers.d/*; then
            echo "Failed to set Defaults log_output in /etc/sudoers.d/* files."
            return 1
        fi
    else
        echo "Actions as another user are always logged."
    fi
}

ensure_sudo_log_file_changes_collected() {
    # 4.1.3.3 Ensure events that modify the sudo log file are collected
    if ! grep -q "^\s*Defaults\s*log_file" /etc/sudoers /etc/sudoers.d/*; then
        echo "Defaults log_file is not set in /etc/sudoers or /etc/sudoers.d/* files. Setting it now..."
        if ! echo "Defaults log_file=/var/log/sudo.log" >> /etc/sudoers; then
            echo "Failed to set Defaults log_file in /etc/sudoers."
            return 1
        fi
        if ! echo "Defaults log_file=/var/log/sudo.log" >> /etc/sudoers.d/*; then
            echo "Failed to set Defaults log_file in /etc/sudoers.d/* files."
            return 1
        fi
    else
        echo "Events that modify the sudo log file are being collected."
    fi
}

ensure_time_modification_events_collected() {
    # 4.1.3.4 Ensure events that modify date and time information are collected
    if ! grep -q "time-change" /etc/audit/rules.d/*.rules; then
        echo "time-change rule is not present in /etc/audit/rules.d/*.rules files. Adding it now..."
        if ! echo "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change" >> /etc/audit/rules.d/time.rules; then
            echo "Failed to add time-change rule to /etc/audit/rules.d/time.rules."
            return 1
        fi
        if ! echo "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" >> /etc/audit/rules.d/time.rules; then
            echo "Failed to add time-change rule to /etc/audit/rules.d/time.rules."
            return 1
        fi
        if ! echo "-a always,exit -F arch=b64 -S clock_settime -k time-change" >> /etc/audit/rules.d/time.rules; then
            echo "Failed to add time-change rule to /etc/audit/rules.d/time.rules."
            return 1
        fi
        if ! echo "-a always,exit -F arch=b32 -S clock_settime -k time-change" >> /etc/audit/rules.d/time.rules; then
            echo "Failed to add time-change rule to /etc/audit/rules.d/time.rules."
            return 1
        fi
        if ! echo "-w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/time.rules; then
            echo "Failed to add time-change rule to /etc/audit/rules.d/time.rules."
            return 1
        fi
        if ! echo "-w /etc/timezone -p wa -k time-change" >> /etc/audit/rules.d/time.rules; then
            echo "Failed to add time-change rule to /etc/audit/rules.d/time.rules."
            return 1
        fi
        service auditd restart
    else
        echo "Events that modify date and time information are being collected."
    fi
}
