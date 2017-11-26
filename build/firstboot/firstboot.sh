#!/bin/bash

FB=/root/firstboot
CRUMB=${FB}/firstboot_done

# Exit cleanly if firstboot has already run
if [ -f "$CRUMB" ]; then
    exit 0
fi

${FB}/create_device_tree_1wire.sh

${FB}/install_sauri.sh

/usr/bin/touch "$CRUMB"
