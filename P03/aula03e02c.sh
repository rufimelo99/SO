#!/bin/bash
# Conditional block if

: '

read var1
read var2
echo $var1
echo $var2

if [["$var1" == "$var2"]];then
    echo "O arg1 é igual ao arg2"
else
    echo "Os args são diferentes"
fi  

'
if [ "$1" = "$2" ] ; then               
echo "O arg1 é igual ao arg2"
else
echo "Os args são diferentes"
fi 

