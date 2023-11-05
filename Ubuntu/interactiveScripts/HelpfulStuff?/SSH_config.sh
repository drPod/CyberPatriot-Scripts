#!/bin/bash

# This script is a subset of CIS Module 5. It is ran separately from the main script because sometimes the machine might not want us to touch ssh

# 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured
ensure_sshd_config_permissions_config() {
    if [[ -e /etc/ssh/sshd_config ]]; then
        chmod 600 /etc/ssh/sshd_config
    else
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi
}

# 5.2.2 Ensure permissions on SSH private host key files are configured
ensure_sshd_config_permissions_rsa_key() {
    if [[ -e /etc/ssh/ssh_host_rsa_key ]]; then
        chmod 600 /etc/ssh/ssh_host_rsa_key
    else
        echo "Error: /etc/ssh/ssh_host_rsa_key does not exist"
        return 1
    fi
}

# 5.2.2 Ensure permissions on SSH private host key files are configured
ensure_sshd_config_permissions_edcsa_key() {
    if [[ -e /etc/ssh/ssh_host_ecdsa_key ]]; then
        chmod 600 /etc/ssh/ssh_host_ecdsa_key
    else
        echo "Error: /etc/ssh/ssh_host_ecdsa_key does not exist"
        return 1
    fi
}

# 5.2.2 Ensure permissions on SSH private host key files are configured
ensure_sshd_config_permissions_ed25519_key() {
    if [[ -e /etc/ssh/ssh_host_ed25519_key ]]; then
        chmod 600 /etc/ssh/ssh_host_ed25519_key
    else
        echo "Error: /etc/ssh/ssh_host_ed25519_key does not exist"
        return 1
    fi
}

ensure_sshd_config_permissions_config
ensure_sshd_config_permissions_rsa_key
ensure_sshd_config_permissions_edcsa_key
ensure_sshd_config_permissions_ed25519_key

# 5.2.3 Ensure permissions on SSH public host key files are configured
ensure_sshd_config_permissions_rsa_pub_key() {
    if [[ -e /etc/ssh/ssh_host_rsa_key.pub ]]; then
        chmod 644 /etc/ssh/ssh_host_rsa_key.pub
    else
        echo "Error: /etc/ssh/ssh_host_rsa_key.pub does not exist"
        return 1
    fi
}

# 5.2.3 Ensure permissions on SSH public host key files are configured
ensure_sshd_config_permissions_edcsa_pub_key() {
    if [[ -e /etc/ssh/ssh_host_ecdsa_key.pub ]]; then
        chmod 644 /etc/ssh/ssh_host_ecdsa_key.pub
    else
        echo "Error: /etc/ssh/ssh_host_ecdsa_key.pub does not exist"
        return 1
    fi
}

# 5.2.3 Ensure permissions on SSH public host key files are configured
ensure_sshd_config_permissions_ed25519_pub_key() {
    if [[ -e /etc/ssh/ssh_host_ed25519_key.pub ]]; then
        chmod 644 /etc/ssh/ssh_host_ed25519_key.pub
    else
        echo "Error: /etc/ssh/ssh_host_ed25519_key.pub does not exist"
        return 1
    fi
}

ensure_sshd_config_permissions_rsa_pub_key
ensure_sshd_config_permissions_edcsa_pub_key
ensure_sshd_config_permissions_ed25519_pub_key

# 5.2.4 Ensure SSH access is limited
ensure_ssh_access_is_limited() {
    echo "Ensure SSH access is limited manually, too lazy to write a script that does that"
}

ensure_ssh_access_is_limited

# 5.2.5 Ensure SSH LogLevel is appropriate
ensure_ssh_log_level_is_appropriate() {
    if [[ -e /etc/ssh/sshd_config ]]; then
        sed -i "s/^LogLevel.*/LogLevel VERBOSE/g" /etc/ssh/sshd_config
    else
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi
}

# 5.2.5 Ensure SSH LogLevel is appropriate
ensure_ssh_log_level_is_appropriate

ensure_ssh_pam_enabled() {
    if [[ -e /etc/ssh/sshd_config ]]; then
        if grep -q "^UsePAM" /etc/ssh/sshd_config; then
            sed -i "s/^#UsePAM.*/UsePAM yes/g" /etc/ssh/sshd_config
        else
            echo "UsePAM yes" >>/etc/ssh/sshd_config
        fi
    else
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi
}

