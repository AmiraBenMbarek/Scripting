#!/bin/bash


function show_usage  
{
	echo "User.sh: [-h|--help] [-l] [-u] [-c] [-m] [-g] [-v] chemin.."
exit 1 
}

function verouillage #verrouiller un compte 
{
	user="$OPTARG"
	if [ -z $user ]
	then 
	read -p "saisir le nom d'un utilisateur existant: " user
	fi
	
	sudo usermod -L $user 2> erreur.txt
	if [ -s erreur.txt ]; then
		echo "user n'existe pas!"
		else echo $user >> liste_user_v.txt
	fi
	rm erreur.txt
}

function verouillage1 #verrouiller un compte 
{
	user=`yad --center --width=400 --height=100 --text="saisir le nom d'un utilisateur existant: " --entry`
	sudo usermod -L $user 2> erreur.txt
	if [ -s erreur.txt ]; then
		echo "user n'existe pas!"
		else echo $user >> liste_user_v.txt
	fi
	rm erreur.txt
}

function deverouillage #deverrouiller un compte 
{
	user="$OPTARG"
	if [ -z $user ]
	then 
	read -p "saisir le nom d'un utilisateur existant: " user
	fi
	
	sudo usermod -U $user
	sed -i "/^$user$/d" liste_user_v.txt
}

function deverouillage1 #deverrouiller un compte 
{
	user=`yad --center --width=400 --height=100 --text="saisir le nom d'un utilisateur existant: " --entry`
	sudo usermod -U $user
	sed -i "/^$user$/d" liste_user_v.txt
}

function help #affichage du document help.txt
{
	cat help.txt
}

function help1 #affichage du document help.txt
{

	yad --center --width=800 --height=250 --image="gtk-dialog-info" --title="HELP" --text="$(cat help.txt)"
}

function version #affichage des auteurs et la version du code
{
	echo "Le programme est developpé par Aouinet Ramy & Ben Mbarek Amira"
	echo "version 1.0"
	echo "version du systeme"
	cat /etc/os-release
}

function version1 #affichage des auteurs et la version du code
{
	yad --center --width=800 --height=250 --image="gtk-dialog-info" --title="Version" --text="$(cat version.txt)"
}

function modifier #modifier le chemin du répértoire personelle de l’utilisateur et copier le contenu de son ancien répertoire vers le nouveau
{
	set -f # disable glob
        IFS=,     
	array=($OPTARG)
	
	if [ -z ${array[0]} ] && [ -z ${array[1]} ]
	then 
		read -p "saisir le nom d'un utilisateur existant: " user
		read -p "saisir le nouveau repertoire: " repertoire
		sudo usermod -m -d /home/$repertoire $user
	else
		sudo usermod -m -d /home/${array[1]} ${array[0]}
	fi
	
}

function modifier1 #modifier le chemin du répértoire personelle de l’utilisateur et copier le contenu de son ancien répertoire vers le nouveau
{
	user=`yad --center --width=400 --height=100 --text="saisir le nom d'un utilisateur existant: " --entry`
	repertoire=`yad --center --width=400 --height=100 --text="saisir le nouveau repertoire: " --entry`
	sudo usermod -m -d /home/$repertoire $user
}

function graphic #option -g pour un menu graphique
{
  export -f version1
  export -f verouillage1
  export -f deverouillage1
  export -f modifier1
  export -f help1

  yad --center --width=1000 --height=800 --title "Menu graphique" --form --field "help":btn "bash -c help1" --field "Auteurs et version du projet":btn "bash -c version1" --field "Verouillage d'un compte:":btn "bash -c verouillage1" --field "Deverouillage d'un compte":btn "bash -c deverouillage1" --field "Modification du répértoire personnelle":btn "bash -c modifier1";
}

function menu #option -m pour un menu textuel
{
    while true; do
	
        clear
        echo "Menu"
        echo "------------------------"
        echo "1- Help"
        echo "2- interface graphique"
        echo "3- version du code"
        echo "4- verouillage utilisateur"
        echo "5- deverouillage du code"
        echo "6- modifier le repertoire personel"
        echo "0- Quitter"
        echo "------------------------"
        echo "Taper votre choix"
        read reponse
		
        case "$reponse" in
			0) exit ;;
			1) help;;
			2) graphic;;
			3) version ;;
			4) verouillage;;
			5) deverouillage;;
			6) modifier;;
			*) echo "Choix incorrect";;
        esac
		
        read -p "Appuyez sur la touche Entrer pour continuer"
    done
}

if (test $# == 0); then
    echo "Erreur! pas d'argument"
	show_usage
else
while getopts "hmvgl:u:c:" option
do
	case $option in
		h) help;;
		l) verouillage;;
		u) deverouillage;;
		c) modifier;;
		m) menu;;
		v) version;;
		g) graphic;;
		*) echo "invalid option";;
	esac
done
fi
