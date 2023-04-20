#!/usr/bin/env bash

# ============================================================ #
# Tool Created date: 19 abr 2023                               #
# Tool Created by: Henrique Silva (rick.0x00@gmail.com)        #
# Tool Name: srv_ldap                                          #
# Description: script for help to creation ldap server         #
# License: MIT License                                         #
# Remote repository 1: https://github.com/rick0x00/srv_ldap    #
# Remote repository 2: https://gitlab.com/rick0x00/srv_ldap    #
# ============================================================ #

# ============================================================ #
# start root user checking
if [ $(id -u) -ne 0 ]; then
    echo "Please use root user to run the script."
    exit 1
fi
# end root user checking
# ============================================================ #
# start set variables

domain_name="rick0x00.com.br"
admin_password="admin"

# end set variables
# ============================================================ #
# start definition functions
# ============================== #
# start complement functions

# end complement functions
# ============================== #
# start main functions
function install_openldap_server () {
    apt update
    # debconf template: https://salsa.debian.org/openldap-team/openldap/-/blob/master/debian/slapd.templates
    # Omit OpenLDAP server configuration? = false
    echo "slapd slapd/no_configuration boolean false" | debconf-set-selections
    # DNS domain name = $domain_name
    echo "slapd slapd/domain string $domain_name" | debconf-set-selections
    # Organization name = $domain_name
    echo "slapd shared/organization string $domain_name" | debconf-set-selections
    # Administrator password = $admin_password
    echo "slapd slapd/password1 password $admin_password" | debconf-set-selections
    echo "slapd slapd/password2 password $admin_password" | debconf-set-selections
    # Do you want the database to be removed when slapd is purged? = false
    echo "slapd slapd/purge_database boolean false" | debconf-set-selections
    # Move old database? = true
    echo "slapd slapd/move_old_database boolean true" | debconf-set-selections
    apt install -y slapd ldap-utils
}

function start_openldap_server () {
    systemctl enable --now slapd
    systemctl status slapd
    # /usr/sbin/slapd -d 2 -h "ldap:/// ldapi:///" -g openldap -u openldap -F /etc/ldap/slapd.d # execute inside docker container
}
# end main functions
# ============================== #
# end definition functions
# ============================================================ #
# start argument reading

# end argument reading
# ============================================================ #
# start main executions of code

install_openldap_server;
start_openldap_server;