#!/bin/bash
#File created by create.sh (CPdA-Omi)

# Author : CPdA-Omi
# Creation Date : september 25 2024
# Last update : 05/06/2026 (MM/DD/YYYY)

author="CPdA-Omi"
version="v1.1.0 - DP"
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
  #============================= Welcome to mountPartitions.sh help =============================#
  |
  |	SYNOPSIS
  |		mountPartitions.sh [OPTIONS...]
  |		mountPartitions.sh -m [OPTION...]
  |		mountPartitions.sh -s [OPTIONS...]
  |
  |	DESCRIPTION
  |		mountPartitions.sh is a shell scripts managing your inner Windows and Games
  |		partitions to your computer at /media.
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
  |		-m, --mount
  |			Automatically mount both of your Windows and Games partitions.
  |
  |			-f, --force
  |				Force the partitions to mount so basically nothing.
  |
  |		-s, --show
  |			Show both of your Windows and Games partitions states.
  |
  |			-n, --names
  |				Show partitions names instead of colored dots.
  |				(Can not be combined with letters option)
  |
  |			-l, --letters
  |				Show the 3 first partitions letters instead of colored dots.
  |				(Can not be combined with names option)
  |
  |			-a, --all
  |				Show defined optionnal partitions alongside of your
  |				Windows and Games partitions.
  |
  |	WARNING
  |		This script is not yet universalised. Thus it's not checking how many
  |		partitions you have in total so be careful using this.
  |
  |	KNOWN BUGS
  |		This script may create file in the name of your partition size for some
  |		reason. You may have to delete them.
  |
  |	AUTHOR
  |		Written by CPdA-Omi.
  |
  |
  |	v1.1.0 - DP        May 2026
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
  \e[1m#\e[33m=============================\e[39m Welcome to mountPartitions.sh help \e[33m=============================\e[39m#\e[0m
$(border)
$(border)$(bold "SYNOPSIS")
$(border)	$(bold "mountPartitions.sh") [$(underline "OPTIONS")...]
$(border)	$(bold "mountPartitions.sh -m") [$(underline "OPTION")...]
$(border)	$(bold "mountPartitions.sh -s") [$(underline "OPTIONS")...]
$(border)
$(border)$(bold "DESCRIPTION")
$(border)	mountPartitions.sh is a shell scripts managing your inner Windows and Games
$(border)	partitions to your computer at /media.
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
$(border)	$(bold "-m"), $(bold "--mount")
$(border)		Automatically mount both of your Windows and Games partitions.
$(border)
$(border)		$(bold "-f"), $(bold "--force")
$(border)			Force the partitions to mount so basically nothing.
$(border)
$(border)	$(bold "-s"), $(bold "--show")
$(border)		Show both of your Windows and Games partitions states.
$(border)
$(border)		$(bold "-n"), $(bold "--names")
$(border)			Show partitions names instead of colored dots.
$(border)			$(underline "(Can not be combined with letters option)")
$(border)
$(border)		$(bold "-l"), $(bold "--letters")
$(border)			Show the 3 first partitions letters instead of colored dots.
$(border)			$(underline "(Can not be combined with names option)")
$(border)
$(border)		$(bold "-a"), $(bold "--all")
$(border)			Show defined optionnal partitions alongside of your
$(border)			Windows and Games partitions.
$(border)
$(border)$(bold "WARNING")
$(border)	This script is not yet universalised. Thus it's not checking how many
$(border)	partitions you have in total so be careful using this.
$(border)
$(border)$(bold "KNOWN BUGS")
$(border)	This script may create file in the name of your partition size for some
$(border)	reason. You may have to delete them.
$(border)
$(border)$(bold "AUTHOR")
$(border)	Written by $(bold "$author").
$(border)
$(border)
$(border)${version}     May 2026
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

mountPartitions() {
	while [ $# -ne 0 ]; do
		case $1 in
			"-f"|"--force")
				shift
				forceMount=true
				;;
			*)
				echo -e "\e[31mInvalid argument\e[0m"
				exit 1
				;;
		esac
	done

	partitionName="Données de base Microsoft"

	FirstPartition=$(sudo fdisk -l | grep "$partitionName" | head -n 1)
	SecondPartition=$(sudo fdisk -l | grep "$partitionName" | tail -n 1)

	if [ $(echo $FirstPartition | cut -d "G" -f 1 | rev | cut -d " " -f 1 | rev) > $(echo $SecondPartition | cut -d "G" -f 1 | rev | cut -d " " -f 1 | rev) ]; then
		WindowsPartition=$(echo $FirstPartition | cut -d " " -f 1)
		GamesPartition=$(echo $SecondPartition | cut -d " " -f 1)
	else
		WindowsPartition=$(echo $SecondPartition | cut -d " " -f 1)
		GamesPartition=$(echo $FirstPartition | cut -d " " -f 1)
	fi

	sudo fdisk -l | grep "$partitionName"
	echo ""

	if [ ! -z $forceMount ]; then
		echo -e "\e[35mForced mount\e[0m"
	fi

	if [ $(sudo mount | grep windowsPartition | wc -l) -eq 0 -o ! -z $forceMount ]; then
		echo "Windows Partition: ${WindowsPartition}"
		sudo mount $WindowsPartition /media/windowsPartition
		if [ $? -ne 0 ]; then
			echo -e "\e31mError during Windows mounting\e[0m"
		fi
	else
		echo -e "\e[32mWindows partition already mounted\e[0m"
	fi

	if [ $(sudo mount | grep games | wc -l) -eq 0 -o ! -z $forceMount ]; then
		sudo mount $GamesPartition /media/gamesPartition
		echo "Games Partition: ${GamesPartition}"
		if [ $? -ne 0 ]; then
			echo -e "\e31mError during Games mounting\e[0m"
		fi
	else
		echo -e "\e[32mGames partition already mounted\e[0m"
	fi
}

