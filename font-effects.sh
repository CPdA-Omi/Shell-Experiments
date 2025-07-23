#!/bin/bash
#File created by create.sh (CPdA-Omi)

# Author : CPdA-Omi
# Creation Date : july 10 2024
# Last update : 05/21/2025 (MM/DD/YYYY)

author="CPdA-Omi"
version="v1.1.0 - Beta"
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
  #============ font-effects data ============#
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
  #=============================== Welcome to font-effects.sh help ===============================#
  |
  |	SYNOPSIS
  |		font-effects.sh [OPTION...]
  |
  |	DESCRIPTION
  |		font-effects.sh is a shell scripts which simply lists any useful terminal font
  |		effects that can help the User Experience.
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
  |		-c, --combined
  |			Displays bonus effects combining colors and other effects.
  |
  |		-C, --combined-only
  |			Only displays bonus effects of the -c option.
  |
  |	AUTHOR
  |		Written by CPdA-Omi.
  |
  |
  |	v1.1.0 - Beta     May 2025
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
  \e[1m#\e[33m===============================\e[39m Welcome to font-effects.sh help \e[33m===============================\e[39m#\e[0m
$(border)
$(border)$(bold "SYNOPSIS")
$(border)	$(bold "font-effects.sh") [$(underline "OPTION")...]
$(border)
$(border)$(bold "DESCRIPTION")
$(border)	ffont-effects.sh is a shell scripts which simply lists any useful terminal font
$(border)	effects that can help the User Experience.
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
$(border)	$(bold "-c"), $(bold "--combined")
$(border)		Displays bonus effects combining colors and other effects.
$(border)
$(border)	$(bold "-C"), $(bold "--combined-only")
$(border)		Only displays the bonus effects of the $(bold "-c") option.
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

effectsMeanings=("Normal" "Bold" "Faint" "Italic" "Underline" "Slow blink" "Rapid blink" "Reverse" "Conceal" "Crossed-out"\
 "Primary font" "Alternate font 1" "Alternate font 2" "Alternate font 3" "Alternate font 4" "Alternate font 5" "Alternate font 6" "Alternate font 7" "Alternate font 8" "Alternate font 9"\
 "Fraktur" "Bold off / Double underline" "Normal color intensity" "Not italic / not Fraktur" "Underline off" "Blink off" "???" "Reverse off" "Reveal" "Not Crossed-out"\
 "Black text color" "Red text color" "Green text color" "Yellow text color" "Blue text color" "Magenta text color" "Cyan text color" "Gray text color" "Set text color" "Default text color"\
 "Black background color" "Red background color" "Green background color" "Yellow background color" "Blue background color" "Magenta background color" "Cyan background color" "Gray background color" "Set background color" "Default background color"\
 "???" "Framed" "Encircled" "Overlined" "Not framed or encircled" "Not overlined"\
 "//" "//" "//" "//"\
 "Ideogram underline" "Ideogram double underline" "Ideogram overline" "Ideogram double overline" "Ideogram stress making" "Ideogram attributes off")
effectReset="\e[0m"

if [ $# -gt 1 ]; then
	echo -e "\e[31mERROR: Invalid arguments\e[39m" >&2
	exit 1
fi

if ! [ "$1" = "-C" -o "$1" = --combined-only ]; then

	for i in $(seq 0 49); do
		if [ 0 -eq $(($i % 10)) ]; then
			echo ""
		fi
		echo -e "\e[${i}m${effectsMeanings[$i]} (${i})${effectReset}"
	done

	for i in $(seq 0 1); do
		echo ""
		for j in $(seq 0 5); do
			effectNumber=$((50+10*$i+$j))
			echo -e "\e[${effectNumber}m${effectsMeanings[$effectNumber]} (${effectNumber})${effectReset}"
		done
	done

fi

if [ ! -z $1 ] && [ "$1" = "-c" -o "$1" = "--combined" ]; then
	echo -e "\n----------------------- Combined ------------------------\n"
fi

if [ ! -z $1 ] && [ "$1" = "-c" -o "$1" = "--combined" -o "$1" = "-C" -o "$1" = "--combined-only" ]; then

	echo -e "\e[1;30mBold Black text color (1+30)${effectReset}"
	echo -e "\e[1;31mBold Red text color (1+31)${effectReset}"
	echo -e "\e[1;32mBold Green text color (1+32)${effectReset}"
	echo -e "\e[1;33mBold Yellow text color (1+33)${effectReset}"
	echo -e "\e[1;34mBold Blue text color (1+34)${effectReset}"
	echo -e "\e[1;35mBold Magenta text color (1+35)${effectReset}"
	echo -e "\e[1;36mBold Cyan text color (1+36)${effectReset}"
	echo -e "\e[1;37mBold Gray text color (1+37)${effectReset}"
	echo -e "\e[1;39mBold Default text color (1+39)${effectReset}"

	echo ""

	echo -e "\e[7;30mReversed Black text color (7+30)${effectReset}"
	echo -e "\e[7;31mReversed Red text color (7+31)${effectReset}"
	echo -e "\e[7;32mReversed Green text color (7+32)${effectReset}"
	echo -e "\e[7;33mReversed Yellow text color (7+33)${effectReset}"
	echo -e "\e[7;34mReversed Blue text color (7+34)${effectReset}"
	echo -e "\e[7;35mReversed Magenta text color (7+35)${effectReset}"
	echo -e "\e[7;36mReversed Cyan text color (7+36)${effectReset}"
	echo -e "\e[7;37mReversed Gray text color (7+37)${effectReset}"
	echo -e "\e[7;39mReversed Default text color (7+39)${effectReset}"

	echo ""

	echo -e "\e[1;7;30mReversed Bold Black text color (7+1+30)${effectReset}"
	echo -e "\e[1;7;31mReversed Bold Red text color (7+1+31)${effectReset}"
	echo -e "\e[1;7;32mReversed Bold Green text color (7+1+32)${effectReset}"
	echo -e "\e[1;7;33mReversed Bold Gold text color (7+1+33)${effectReset}"
	echo -e "\e[1;7;34mReversed Bold Blue text color (7+1+34)${effectReset}"
	echo -e "\e[1;7;35mReversed Bold Magenta text color (7+1+35)${effectReset}"
	echo -e "\e[1;7;36mReversed Bold Cyan text color (7+1+36)${effectReset}"
	echo -e "\e[1;7;37mReversed Bold Gray text color (7+1+37)${effectReset}"
	echo -e "\e[1;7;39mReversed Bold Default text color (7+1+39)${effectReset}"
fi
