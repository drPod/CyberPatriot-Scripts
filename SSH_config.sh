#!/bin/bash

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