mountedStates() {
	while [ $# -ne 0 ]; do
		case $1 in
			"-n"|"--names")
				if [ ! -z $lettersMode ]; then
					echo -e "\e[31mError: can't combine names and letters mode\e[0m"
					exit 2
				fi
				namesMode=true
				shift
				;;
			"-l"|"--letters")
				if [ ! -z $namesMode ]; then
					echo -e "\e[31mError: can't combine letters and names mode\e[0m"
					exit 2
				fi
				lettersMode=true
				shift
				;;
			"-a"|"--all")
				showAll=true
				shift
				;;
			*)
				echo "\e[31mInvalid argument\e[0m"
				exit 1
				;;
		esac
	done

	partitions=("windowsPartition" "gamesPartition")
	optionals=("Optionnal1" "Optionnal2" "Optionnal3")

	echo -n "Mounted states:"

	for e in ${partitions[*]}; do
		if [ $(mount | grep -c "$e") -gt 0 ]; then
			if [ ! -z $namesMode ]; then
				echo -ne " \e[1m\e[32m$e\e[0m"
			elif [ ! -z $lettersMode ]; then
				echo -ne " \e[1m\e[32m$(echo ${e:0:3} | tr "a-z" "A-Z")\e[0m"
			else
				echo -ne " \e[32m●\e[0m"
			fi
		else
			if [ ! -z $namesMode ]; then
				echo -ne " \e[31m$e\e[0m"
			elif [ ! -z $lettersMode ]; then
				echo -ne " \e[31m$(echo ${e:0:3} | tr "a-z" "A-Z")\e[0m"
			else
				echo -ne " \e[31m●\e[0m"
			fi
		fi
	done

	if [ ! -z $showAll ]; then
		for o in ${optionals[*]}; do
			if [ $(mount | grep -c "$o") -gt 0 ]; then
				if [ ! -z $namesMode ]; then
					echo -ne " \e[32m$o\e[0m"
				elif [ ! -z $lettersMode ]; then
					echo -ne " \e[1m\e[32m$(echo ${o:0:3} | tr "a-z" "A-Z")\e[0m"
				else
					echo -ne " \e[32m●\e[0m"
				fi
			else
				if [ ! -z $namesMode ]; then
					echo -ne " \e[33m$o\e[0m"
				elif [ ! -z $lettersMode ]; then
					echo -ne " \e[33m$(echo ${o:0:3} | tr "a-z" "A-Z")\e[0m"
				else
					echo -ne " \e[33m●\e[0m"
				fi
			fi
		done
	fi

	echo ""
}

while [ $# -ne 0 ]; do
	case $1 in
		"-m"|"--mount")
			shift
			mountPartitions $@
			exit 0
			;;
		"-s"|"--show")
			shift
			mountedStates $@
			exit 0
			;;
		*)
			echo -e "\e[31mError: Invalid option\e[0m"
			exit 1
			;;
	esac
done

if [ $# -eq 0 ]; then
	mountedStates
fi
