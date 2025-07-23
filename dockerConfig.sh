#!/bin/bash
#File created by create.sh (CPdA-Omi)

# Author : CPdA-Omi
# Creation Date : july 29 2024
# Last update : 05/21/2025 (MM/DD/YYYY)

author="CPdA-Omi"
version="v1.0.0 - Raft"
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
	missingSpacesNumber=30
	echo -e "
  #============ dockerConfig data ============#
  |                                           |
  |  author:    $(hypertext "$author" "https://github.com/${author}/")$(missingSpaces "" $(($missingSpacesNumber-${#author})))|
  |  version:   $(missingSpaces "$version" $missingSpacesNumber)|
  |  project:   $(missingSpaces "$project" $missingSpacesNumber)|
  |                                           |
  #===========================================#
"
}

guide() {
	if [ "$1" = "noColors" ]; then
		echo "
  #=============================== Welcome to dockerConfig.sh help ===============================#
  |
  |	SYNOPSIS
  |		dockerConfig.sh [OPTION...]
  |
  |	DESCRIPTION
  |		dockerConfig.sh is a shell scripts which install a Docker configuration
  |		into an Ubuntu distribution. Others may come later...
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
  |		-f, --force
  |			Force the Docker installation ignoring any already installed config.
  |
  |	AUTHOR
  |		Written by CPdA-Omi.
  |
  |
  |	v1.0.0 - Raft     May 2025
  |
  #===============================================================================================#
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
  \e[1m#\e[33m===============================\e[39m Welcome to dockerConfig.sh help \e[33m===============================\e[39m#\e[0m
$(border)
$(border)$(bold "SYNOPSIS")
$(border)	$(bold "dockerConfig.sh") [$(underline "OPTION")...]
$(border)
$(border)$(bold "DESCRIPTION")
$(border)	dockerConfig.sh is a shell scripts which install a Docker configuration
$(border)	into an Ubuntu distribution. Others may come later...
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
$(border)	$(bold "-f"), $(bold "--force")
$(border)		Force the Docker installation ignoring any already installed config.
$(border)
$(border)$(bold "AUTHOR")
$(border)	Written by $(bold "$author").
$(border)
$(border)
$(border)${version}     May 2025
$(border)
  \e[1m#\e[33m===============================================================================================\e[39m#\e[0m
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

dockerInstallation() {
	if [ $? -eq 0 ]; then
		case $linuxDistribution in
			Ubuntu)

				echo -e "\n\e[1;33m            -- Update --\n-------------------------------------\e[0m\n"
				sudo apt-get update
				
				echo -e "\n\e[1;36m -- Docker's apt repository setup --\n-------------------------------------\e[0m\n"
				sudo apt-get install ca-certificates curl
				sudo install -m 0755 -d /etc/apt/keyrings
				sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
				sudo chmod a+r /etc/apt/keyrings/docker.asc

				# Add the repository to Apt sources:
				echo -e "\n\e[1;34m      -- Add to apt sources --\n-------------------------------------\e[0m\n"
				echo \
				  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
				  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
				  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
				sudo apt-get update
				
				echo -e "\n\e[1;35m      -- Docker installation --\n-------------------------------------\e[0m\n"
				sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
				sudo docker run hello-world &> /dev/null
				if [ $? -eq 0 ]; then
					echo -e "\n\e[32mInstallation success\e[39m"
				else
					echo -e "\n\e[31mInstallation failed\e[39m"
					exit 1
				fi

				;;
			*)
				echo "\e[31mERROR: Linux distribution not handled\e[39m" >&2
				exit 1
				;;
		esac
	else
		echo "Abort Docker installation"
		exit 1
	fi
}

operatingSystem=$(hostnamectl | grep "Linux" | wc -l)

if [ $operatingSystem == 0 ]; then
	echo "\e[31mERROR: OS not handled, must be a Linux distribution\e[39m" >&2
	exit 1
fi

linuxDistribution=$(hostnamectl | grep "Operating System" | cut -d ":" -f 2 | cut -d " " -f 2)
linuxDistributionVersion=$(hostnamectl | grep "Operating System" | cut -d ":" -f 2 | cut -d " " -f 3)

packageName="docker-desktop-amd64.deb"

if [ ! -z $1 ] && [ $1 = -F -o $1 = --force ]; then
	forcedInstallation=true
fi

if [ ! -z $forcedInstallation ]; then
	sudo echo "Docker installation forced"
	dockerInstallation
else
	sudo docker &> /dev/null
	case $? in
		127)
			loopInputFilter "Docker is not installed, do you want to install it?"
			dockerInstallation
			;;
		0)
			echo "Docker is already installed"
			;;
		*)
			loopInputFilter "Unknown error, do you want to remove Docker?"
			if [ $? = 0 ]; then
				echo "\e[31mERROR: unfinished script\e[39m" >&2
				exit 3
			else
				echo "Abort script"
				exit 0
			fi
			;;
	esac
fi

echo -e "\n\e[1;31m     -- Docker configuration --\n-------------------------------------\e[0m\n"

loopInputFilter "Do you want to install Docker Desktop?"

if [ $? -eq 0 ]; then
	case $linuxDistribution in
		Ubuntu)
			if [ $(whereis docker-desktop | cut -d ":" -f 2 | wc -c) -eq 1 ] || [ ! -z $forcedInstallation ]; then
				if [ $(find $HOME | grep $packageName | wc -l) -lt 1 ]; then
					echo -e "\e[1;36m- Package installation (${packageName})\e[0m"
					echo -e "Now click this link and press enter here when the download is done:\nhttps://desktop.docker.com/linux/main/amd64/157355/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64"					
					read userInputBuffer
				else
					echo -e "\e[1;32mPackage already downloaded!\e[0m"
				fi
					
				echo -e "\e[1;33m- Update\e[0m"
				sudo apt-get update
					
				echo -e "\e[1;34m- Package Installation\e[0m"
				chmod +x $(find $HOME | grep $packageName)
				sudo apt-get install $(find $HOME | grep $packageName)
			else
				echo "Docker already installed!"	
			fi
			;;
	esac
fi

echo -ne "\n\e[1;32m             -- Done --\n-------------------------------------\e[0m\n\n"