ensure_ssh_pam_enabled

ensure_ssh_root_login_disabled() {
    if [[ -e /etc/ssh/sshd_config ]]; then
        if grep -q "^PermitRootLogin" /etc/ssh/sshd_config; then
            sed -i "s/^PermitRootLogin.*/PermitRootLogin no/g" /etc/ssh/sshd_config
        else
            echo "PermitRootLogin no" >>/etc/ssh/sshd_config
        fi
    else
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi
}

ensure_ssh_root_login_disabled

# 5.2.8 Ensure SSH HostbasedAuthentication is disabled
ensure_ssh_hostbased_authentication_disabled() {
    HostbasedAuthentication no
    if [[ -e /etc/ssh/sshd_config ]]; then
        if grep -q "^HostbasedAuthentication" /etc/ssh/sshd_config; then
            sed -i "s/^HostbasedAuthentication.*/HostbasedAuthentication no/g" /etc/ssh/sshd_config
        else
            echo "HostbasedAuthentication no" >>/etc/ssh/sshd_config
        fi
    else
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi
}

ensure_ssh_hostbased_authentication_disabled

# 5.2.9 Ensure SSH PermitEmptyPasswords is disabled
ensure_ssh_permit_empty_passwords_disabled() {
    if [[ -e /etc/ssh/sshd_config ]]; then
        if grep -q "^PermitEmptyPasswords" /etc/ssh/sshd_config; then
            sed -i "s/^PermitEmptyPasswords.*/PermitEmptyPasswords no/g" /etc/ssh/sshd_config
        else
            echo "PermitEmptyPasswords no" >>/etc/ssh/sshd_config
        fi
    else
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi
}

ensure_ssh_permit_empty_passwords_disabled

# 5.2.10 Ensure SSH PermitUserEnvironment is disabled
ensure_ssh_permit_user_environment_disabled() {
    if [[ -e /etc/ssh/sshd_config ]]; then
        if grep -q "^PermitUserEnvironment" /etc/ssh/sshd_config; then
            sed -i "s/^PermitUserEnvironment.*/PermitUserEnvironment no/g" /etc/ssh/sshd_config
        else
            echo "PermitUserEnvironment no" >>/etc/ssh/sshd_config
        fi
    else
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi
}

ensure_ssh_permit_user_environment_disabled

# 5.2.11 Ensure SSH IgnoreRhosts is enabled
ensure_ssh_ignore_rhosts_enabled() {
    IgnoreRhosts yes
    if [[ -e /etc/ssh/sshd_config ]]; then
        if grep -q "^IgnoreRhosts" /etc/ssh/sshd_config; then
            sed -i "s/^IgnoreRhosts.*/IgnoreRhosts yes/g" /etc/ssh/sshd_config
        else
            echo "IgnoreRhosts yes" >>/etc/ssh/sshd_config
        fi
    else
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi
}

ensure_ssh_ignore_rhosts_enabled

# 5.2.12 Ensure SSH X11 forwarding is disabled
ensure_ssh_x11_forwarding_disabled() {
    if [[ -e /etc/ssh/sshd_config ]]; then
        if grep -q "^X11Forwarding" /etc/ssh/sshd_config; then
            sed -i "s/^X11Forwarding.*/X11Forwarding no/g" /etc/ssh/sshd_config
        else
            echo "X11Forwarding no" >>/etc/ssh/sshd_config
        fi
    else
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi
}

ensure_ssh_x11_forwarding_disabled

# 5.2.13 Ensure only strong Ciphers are used
ensure_strong_ciphers_used() {
    Ciphers aes128-ctr,aes192-ctr,aes256-ctr
    # Define the list of strong ciphers
    STRONG_CIPHERS="aes128-ctr,aes192-ctr,aes256-ctr"

    # Check if the sshd_config file exists
    if [[ ! -e /etc/ssh/sshd_config ]]; then
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi

    # Check if the ciphers are already set
    if grep -q "^Ciphers" /etc/ssh/sshd_config; then
        # Replace the existing ciphers with the strong ciphers
        sed -i "s/^Ciphers.*/Ciphers $STRONG_CIPHERS/g" /etc/ssh/sshd_config
    else
        # Add the strong ciphers to the end of the file
        echo "# Ensure only strong ciphers are used" >>/etc/ssh/sshd_config
        echo "Ciphers $STRONG_CIPHERS" >>/etc/ssh/sshd_config
    fi
}

