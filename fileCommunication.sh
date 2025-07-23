#!/bin/bash
#File created by create.sh (CPdA-Omi)

# Author : CPdA-Omi
# Creation Date : may 18 2024
# Last update : 05/21/2025 (MM/DD/YYYY)

author="CPdA-Omi"
version="v1.3.0 - Kafey"
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
	missingSpacesNumber=35
	echo -e "
  #============ fileCommunication data ============#
  |                                                |
  |  author:    $(hypertext "$author" "https://github.com/${author}/")$(missingSpaces "" $(($missingSpacesNumber-${#author})))|
  |  version:   $(missingSpaces "$version" $missingSpacesNumber)|
  |  project:   $(missingSpaces "$project" $missingSpacesNumber)|
  |                                                |
  #================================================#
"
}

guide() {
	if [ "$1" = "noColors" ]; then
		echo "
  #============================ Welcome to fileCommunication.sh help ============================#
  |
  |	SYNOPSIS
  |		fileCommunication.sh -i
  |		fileCommunication.sh [OPTION...]
  |
  |	DESCRIPTION
  |		fileCommunication.sh is a shell scripts allowing multi terminal communication
  |		based on reading and writing a file.
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
  |		-p, --private
  |			Disable your message history.
  |
  |		-u NAME, --username NAME
  |			Define your username on the script. If not given, it will be prompted
  |			by the script.
  |
  |		-i, --interactive
  |			All behaviour influence options will be prompted to you to clearly
  |			decide the parameters of your future session.
  |
  |	AUTHOR
  |		Written by CPdA-Omi.
  |
  |
  |	v.1.3.0 - Kafey     May 2025
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
  \e[1m#\e[33m============================\e[39m Welcome to fileCommunication.sh help \e[33m============================\e[39m#\e[0m
$(border)
$(border)$(bold "SYNOPSIS")
$(border)	$(bold "fileCommunication.sh -i")
$(border)	$(bold "fileCommunication.sh") [$(underline "OPTION")...]
$(border)
$(border)$(bold "DESCRIPTION")
$(border)	fileCommunication.sh is a shell scripts allowing multi terminal communication
$(border)	based on reading and writing a file.
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
$(border)	$(bold "-p"), $(bold "--private")
$(border)		Disable your message history.
$(border)
$(border)	$(bold "-u $(underline "NAME")"), $(bold "--username $(underline "NAME")")
$(border)		Define your username on the script. If not given, it will be prompted
$(border)		by the script.
$(border)
$(border)	$(bold "-i"), $(bold "--interactive")
$(border)		All behaviour influence options will be prompted to you to clearly
$(border)		decide the parameters of your future session.
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

loopInputFilter() {
	local userInputBuffer=0
	while [ $(echo $userInputBuffer | tr A-Z a-z) != y -a $(echo $userInputBuffer | tr A-Z a-z) != n ]; do
		read -p "$1 [Y/n] " userInputBuffer
	done
	if [ $(echo $userInputBuffer | tr A-Z a-z) = n ]; then
		return 1
	else
		return 0
	fi
}

file=~/hello

if [ $file = "" ]; then
	echo -n "\e[31mERROR: Missing buffer file\e[39m" >&2
	exit 2
elif [ ! -w $file ]; then
	echo -n "\e[31mERROR: Can't write to the given file, please define another buffer\e[39m" >&2
	exit 13
fi

#Opening session
echo -ne "\r\e[40m"

if [ $# -ne 0 ] && [ $1 = "-i" -o $1 = "--interactive" ]; then
	read -p "Enter a username: " username

	loopInputFilter "Do you want to activate the history?"

	if [ $? -eq 0 ]; then
		hasHistory=y
	else
		hasHistory=n
		echo -ne "\e[37m\r"
	fi
else
	while [ $# -ne 0 ]; do
		case $1 in
			"-p"|"--private")
				hasHistory=n
				echo -ne "\e[37m\r"
				shift; continue
				;;
			"-u"|"--username")
				if [ $# -gt 1 ]; then
					username=$2
					shift 2; continue
				else
					echo -e "\e[49;31mERROR: username must be defined\e[39m" >&2
					exit 5
				fi
				;;
		esac
	done

	if [ -z $hasHistory ]; then
		hasHistory=y
	fi
	if [ -z $username ]; then
		read -p "Enter a username: " username
	fi
fi

echo $test

#Setup
echo -e "Enter \e[1m0\e[22m to \e[1mexit\e[22m the program\n"

if [ $(cat $file | egrep -c "[yn][0-9]+-${username}:\ .*") -gt 0 ]; then
	lastMessage=$(cat $file | egrep "[yn][0-9]+-${username}:\ .*" | tail -n 1 | cut -c2-)
	echo "Last message date: $(date -d @$(echo $lastMessage | cut -d "-" -f 1))"
	echo -e "Last message content:$(echo $lastMessage | cut -d ":" -f 2-)\n"
fi

if [ "$(cat $file | tail -n 1 | cut -d ":" -f 1 | cut -d "-" -f 2-)" != "$username" ]; then
	echo -e "Last message sent: $(cat $file | tail -n 1 | cut -d "-" -f 2-)"
fi

echo -ne "\r\e[49m"

content=$(cat $file | tail -n 1)
line=""
input=""

#Main loop
while [ "$input" != "0" ]; do
	#Read
	if [ "$(cat $file | tail -n 1)" != "$content" ] && [ "$(cat $file | tail -n 1 | cut -d ":" -f 1 | cut -d "-" -f 2-)" != "$username" ]; then
		content=$(cat $file | tail -n 1)
		echo $content | cut -d "-" -f 2-
	fi
	
	#Write
	read -t 0.1 input
	if [ "$input" = "0" ]; then
		continue;
	fi
	if [ "$input" != "$line" ] && [ "$input" != "" ]; then
		line=$input
		message="${hasHistory}$(date +%s)-${username}: ${line}"
		if [ "$(cat $file | tail -n 1 | cut -c1)" = "y" ]; then
			echo $message >> $file
		else
			echo -e "$(echo -e $(cat $file | head -n $(($(cat $file | wc -l)-1)) | tr "\n" "¤") | tr "¤" "\n")\n${message}" > $file
		fi
	fi
done

if [ "$(cat $file | tail -n 1 | cut -c1)" = "n" ]; then
	echo "$(echo -ne $(cat $file | head -n $(($(cat $file | wc -l) -1 )) | tr "\n" "¤") | tr "¤" "\n")" > $file
fi

echo -e "Goodbye ${username}!\e[39m"
