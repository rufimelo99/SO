#!/bin/bash

if (( $1 < 5 || $1 > 10 )) 
    then
        echo "Nao esta correto"
else
    echo "Esta correto"
fi