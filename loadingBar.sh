#!/bin/bash
#File created by create.sh (CPdA-Omi)

# Author : CPdA-Omi
# Creation Date : july 25 2024
# Last update : 06/30/2025 (MM/DD/YYYY)

author="CPdA-Omi"
version="v1.0.0 - BkSlshR"
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
	missingSpacesNumber=28
	echo -e "
  #============ loadingBar data ============#
  |                                         |
  |  author:    $(hypertext "$author" "https://github.com/${author}/")$(missingSpaces "" $(($missingSpacesNumber-${#author})))|
  |  version:   $(missingSpaces "$version" $missingSpacesNumber)|
  |  project:   $(missingSpaces "$project" $missingSpacesNumber)|
  |                                         |
  #=========================================#
"
}

guide() {
	if [ "$1" = "noColors" ]; then
		echo "
  #=============================== Welcome to loadingBar.sh help ===============================#
  |
  |	SYNOPSIS
  |		loadingBar.sh NUMBER
  |
  |	DESCRIPTION
  |		loadingBar.sh is a shell scripts which displays a certain number of loading bars.
  |		Less loading bars there are, faster they are.
  |		This script must be launched in source mod.
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
  |	KNOWN BUGS
  |		Launching the program using \"./\" is not working due to the use of the terminal
  |		variable \"COLUMNS\".
  |
  |	AUTHOR
  |		Written by CPdA-Omi.
  |
  |
  |	v1.0.0 - BkSlshR     May 2025
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
  \e[1m#\e[33m===============================\e[39m Welcome to loadingBar.sh help \e[33m===============================\e[39m#\e[0m
$(border)
$(border)$(bold "SYNOPSIS")
$(border)	$(bold "loadingBar.sh") [$(underline "OPTION")...]
$(border)
$(border)$(bold "DESCRIPTION")
$(border)	loadingBar.sh is a shell scripts which displays a certain number of loading bars.
$(border)	Less loading bars there are, faster they are.
$(border)	$(underline "This script must be launched in source mod.")
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
$(border)$(bold "KNOWN BUGS")
$(border)	Launching the program using \"./\" is not working due to the use of the terminal
$(border)	variable \"COLUMNS\".
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

conditionalStop() {
	if [ ${#-} -lt 4 ]; then
		exit 0
	else
		return 0
	fi
}

case $1 in
	"-v"|"--version")
		displayVersion
		conditionalStop
		;;
	"-h"|"--help")
		guide "noColors"
		conditionalStop
		;;
	"-H"|"--colored-help")
		guide
		conditionalStop
		;;
esac

if [ ${#-} -lt 4 ]; then
	echo -e "\e[31mERROR: This script must be launched in source mod\e[39m" >&2
	exit 1
fi

if [ $# -ne 1 ]; then
	echo -e "\e[31mERROR: This script requires one argument\e[39m" >&2
	return 5
elif ! [[ $1 =~ ^[0-9]{1,}$ ]]; then
	echo -e "\e[31mERROR: This script only except numbers as arguments\e[39m" >&2
	return 5
fi

prefix='|'
symbole='='
suffix='|'

for i in $(seq 1 $1); do
	for j in $(seq 1 $(($COLUMNS -2))); do
		echo -n "$prefix"
		for _ in $(seq 1 $j); do
			echo -n "$symbole"
		done
		echo -en "$suffix\r"
		sleep $((0.001* ($RANDOM % ($1/$i))))
	done
	echo ""
done

unset {prefix,symbole,suffix}
