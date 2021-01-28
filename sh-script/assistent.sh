#!/bin/bash

alias echo='echo -e'
clear

echo "\nCreador d'UO\n"

echo "\nNom de domini (dc=X,dc=tld):\t"
read dn
echo "\nNom de la UO (uo=UO):\t"
read uo

echo "Fitxer de sortida (Sense extensió)\t"
read file

if [ -f "$file.ldif" ]; then
	echo "\nEl fitxer existeix, vols sobreescriure'l? [Y/n]\t"
	read yn
	case $yn in
		y)
			echo "dn:\tou="$uo","$dn > $file.ldif
		;;
		Y)
			echo "dn:\tou="$uo","$dn > $file.ldif
		;;
		n | N)
			echo "\n\ndn:\tou="$uo","$dn > $file.ldif
	esac
else
	echo "\n\ndn:\tou="$uo","$dn > $file.ldif
fi
