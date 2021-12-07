#!/bin/zsh

# Globals 
declare -A wanted

# Homebrew Specific
which brew
[ $? -eq 1 ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Read AppList.conf and question if we want it or not
function readConf {
	while read line; do
		read -q "wants?$line Wanted (y/n): "
		[ ${wants} = "y" ] && wanted[$line]="y" || wanted[$line]="n"
		echo
	done < AppList.conf
}

# Confirm it looks good
function listWanted {
	echo "#---- Verification ----#"
	for key value in ${(kv)wanted}; do
		[ "$value" = "y" ] && echo "${key} -> YES" || echo "${key} -> SKIP"
	done
	read -q "cont?Does this look correct? (y/n)"
	echo "" 
	[ $cont = "n" ] && echo -e "\nExiting... " && exit 0
}

# Brew install all
function installPhase {
	for key value in ${(kv)wanted}; do
		[ $value = "y" ] && brew install $key || echo "Skipping $key"
	done 
}

# Copy some files to the spots I like
function copyFilesInPlace {
	[ -d "$HOME/.config" ] || mkdir "${HOME}/.config"
	cp -r $pwd/config/* ${HOME}/.config
	cp -r $pwd/home/* ${HOME}/
}

# Trigger em!
readConf
listWanted
installPhase
