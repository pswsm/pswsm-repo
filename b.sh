#!/usr/bin/env bash

namefr=( $(ldapsearch -x -LLL -b dc=edt,dc=org "(objectClass=posixGroup)" | cut -d ' ' -f2 | cut -d ',' -f1 | sed 's/cn=//' | uniq) )

printf "%s\n" ${namefr[@]}
