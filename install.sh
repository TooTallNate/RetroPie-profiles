#!/usr/bin/env bash
# install script that does the following:
# - put `login.sh` in `$HOME/RetroPie/retropiemenu/` directory
# - put `icon.png` in `$HOME/RetroPie/retropiemenu/icons` directory
# - create a gamelist.xml entry for `login.sh`


echo -n "Putting \"login.sh\" in \"$HOME/RetroPie/retropiemenu/\"..."
cp login.sh "$HOME/RetroPie/retropiemenu/login.sh" || {
  echo -e "\nUnable to put \"login.sh\" in \"$HOME/RetroPie/retropiemenu/\". Aborting."
  exit 1
}
echo " OK!"


echo -n "Putting \"icon.png\" in \"$HOME/RetroPie/retropiemenu/icons\"..."
cp icon.png "$HOME/RetroPie/retropiemenu/icons/save-profiles.png" || {
  echo -e "\nUnable to put \"icon.png\" in \"$HOME/RetroPie/retropiemenu/icons\". Aborting."
  exit 1
}
echo " OK!"


echo -n "Creating a gamelist.xml entry for login.sh..."
gamelistxml="$HOME/RetroPie/retropiemenu/gamelist.xml"
[[ -f "$gamelistxml" ]] || {
  cp "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml" \
    "$gamelistxml"
}

grep -q "<path>./login.sh</path>" "$gamelistxml" && {
  echo " OK!!"
  exit 0
}

gamelist_info='\
  <game>\
    <path>.\/login.sh<\/path>\
    <name>Save Profiles<\/name>\
    <desc>Select which profile to use for save files and save states.<\/desc>\
    <image>.\/icons\/save-profiles.png<\/image>\
  <\/game>'

sudo sed -i.bak "/<\/gameList>/ s/.*/${gamelist_info}\n&/" "$gamelistxml" || {
  echo "Warning: Unable to edit \"$gamelistxml\"."
  exit 1
}
echo " OK!"

# ensuring that the /opt/retropie/configs/all dir is owned by the user
user="$SUDO_USER"
[[ -z "$user" ]] && user=$(id -un)
sudo chown $user.$user /opt/retropie/configs/all
