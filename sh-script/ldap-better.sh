#!/usr/bin/env bash

_script="$(readlink -f ${BASH_SOURCE[0]})"
_base="$(dirname $_script)"

fusers="$_base/users.ldif"
fuos="$_base/uos.ldif"
fgroups="$_base/groups.ldif"
dnBase="$_base/dn_base"
fadmin="$_base/admin"

while :
do
	clear

	if [[ ! -f $fadmin ]];; then

