#!/usr/bin/bash

run0 sh -c '
        mkdir --parents --mode=755 --context=system_u:object_r:usbguard_conf_t:s0 /etc/usbguard
        mkdir --parents --mode=755 --context=system_u:object_r:usbguard_log_t:s0  /var/log/usbguard
        usbguard generate-policy > /etc/usbguard/rules.conf
        sed -i "/IPCAllowedGroups=wheel/s/$/ usbguard/" /etc/usbguard/usbguard-daemon.conf
        systemctl enable --now usbguard.service
        usbguard add-user $1
    ' -- $USER

systemctl enable --user --now usbguard-notifier.service
