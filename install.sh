#!/usr/bin/bash

if (($EUID != 0))
    then echo "[ERROR] Requires root privileges."
else
    cp gclone.rb gclone
    chmod +x gclone
    mv gclone /usr/bin/gclone
    echo "gclone has successfully been installed."
fi
