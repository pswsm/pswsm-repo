#!/usr/bin/env bash

_script="$(readlink -f ${BASH_SOURCE[0]})"
_base="$(dirname $_script)"

fusers="$_base/users.ldif"
fuos="$_base/uos.ldif"
fgroups="$_base/groups.ldif"
fall="$_base/all.ldif"
dname="$_base/.dname"
topdn="$_base/.topdn"
fadmin="$_base/.admin"

# Loop Principal
while :
do
	clear
	if [[ ! -f $fadmin ]]; then
		printf "\nEscriu el teu domnini (example.com):\t\t"
		IFS=. read domainname tls
		printf "\nEscriu l'usuari amb el que s'administra el domini (ex: Admin):\t"
		read adminuser
		printf "cn=%s,dn=%s,dn=%s" $adminuser $domainname $tls > $fadmin
		printf "dn=%s,dn=%s" $domainname $tls > $topdn
		printf "%s.%s" $domainname $tls > $dname
		unset domainname tls adminuser
	fi

	printf "░▒█░░░░█▀▄░█▀▀▄░▄▀▀▄░░░▒█▀▄▀█░█▀▀░█▀▀▄░█░▒█░░░▒█░▒█░█▀▀░█░░▄▀▀▄░█▀▀░█▀▀▄\n░▒█░░░░█░█░█▄▄█░█▄▄█░░░▒█▒█▒█░█▀▀░█░▒█░█░▒█░░░▒█▀▀█░█▀▀░█░░█▄▄█░█▀▀░█▄▄▀\n░▒█▄▄█░▀▀░░▀░░▀░█░░░░░░▒█░░▒█░▀▀▀░▀░░▀░░▀▀▀░░░▒█░▒█░▀▀▀░▀▀░█░░░░▀▀▀░▀░▀▀\n\n"

	printf "n\t(1) Crear nova UO\n\t(2) Crear un nou grup\n\t(3) Crear un nou usuari\n\t(4) Carregar a LDAP\n\t(5) Sortir\n"
	read choice

	case choice in
		5 )
		exit 0
			;;
		4 )
		# Load Files
		clear
		printf "Que vols carregar a la Base de Dades?\n"
		printf "\n\t1: Usuaris\n\t2: UOs\n\t3: Grups\n\t4: Tot\n"
		read choice
		case choice in
			1 )
			#Load users
			printf "Es carregaran els usuaris.\n"
			printf "Escriu la contrasenya d'LDAP:\t"
			read -s contrasenya
			ldapadd -x -w $contrasenya -D $fadmin -f $fusers
				;;
			2)
			#Load OUs
			printf "Es carregaran les UOs.\n"
			printf "Escriu la contrasenya d'LDAP:\t"
			read -s contrasenya
			ldapadd -x -w $contrasenya -D $fadmin -f $fuos
				;;
			3)
			#Load Groups
			printf "Es carregaran els grups.\n"
			printf "Escriu la contrasenya d'LDAP:\t"
			read -s contrasenya
			ldapadd -x -w $contrasenya -D $fadmin -f $fgroups
				;;
			3)
			#Load All
			printf "Es carregarà tot.\n"
			printf "Escriu la contrasenya d'LDAP:\t"
			read -s contrasenya
			cat $fuos $fgroups $fusers > $fall
			ldapadd -x -w $contrasenya -D $fadmin -f $fall
				;;
		esac
			;;
		3 )
		# User Creation
		## Get uidnum
		uid=999
		if [[ -f $fusers ]]; then
			uifile=$(grep uidNumber $fusers | cut -d " " -f2 | sort -d | tail -n 1)
			uidb=$(ldapsearch -x -LLL -b dc=edt,dc=org "(objectClass=inetOrgPerson)" | grep uidNumber | sort -d | cut -d " " -f2 | tail -n 1)
			((uifile++))
			((uidb++))
			if [ $uifile > $uidb ]; then
				uid=$uifile
			else
				uid=$uidb
			fi
		else
			uid=$(ldapsearch -x -LLL -b dc=edt,dc=org "(objectClass=inetOrgPerson)" | grep uidNumber | sort -d | cut -d " " -f2 | tail -n 1)
			((uid++))
		fi
		printf "L'arxiu d'usuaris es guardarà a %s\nUbicació de l'usuari en el domini (Per defecte %s): " $fusers $dname
		IFS=. read dn1 dn2
		if [[ -z $dn1 || -z $dn2 ]]; then
			default=$topdn
		fi
	esac

done
