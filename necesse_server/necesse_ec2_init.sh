#!/bin/bash


# Install steamCMD dependencies and download + install steamCMD
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y lib32gcc1
sudo apt install -y lib32gcc-s1
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -


# Create config file to manage steamCMD
cat >$HOME/update_necesse.txt <<'EOL'
@ShutdownOnFailedCommand 1 //Set to 0 if updating more than one server.
@NoPromptForPassword 1
force_install_dir /home/necesse/
login anonymous  // Necesse dedicated server is available as anonymous. Thank you Fair!
app_update 1169370 validate
quit
EOL


# Run steamCMD and point to config file to install + update server
$HOME/steamcmd.sh +runscript $HOME/update_necesse.txt
