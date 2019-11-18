#!/bin/bash
lista=( {1..10} )
for i in "${lista[@]}"; do
echo "$i"
done

if [ $# != 1 ] ; then
    echo "O numero de arguentos é diferente de 1"
    exit 1;
fi


if [ ! -f $1 ] ; then
    echo "nao é ficheiro"
    exit 1;
fi

echo "Numeros por ordenar: "
i=0;
while read -r line
do 
    a[$i]=$line;
    arr[$i]=$line;
    echo ${a[$i]}
    ((i++))
done < $1
echo "Ordenacao ";  

#logic for selection sort
for (( i=0; i<((${#a[@]})); i++)) 
do
    index_min=$i
    for (( j=i+1; j<${#a[@]}; j++))
    do
        if (( ${a[$j]} < ${a[$index_min]} )) ; then
            index_min=$j
        fi
    done
    if (( ${a[$i]} != ${a[$index_min]} )) ; then
        aux=${a[$i]}
        a[$i]=${a[$index_min]}
        a[$index_min]=$aux
    fi  
done

for (( i=0; i<${#a[@]}; i++)) 
do
    echo ${a[$i]};
done