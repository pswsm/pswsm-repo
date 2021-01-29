#!/usr/bin/env bash

#_base="$(dirname $_script)"

while :
do
	echo -e "\nLDAP: Menu d'usuari\nSelecciona l'acció desitjada\n\t(1) Crear nova UO\n\t(2) Crear un nou grup\n\t(3) Crear un nou usuari\n\t(4) Carregar a LDAP\n\t(5) Sortir"
	read -p ":	" num

	case $num in
		5)
			exit 0
		;;
		4)

		;;
		3)

		;;
		2)
                        clear  
                        echo -e "Vols fer-ho amb manualment (1) o amb l'assistent (2)?"
                        read ed   
                        case $ed in
                                1)
                                        echo -e "Fitxer de sortida (Sense extensió)\t"
                                        read file
                                        $EDITOR $file
                                ;;
                                2)
                                        clear

                                        echo -e "\nCreador de Grups\n"
                                        
                                        echo -e "\nNom de domini (ou=X,dc=Y,dc=tld):\t"
                                        read ub
					echo -e "\nID de Grup (Un numerò que no esigui sent utilitzat per un altre grup)\t"
					
                                        echo -e "\nNom del grup (cn=Nom):\t"
                                        read cn
                                        
                                        echo -e "Fitxer de sortida (Sense extensió)\t"
                                        read file
                                                
                                        if [ -f "$file.ldif" ]; then
                                                echo -e "\nEl fitxer existeix, vols sobreescriure'l? [Y/n]\t"
                                                read yn
                                                case $yn in
                                                        y | Y)
                                                                echo -e "dn:\tcn="$cn","$ub"\ngidNumber: "$gid"\ncn: "$cn"\nobjectClass: posixGroup\nobjectClass: top\nou: "$uo"\n" > $file.ldif
                                                        ;;
                                                        n | N)
								echo -e "dn:\tcn="$cn","$ub"\ngidNumber: "$gid"\ncn: "$cn"\nobjectClass: posixGroup\nobjectClass: top\nou: "$uo"\n" > $file.ldif
                                                esac
                                        else
                                                echo -e "dn: ou="$uo","$dn"\nobjectClass: organizationalUnit\nobjectClass: top\nou: "$uo"\n" > $file.ldif

                                        fi
                                        # $_base/assistent.sh
                                        # El fitxer assistent conte tot el que hi ha en aquest 2n cas
                                ;;
                        esac

		;;
		1)
			clear
			echo -e "Vols fer-ho amb manualment (1) o amb l'assistent (2)?"
			read ed
			case $ed in
				1)
					echo -e "Fitxer de sortida (Sense extensió)\t"
					read file
					$EDITOR $file
				;;
				2)
					clear

					echo -e "\nCreador d'UO\n"

					echo -e "\nNom de domini (dc=X,dc=tld):\t"
					read dn
					echo -e "\nNom de la UO (uo=UO):\t"
					read uo

					echo -e "Fitxer de sortida (Sense extensió)\t"
					read file

					if [ -f "$file.ldif" ]; then
					        echo -e "\nEl fitxer existeix, vols sobreescriure'l? [Y/n]\t"
					        read yn
					        case $yn in
					                y | Y)
					                        echo -e "dn:\tou="$uo","$dn"\nobjectClass: organizationalUnit\nobjectClass: top\nou: "$uo"\n" > $file.ldif
					                ;;
					                n | N)
					                        echo -e "\n\ndn:\tou="$uo","$dn"\nobjectClass: organizationalUnit\nobjectClass: top\nou: "$uo"\n" >> $file.ldif
					        esac
					else
					        echo -e "dn: ou="$uo","$dn"\nobjectClass: organizationalUnit\nobjectClass: top\nou: "$uo"\n" > $file.ldif

					fi
					# $_base/assistent.sh
					# El fitxer assistent conte tot el que hi ha en aquest 2n cas
				;;
			esac
		;;
		*)
			clear
			echo -e "Germà, has de posar algun dels numeros que està entre parentesis."
		;;
	esac
done