ensure_strong_ciphers_used

# 5.2.14 Ensure only strong MAC algorithms are used
ensure_strong_MAC_algorithms_used() {
    # Define the list of strong MAC algorithms
    STRONG_MACS="hmac-sha2-256,hmac-sha2-512"

    # Check if the sshd_config file exists
    if [[ ! -e /etc/ssh/sshd_config ]]; then
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi

    # Check if the MACs are already set
    if grep -q "^MACs" /etc/ssh/sshd_config; then
        # Replace the existing MACs with the strong MACs
        sed -i "s/^MACs.*/MACs $STRONG_MACS/g" /etc/ssh/sshd_config
    else
        # Add the strong MACs to the end of the file
        echo "# Ensure only strong MAC algorithms are used" >>/etc/ssh/sshd_config
        echo "MACs $STRONG_MACS" >>/etc/ssh/sshd_config
    fi
}

ensure_strong_MAC_algorithms_used

# 5.2.15 Ensure only strong Key Exchange algorithms are used
ensure_strong_key_exchange_algorithms_used() {
    # Define the list of strong Key Exchange algorithms
    STRONG_KEX_ALGORITHMS="diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512"

    # Check if the sshd_config file exists
    if [[ ! -e /etc/ssh/sshd_config ]]; then
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi

    # Check if the Key Exchange algorithms are already set
    if grep -q "^KexAlgorithms" /etc/ssh/sshd_config; then
        # Replace the existing Key Exchange algorithms with the strong Key Exchange algorithms
        sed -i "s/^KexAlgorithms.*/KexAlgorithms $STRONG_KEX_ALGORITHMS/g" /etc/ssh/sshd_config
    else
        # Add the strong Key Exchange algorithms to the end of the file
        echo "# Ensure only strong Key Exchange algorithms are used" >>/etc/ssh/sshd_config
        echo "KexAlgorithms $STRONG_KEX_ALGORITHMS" >>/etc/ssh/sshd_config
    fi
}

ensure_strong_key_exchange_algorithms_used

# 5.2.16 Ensure SSH AllowTcpForwarding is disabled
ensure_ssh_tcp_forwarding_disabled() {
    if [[ -e /etc/ssh/sshd_config ]]; then
        if grep -q "^AllowTcpForwarding" /etc/ssh/sshd_config; then
            sed -i "s/^AllowTcpForwarding.*/AllowTcpForwarding no/g" /etc/ssh/sshd_config
        else
            echo "AllowTcpForwarding no" >>/etc/ssh/sshd_config
        fi
    else
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi
}

ensure_ssh_tcp_forwarding_disabled

# 5.2.17 Ensure SSH warning banner is configured
ensure_ssh_warning_banner_configured() {
    # Add warning banner to /etc/issue.net file
    echo "WARNING: Unauthorized access to this system is prohibited. By accessing this system, you agree that your actions may be monitored and recorded." >/etc/issue.net

    # Configure SSH to use the warning banner
    if grep -q "^Banner" /etc/ssh/sshd_config; then
        sed -i "s/^Banner.*/Banner \/etc\/issue.net/g" /etc/ssh/sshd_config
    else
        echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
    fi
    # Define the warning banner message
    WARNING_BANNER="WARNING: Unauthorized access to this system is prohibited. By accessing this system, you agree that your actions may be monitored and recorded."

    # Check if the /etc/issue.net file exists
    if [[ ! -e /etc/issue.net ]]; then
        echo "Error: /etc/issue.net does not exist"
        return 1
    fi

    # Add the warning banner to the /etc/issue.net file
    echo "$WARNING_BANNER" >/etc/issue.net

    # Check if the sshd_config file exists
    if [[ ! -e /etc/ssh/sshd_config ]]; then
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi

    # Configure SSH to use the warning banner
    if grep -q "^Banner" /etc/ssh/sshd_config; then
        # Replace the existing Banner with the warning banner
        sed -i "s/^Banner.*/Banner \/etc\/issue.net/g" /etc/ssh/sshd_config
    else
        # Add the warning banner to the end of the file
        echo "# Ensure SSH warning banner is configured" >>/etc/ssh/sshd_config
        echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
    fi
}

