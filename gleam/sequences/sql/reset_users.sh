# !/bin/env sh
# -*- coding: utf-8 -*-
# author: pswsm <Pau Figueras>

if [[ -f "./localdb" ]]; then
    echo "localdb exists, emptying table users"
    if [[ -d "./sql" ]]; then
        sqlite3 localdb ".read ./sql/remove_users.sql"
        sqlite3 localdb ".read ./sql/create_users.sql"
        echo "users resetted, exiting"
        exit 0
    else
        echo "scripts not found, exiting"
        exit 1
    fi
else
    echo "localdb does not exist on current directory, exiting"
    exit 1
fi
