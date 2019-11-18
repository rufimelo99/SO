#!/bin/bash

if [[ $# != 2 ]]; then
    echo "n tem 2 argumentos....\n"
    echo "Numero de argumentos invalido\n"

else
    if [[ "$1" =~ ^[0-9]+$ ]] ; then

        if [ "$1" -lt 0 ] || [ "$1" -gt 99 ] ; then
            echo "Primeiro argumento menor que 0 ou maior que 99"
        fi

        if [[ "$2" =~ sec* ]] ; then
        echo "esta correto"
        else
        echo "segundo argumento noa contem sec"
        fi
    else 
    echo "nao e um numero"
    fi
fi
