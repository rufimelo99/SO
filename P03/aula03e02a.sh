#!/bin/bash
# Conditional block if
if [ "$#" -eq 0 ];then
if $1 ; then
echo "Verdadeiro"
else
echo "Falso"
fi
else
echo "Argumentos a mais"
fi