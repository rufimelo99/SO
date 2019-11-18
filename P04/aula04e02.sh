#!/bin/bash
function numeric_to_string()
{
    case "$1" in
        1)
            echo "Um"
            ;;
        2)
            echo "Dois"
            ;;
        3)
            echo "Três"
            ;;
        *)
            echo "Outro numero"
    esac
return $1
}

function without_args()
{   
    read -p "Enter one number: " n1
    #echo $n1
    read -p "Enter other number: " n2
    #echo $n2
    if [[ $n1 == $n2 ]]
    then
        echo "sao iguais"
        return 0
    elif [[ $n1 <\ $n2 ]]
    then    
        echo "O maior número é:" $n2

        return 2
    elif [[ $n1 >\ $n2 ]]
    then 
        echo "O maior número é:" $n1
        return 1
    fi
    
}
without_args $1 $2
numeric_to_string $1
echo "O valor da funcao anterior é: "$?