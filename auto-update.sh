#!/bin/bash
#File created by create.sh (CPdA-Omi)

# Author : CPdA-Omi
# Creation Date : november 19 2024
# Last update : 05/21/2025 (MM/DD/YYYY)

author="CPdA-Omi"
version="v1.2.0 - Eve"
project="Shell Experiments"

displayVersion() {
	hypertext() {
		if [ $# -ne 2 ]; then
			return 1
		fi
		echo -ne "\e]8;;$2\e\\$1\e]8;;\e\\"
	}

	missingSpaces() {
		if [ $# -ne 2 ]; then
			return 1
		fi

		echo -n "$1"
		for _ in $(seq 1 $(($2-${#1}))); do
			echo -n " "
		done
	}
	missingSpacesNumber=29
	echo -e "
  #============ auto-update data ============#
  |                                          |
  |  author:    $(hypertext "$author" "https://github.com/${author}/")$(missingSpaces "" $(($missingSpacesNumber-${#author})))|
  |  version:   $(missingSpaces "$version" $missingSpacesNumber)|
  |  project:   $(missingSpaces "$project" $missingSpacesNumber)|
  |                                          |
  #==========================================#
"
}

guide() {
	if [ "$1" = "noColors" ]; then
		echo "
  #=============================== Welcome to auto-update.sh help ===============================#
  |
  |	SYNOPSIS
  |		auto-update.sh [OPTION...]
  |
  |	DESCRIPTION
  |		auto-update.sh is a shell scripts which automatically update your linux
  |		installation.
  |
  |	OPTIONS
  |	    Generic Program Information
  |		-v, --version
  |			Output the version number, its name and exit.
  |		-h, --help
  |			Open this message and exit.
  |		-H, --colored-help
  |			Open a colored version of this message and exit.
  |
  |	AUTHOR
  |		Written by CPdA-Omi.
  |
  |
  |	v1.2.0 - Eve     May 2025
  |
  #==============================================================================================#
"
	else
		bold() {
			echo -ne "\e[1m$1\e[22m"
		}
		underline() {
			echo -ne "\e[4m$1\e[24m"
		}
		border() {
			echo -ne "  \e[33;1m|\e[0m\t"
		}
		echo -e "
  \e[1m#\e[33m===============================\e[39m Welcome to auto-update.sh help \e[33m===============================\e[39m#\e[0m
$(border)
$(border)$(bold "SYNOPSIS")
$(border)	$(bold "auto-update.sh") [$(underline "OPTION")...]
$(border)
$(border)$(bold "DESCRIPTION")
$(border)	auto-update.sh is a shell scripts which automatically update your linux
$(border)	installation.
$(border)
$(border)$(bold "OPTIONS")
$(border)   $(bold "Generic Program Information")
$(border)	$(bold "-v"), $(bold "--version")
$(border)		Output the version number, its name and exit.
$(border)	$(bold "-h"), $(bold "--help")
$(border)		Open a colorless version of this message and exit.
$(border)	$(bold "-H"), $(bold "--colored-help")
$(border)		Open this message and exit.
$(border)
$(border)$(bold "AUTHOR")
$(border)	Written by $(bold "$author").
$(border)
$(border)
$(border)${version}     May 2025
$(border)
  \e[1m#\e[33m==============================================================================================\e[39m#\e[0m
" | less
	fi
}

case $1 in
	"-v"|"--version")
		displayVersion
		exit 0
		;;
	"-h"|"--help")
		guide "noColors"
		exit 0
		;;
	"-H"|"--colored-help")
		guide
		exit 0
		;;
esac

sudo echo -e "\e[1;31mRunning $(basename $0)...\e[0m"

echo -e "\n\e[1;33m -- First autoclean --\n----------------------\e[0m\n"

sudo apt autoclean
sudo apt-get autoclean

echo -e "\n\e[1;36m      -- Apt --\n----------------------\e[0m\n"

sudo apt -y update
sudo apt -y upgrade

echo -e "\n\e[1;34m    -- Apt-Get --\n----------------------\e[0m\n"

sudo apt-get -y upgrade
sudo apt-get -y upgrade

echo -e "\n\e[1;35m -- Last autoclean --\n----------------------\e[0m\n"

sudo apt autoclean
sudo apt-get autoclean
sudo apt -y autoremove

echo -e "\n\e[1;32m      -- Done --\n----------------------\e[0m"

