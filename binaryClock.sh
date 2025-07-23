#!/bin/bash
#File created by create.sh (CPdA-Omi)

# Author : CPdA-Omi
# Creation Date : september 17 2024
# Last update : 05/21/2025 (MM/DD/YYYY)

author="CPdA-Omi"
version="v1.1.0 - CNMN"
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
  #============ binaryClock data ============#
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
  #=============================== Welcome to binaryClock.sh help ===============================#
  |
  |	SYNOPSIS
  |		binaryClock.sh [OPTION...]
  |
  |	DESCRIPTION
  |		binaryClock.sh is a shell scripts which displays a binary clock.
  |		This script is an infinite loop, just do a ctrl+C to stop it.
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
  |	    Behaviour Influence
  |		-w, --window
  |			Displays the clock in another window instead of the current terminal.
  |
  |	KNOWN BUGS
  |		Launching the program may cause an internal error when a second, minute or hour
  |		is equals to 0. The program must be stopped and relaunched to work properly.
  |
  |	AUTHOR
  |		Written by CPdA-Omi.
  |
  |
  |	v1.1.0 - CNMN     May 2025
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
  \e[1m#\e[33m===============================\e[39m Welcome to binaryClock.sh help \e[33m===============================\e[39m#\e[0m
$(border)
$(border)$(bold "SYNOPSIS")
$(border)	$(bold "binaryClock.sh") [$(underline "OPTION")...]
$(border)
$(border)$(bold "DESCRIPTION")
$(border)	binaryClock.sh is a shell scripts which displays a binary clock.
$(border)	$(underline "This script is an infinite loop, just do a ctrl+C to stop it.")
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
$(border)   $(bold "Behaviour Influence")
$(border)	$(bold "-w"), $(bold "--window")
$(border)		Displays the clock in another window instead of the current terminal.
$(border)
$(border)$(bold "KNOWN BUGS")
$(border)	Launching the program may cause an internal error when a second, minute or hour
$(border)	is equals to 0. The program must be stopped and relaunched to work properly.
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

onColor="\e[32m"
offColor="\e[2m"
resetColor="\e[0m"

onPoint() {
	echo -ne "${onColor}●${resetColor}"
}

offPoint() {
	echo -ne "${offColor}●${resetColor}"
}

clock() {

	time=$(date | cut -d ' ' -f 5)
	hours=$(echo $time | cut -d ":" -f 1)
	minutes=$(echo $time | cut -d ":" -f 2)
	seconds=$(echo $time | cut -d ":" -f 3)
	lastSeconds=$(($seconds -1))

	while [ 1 ]; do
		time=$(date | cut -d ' ' -f 5)
		hours=$(echo $time | cut -d ":" -f 1)
		minutes=$(echo $time | cut -d ":" -f 2)
		seconds=$(echo $time | cut -d ":" -f 3)
		
		if [ ${lastSeconds:1:2} -ne ${seconds:1:2} ]; then
			lastSeconds=$seconds
		
			clear
			
			echo -ne "\t"
			if [ ${hours:1:2} -ge 8 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t\t"
			if [ ${minutes:1:2} -ge 8 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t\t"
			if [ ${seconds:1:2} -ge 8 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\n\t"
			
			if [ ${hours:1:2} -ge 4 ] && [ ${hours:1:2} -lt 8 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ ${minutes:0:1} -ge 4 ] && [ ${minutes:0:1} -lt 8 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ ${minutes:1:2} -ge 4 ] && [ ${minutes:1:2} -lt 8 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ ${seconds:0:1} -ge 4 ] && [ ${seconds:0:1} -lt 8 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ ${seconds:1:2} -ge 4 ] && [ ${seconds:1:2} -lt 8 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\n"
			
			if [ ${hours:0:1} -eq 2 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ ${hours:1:2} -eq 2 ] || [ ${hours:1:2} -eq 3 ] || [ ${hours:1:2} -eq 6 ] || [ ${hours:1:2} -eq 7 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ ${minutes:0:1} -eq 2 ] || [ ${minutes:0:1} -eq 3 ] || [ ${minutes:0:1} -eq 6 ] || [ ${minutes:0:1} -eq 7 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ ${minutes:1:2} -eq 2 ] || [ ${minutes:1:2} -eq 3 ] || [ ${minutes:1:2} -eq 6 ] || [ ${minutes:1:2} -eq 7 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ ${seconds:0:1} -eq 2 ] || [ ${seconds:0:1} -eq 3 ] || [ ${seconds:0:1} -eq 6 ] || [ ${seconds:0:1} -eq 7 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ ${seconds:1:2} -eq 2 ] || [ ${seconds:1:2} -eq 3 ] || [ ${seconds:1:2} -eq 6 ] || [ ${seconds:1:2} -eq 7 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\n"
			
			if [ $((${hours:0:1} % 2)) -eq 1 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ $((${hours:1:2} % 2)) -eq 1 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ $((${minutes:0:1} % 2)) -eq 1 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ $((${minutes:1:2} % 2)) -eq 1 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ $((${seconds:0:1} % 2)) -eq 1 ]; then
				onPoint
			else
				offPoint
			fi
			echo -ne "\t"
			if [ $((${seconds:1:2} % 2)) -eq 1 ]; then
				onPoint
			else
				offPoint
			fi
			echo ""
		fi
	done
}

if [ $# -eq 1 ] && [ $1 = "-w" -o $1 = "--window" ]; then
	gnome-terminal --title "Binary Clock" --zoom=2 --geometry=45x6 -- ./$(basename $0)
else
	clock
fi

