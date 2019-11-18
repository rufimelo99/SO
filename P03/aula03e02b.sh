#!/bin/bash
# Conditional block if
if [ "$#" -eq 2 ];then
    if [[ $1 = $2 ]] ; then
    echo "O arg1 é igual ao arg2"
    else
    echo "Os args são diferentes"
    fi
else
    echo "numero de argumentos incorreto"
fi