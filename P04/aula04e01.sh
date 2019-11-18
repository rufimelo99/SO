#!/bin/bash


function imprime_msg()
{
echo "A minha primeira funcao"
return 0
}

function data()
{

date
}
function username()
{

echo $USER
}

function hostname()
{

echo $HOSTNAME
}



imprime_msg
data
hostname
username