ensure_ssh_warning_banner_configured

# 5.2.18 Ensure SSH MaxAuthTries is set to 4 or less
ensure_ssh_max_auth_tries() {
    # Check if the sshd_config file exists
    if [[ ! -e /etc/ssh/sshd_config ]]; then
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi

    # Check if MaxAuthTries is already set
    if grep -q "^MaxAuthTries" /etc/ssh/sshd_config; then
        # Replace the existing MaxAuthTries with 4 or less
        sed -i "s/^MaxAuthTries.*/MaxAuthTries 4/g" /etc/ssh/sshd_config
    else
        # Add MaxAuthTries to the end of the file
        echo "# Ensure SSH MaxAuthTries is set to 4 or less" >>/etc/ssh/sshd_config
        echo "MaxAuthTries 4" >>/etc/ssh/sshd_config
    fi
}

ensure_ssh_max_auth_tries

# 5.2.19 Ensure SSH MaxStartups is configured
ensure_ssh_max_startups_configured() {
    # Check if the sshd_config file exists
    if [[ ! -e /etc/ssh/sshd_config ]]; then
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi

    # Check if MaxStartups is already set
    if grep -q "^MaxStartups" /etc/ssh/sshd_config; then
        # Replace the existing MaxStartups with the recommended value
        sed -i "s/^MaxStartups.*/MaxStartups 10:30:60/g" /etc/ssh/sshd_config
    else
        # Add MaxStartups to the end of the file
        echo "# Ensure SSH MaxStartups is configured" >>/etc/ssh/sshd_config
        echo "MaxStartups 10:30:60" >>/etc/ssh/sshd_config
    fi
}

ensure_ssh_max_startups_configured

# 5.2.20 Ensure SSH MaxSessions is set to 10 or less
ensure_ssh_max_sessions_configured() {
    # Check if the sshd_config file exists
    if [[ ! -e /etc/ssh/sshd_config ]]; then
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi

    # Check if MaxSessions is already set
    if grep -q "^MaxSessions" /etc/ssh/sshd_config; then
        # Replace the existing MaxSessions with the recommended value
        sed -i "s/^MaxSessions.*/MaxSessions 10/g" /etc/ssh/sshd_config
    else
        # Add MaxSessions to the end of the file
        echo "# Ensure SSH MaxSessions is configured" >>/etc/ssh/sshd_config
        echo "MaxSessions 10" >>/etc/ssh/sshd_config
    fi
}

ensure_ssh_max_sessions_configured

# 5.2.21 Ensure SSH LoginGraceTime is set to one minute or less
ensure_ssh_login_grace_time_configured() {
    # Check if the sshd_config file exists
    if [[ ! -e /etc/ssh/sshd_config ]]; then
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi

    # Check if LoginGraceTime is already set
    if grep -q "^LoginGraceTime" /etc/ssh/sshd_config; then
        # Replace the existing LoginGraceTime with the recommended value
        sed -i "s/^LoginGraceTime.*/LoginGraceTime 1m/g" /etc/ssh/sshd_config
    else
        # Add LoginGraceTime to the end of the file
        echo "# Ensure SSH LoginGraceTime is set to one minute or less" >>/etc/ssh/sshd_config
        echo "LoginGraceTime 1m" >>/etc/ssh/sshd_config
    fi
}

ensure_ssh_login_grace_time_configured

ensure_ssh_idle_timeout_interval_configured() {
    # Check if the sshd_config file exists
    if [[ ! -e /etc/ssh/sshd_config ]]; then
        echo "Error: /etc/ssh/sshd_config does not exist"
        return 1
    fi

    # Set the ClientAliveInterval parameter to 300 seconds (5 minutes)
    sed -i "s/^#ClientAliveInterval.*/ClientAliveInterval 300/g" /etc/ssh/sshd_config

    # Set the ClientAliveCountMax parameter to 0 to disable the feature
    sed -i "s/^#ClientAliveCountMax.*/ClientAliveCountMax 0/g" /etc/ssh/sshd_config
}

ensure_ssh_idle_timeout_interval_configured
