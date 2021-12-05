#!/bin/zsh

# Globals 
declare -A wanted
listed=()

# Homebrew Specific
which brew
[ $? -eq 1 ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

function readConf {
	while read line; do
		read -q "wants?$line Wanted (y/n): "
		[ ${wants} = "y" ] && wanted[$line]="y" || wanted[$line]="n"
		echo
	done < AppList.conf
}

function listWanted {
	echo "#---- Verification ----#"
	for key value in ${(kv)wanted}; do
		[ "$value" = "y" ] && echo "$key -> YES" || echo "$key -> SKIP"
	done
	read -q "cont?Does this look correct? (y/n)"
	echo "" 
	[ $cont = "n" ] && echo -e "\nExiting... " && exit 0
}

function installPhase {
	for key value in ${(kv)wanted}; do
		[ $value = "y" ] && brew install $key || echo "Skipping $key"
	done 
}

function copyFilesInPlace {
	[ -d "$HOME/.config" ] || mkdir "${HOME}/.config"
	cp -r $pwd/config/* ${HOME}/.config
	cp -r $pwd/home/* ${HOME}/
}

readConf
listWanted
installPhase
