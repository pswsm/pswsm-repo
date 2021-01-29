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
                                        echo -e "És guradarà a groups.ldif\t"
					file="groups.ldif"
                                        $EDITOR $file
                                ;;
                                2)
                                        echo -e "\nCreador de Grups\n"
                                        
                                        echo -e "\nNom de domini (ou=X,dc=Y,dc=tld):\t"
                                        read ub

					if [ -f "$file" ]; then
						gid=$(grep gid $file | cut -d " " -f2 | sort -d | tail -n 1)
						((gid++))
					else
						gid=$(ldapsearch -x -LLL -b dc=edt,dc=org "(objectClass=posixGroup)" | grep gid | sort -d | cut -d " " -f2 | tail -n 1)
						((gid++))
					fi
					
					echo -e "El gid serà "$gid"."

                                        echo -e "\nNom del grup (cn=Nom):\t"
                                        read cn
                                        
                                        echo -e "És guardarà a groups.ldif\t"
					file="groups.ldif"
                                                
                                        if [ -f "$file" ]; then
                                                echo -e "\nEl fitxer existeix, vols sobreescriure'l? [Y/n]\t"
                                                read yn
                                                case $yn in
                                                        y | Y)
                                                                echo -e "dn:\t"$cn","$ub"\ngidNumber: "$gid"\ncn: "$cn"\nobjectClass: posixGroup\nobjectClass: top\n" > $file
                                                        ;;
                                                        n | N)
								echo -e "El contingut serà afegit al final del fitxer.\n"
								echo -e "dn:\t"$cn","$ub"\ngidNumber: "$gid"\ncn: "$cn"\nobjectClass: posixGroup\nobjectClass: top\n" >> $file
                                                esac
                                        else
                                                echo -e "dn: "$cn","$ub"\ncn: "$cn"\nobjectClass: posixGroup\nobjectClass: top\n" > $file.ldif

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
					$EDITOR $file.ldif
				;;
				2)
					echo -e "\nCreador d'UO\n"

					echo -e "\nNom de domini (dc=X,dc=tld):\t"
					read dn
					echo -e "\nNom de la UO (ou=UO):\t"
					read uo

					echo -e "Fitxer de sortida (Sense extensió)\t"
					read file

					if [ -f "$file.ldif" ]; then
					        echo -e "\nEl fitxer existeix, vols sobreescriure'l? [Y/n]\t"
					        read yn
					        case $yn in
					                y | Y)
					                        echo -e "dn:\t"$uo","$dn"\nobjectClass: organizationalUnit\nobjectClass: top\nou: "$uo"\n" > $file.ldif
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
