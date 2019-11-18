#!/bin/bash
# For all the files in a folder, show their properties
if [[ "$#" != 1 ]] ; then
echo "Numero de argumentos errado"
else
    if [[ -d $1 ]] ; then

        echo 'O argumento passado corresponde a uma diretoria '


        for f in $1/*; do
            file "$f"
            #mv "$f" new.$f 

            #ERROR--- the aim was to add a prefix to each file from a directorie
        done


    else
        echo "O argumento passado nao corresponde a uma diretoria"

    fi
fi


