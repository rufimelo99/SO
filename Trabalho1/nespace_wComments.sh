#! /bin/bash
#Rui Melo
#Mariana Gameiro
#LEI
#2018/19
declare -A ArrayGeral
opcaoA=0 #(flags)
opcaoR=0
opcaoL=0
opcaol=0
opcaoN=0
opcaoD=0
opcaoE="0"

function ser_proibido() { #$1--> a ser comparado
    i=0
    e_proibido=0
    for line in $(cat "$opcaoE"); 
    do 
        y=$(dir_size "$line")
        #echo $y "$line"
        proibidos[ $i ]=$line
        i=$((i+1))
    done

    for i in ${proibidos[@]}; 
    do 
        if [ "$1" == "$i" ]; then
            e_proibido=1
        fi
    done
    echo $e_proibido
}

function ser_proibido_v2() { #$1--> a ser comparado $2-->file
    i=0
    e_proibido=0
    while IFS='' read -r line || [[ -n "$line" ]]; do
        
        y=$(dir_size "$line")
        #echo $y "$line"
        proibidos[ $i ]=$line
        i=$((i+1))
    done < "$2" 


    for i in ${proibidos[@]}; 
    do 
        if [ "$1" == "$i" ]; then
            e_proibido=1
        fi
    done
    echo $e_proibido
}

function dir_size() {

    #https://stackoverflow.com/questions/16661982/check-folder-size-in-bash

    #http://ldmlinux.blogspot.com/2012/10/du-estimativa-de-espaco.html
    
    #opcao b --> bytes
    #opcao s ---> total
    y=$(du -sb $1 | awk '{printf "%10s \n", $1}')


    #y=$( stat -c %s -- "$f" )
    echo "$y"
}
function base() {
    #$1 correponde à diretoria 
    for dir in "$1"/* ; do
        if [ -d "$dir" ]; then
            if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                if [[ $proibicao -ne 1 ]]; then
                    size=$(dir_size $dir)
                    ArrayGeral["$dir"]=$size
                    #echo "dir" $dir "size" $size
                    base "$dir"
                fi
            else
                size=$(dir_size $dir)
                ArrayGeral["$dir"]=$size
                #echo "dir" $dir "size" $size
                base "$dir"
            fi
        #caso queira ficheiros
        #elif [ -f "$dir" ]; then
        #    size=$(dir_size $dir)
        #    ArrayGeral["$dir"]=$size
        
        fi
    done
}
function base_tempo() {
    #$1 correponde à diretoria 
    #$2 corresponde à data
    for dir in "$1"/* ; do
        if [ -d "$dir" ]; then
            
            if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                if [[ $proibicao -ne 1 ]]; then
                    
                    ola=$(stat -c %y "$dir" | awk '{print $1,$2}') #retirar +hh:mm timezones
                    #echo $ola
                    input1=$(date -d "$ola" +%s)
                    #echo "input1" $input1
                    #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
                    #date -d "2014-12-01T21:34:03+02:00" +%s
                    input2=$(date -d "$opcaoD" +%s)
                    #echo "input2" $input2

                    if [[ $input1 -lt $input2 ]]; then
                        size=$(dir_size $dir)
                        ArrayGeral["$dir"]=$size
                    fi
                    base_tempo "$dir" $opcaoD

                fi
            else
                        ola=$(stat -c %y "$dir" | awk '{print $1,$2}') #retirar +hh:mm timezones
                    #echo $ola
                    input1=$(date -d "$ola" +%s)
                    #echo "input1" $input1
                    #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
                    #date -d "2014-12-01T21:34:03+02:00" +%s
                    input2=$(date -d "$opcaoD" +%s)
                    #echo "input2" $input2

                    if [[ $input1 -lt $input2 ]]; then
                        size=$(dir_size $dir)
                        ArrayGeral["$dir"]=$size
                    fi
                    base_tempo "$dir" $opcaoD
            fi
        fi
    done
}
function base_com_termincao() {
    tamanho_do_diretorio=0
    #$1 correponde à diretoria 
    #echo $1
    #echo $2
    #$1 correponde à diretoria 
    for dir in "$1"/*; do
        if [ -d "$dir" ]; then
            #echo "D: $dir"
            #size=$(dir_size $dir)
            #ArrayGeral["$dir"]=$size
            #echo "dir" $dir "size" $size

            if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                if [[ $proibicao -ne 1 ]]; then
                    base_com_termincao "$dir" "$opcaoN"
                fi
            else
                base_com_termincao "$dir" "$opcaoN"

            fi
        else
            #https://tecadmin.net/how-to-extract-filename-extension-in-shell-script/?fbclid=IwAR2k0g7W4LHjulThqA7Grfg41pk9YgXNrkpV1EKyIe-zmerIcKUTFWK0Oeg
            #echo " "
            #echo "F: $dir"
            fullfilename="$dir"
            filename=$(basename "$fullfilename")
            ext="${filename##*.}"
            #echo "extensao" $ext
            if [ "*.""$ext" == "$opcaoN" ]; then
                if [[ "$opcaoE" != "0" ]]; then
                    proibicao=$(ser_proibido_v2 $dir $opcaoE)
                    #echo $proibicao
                    if [[ $proibicao -ne 1 ]]; then
                        #echo "ola" 
                        result=$(dir_size $dir)   
                        tamanho_do_diretorio=$((tamanho_do_diretorio+result))
                    fi
                else
                    result=$(dir_size $dir)   
                    tamanho_do_diretorio=$((tamanho_do_diretorio+result))
                fi
            fi
        fi
       
    done
    ArrayGeral["$1"]=$tamanho_do_diretorio
}
function base_com_termincao_tempo() {
    
    tamanho_do_diretorio=0
    #$1 correponde à diretoria 
    #echo $1
    #echo $2
    #$1 correponde à diretoria 
    for dir in "$1"/*; do
        if [ -d "$dir" ]; then
            if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                if [[ $proibicao -ne 1 ]]; then
                    #echo "D: $dir"
                    #size=$(dir_size $dir)
                    #ArrayGeral["$dir"]=$size
                    #echo "dir" $dir "size" $size
                    base_com_termincao_tempo "$dir" "$opcaoN" $opcaoD
                fi
            else
                base_com_termincao_tempo "$dir" "$opcaoN" $opcaoD
            fi
        else
            #https://tecadmin.net/how-to-extract-filename-extension-in-shell-script/?fbclid=IwAR2k0g7W4LHjulThqA7Grfg41pk9YgXNrkpV1EKyIe-zmerIcKUTFWK0Oeg
            #echo " "
            #echo "F: $dir"
            fullfilename="$dir"
            filename=$(basename "$fullfilename")
            ext="${filename##*.}"
            #echo "extensao" $ext
            if [ "*.""$ext" == "$opcaoN" ]; then
                if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                    if [[ $proibicao -ne 1 ]]; then
                        ola=$(stat -c %y "$dir" | awk '{print $1,$2}') #retirar +hh:mm timezones
                        #echo $ola
                        input1=$(date -d "$ola" +%s)
                        #echo "input1" $input1
                        #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
                        #date -d "2014-12-01T21:34:03+02:00" +%s
                        input2=$(date -d "$opcaoD" +%s)
                        #echo "input2" $input2

                        if [[ $input1 -lt $input2 ]]; then
                            #echo "ola" 
                            result=$(dir_size $dir)   
                            tamanho_do_diretorio=$((tamanho_do_diretorio+result))
                        
                        
                        fi
                    fi    
                else
                    ola=$(stat -c %y "$dir" | awk '{print $1,$2}') #retirar +hh:mm timezones
                        #echo $ola
                        input1=$(date -d "$ola" +%s)
                        #echo "input1" $input1
                        #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
                        #date -d "2014-12-01T21:34:03+02:00" +%s
                        input2=$(date -d "$opcaoD" +%s)
                        #echo "input2" $input2

                        if [[ $input1 -lt $input2 ]]; then
                            #echo "ola" 
                            result=$(dir_size $dir)   
                            tamanho_do_diretorio=$((tamanho_do_diretorio+result))
                        
                        
                        fi
                fi
            fi

        fi
       
    done
    ArrayGeral["$1"]=$tamanho_do_diretorio
}


function save_files() { #opcao -L  #$2->tamanho #$1->directoria
    for dir in $1/*
        do 
        if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                if [[ $proibicao -ne 1 ]]; then
                    if [ -d "$dir" ]
                    then 
                            
                        save_files $dir

                    fi
                    if [ -f "$dir" ]; then 
                    
                        result=$(dir_size $dir)
                        
                        #echo "Nome do Ficheiro" $dir "tamanho" $result
                        
                        ArrayGeral+=([$dir]=$result)
                    fi
                fi
        else
                if [ -d "$dir" ]
                    then 
                            
                        save_files $dir

                    fi
                    if [ -f "$dir" ]; then 
                    
                        result=$(dir_size $dir)
                        
                        #echo "Nome do Ficheiro" $dir "tamanho" $result
                        
                        ArrayGeral+=([$dir]=$result)
                    fi
        fi
        done
    
} 
function save_files_tempo() { #opcao -L  #$2->data #$1->directoria
    for dir in $1/*
        do
        if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                if [[ $proibicao -ne 1 ]]; then
                    if [ -d "$dir" ]
                    then 
                            
                        save_files_tempo $dir $opcaoD

                    fi
                    if [ -f "$dir" ]; then 
                        ola=$(stat -c %y "$dir" | awk '{print $1,$2}') #retirar +hh:mm timezones
                        #echo $ola
                        input1=$(date -d "$ola" +%s)
                        #echo "input1" $input1
                        #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
                        #date -d "2014-12-01T21:34:03+02:00" +%s
                        input2=$(date -d "$opcaoD" +%s)
                        #echo "input2" $input2

                        if [[ $input1 -lt $input2 ]]; then
                            
                            result=$(dir_size $dir)
                            
                            #echo "Nome do Ficheiro" $dir "tamanho" $result
                            
                            ArrayGeral+=([$dir]=$result)
                        fi
                    fi
                fi
        else
        if [ -d "$dir" ]
            then 
                    
                save_files_tempo $dir $opcaoD

            fi
            if [ -f "$dir" ]; then 
                ola=$(stat -c %y "$dir" | awk '{print $1,$2}') #retirar +hh:mm timezones
                #echo $ola
                input1=$(date -d "$ola" +%s)
                #echo "input1" $input1
                #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
                #date -d "2014-12-01T21:34:03+02:00" +%s
                input2=$(date -d "$opcaoD" +%s)
                #echo "input2" $input2

                if [[ $input1 -lt $input2 ]]; then
                    
                    result=$(dir_size $dir)
                    
                    #echo "Nome do Ficheiro" $dir "tamanho" $result
                    
                    ArrayGeral+=([$dir]=$result)
                fi
            fi
        fi
        done
    
} 
function save_files_wName() { #opcao -L  #$1->directoria #$2>exte
    for dir in $1/*
        do 
        if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                if [[ $proibicao -ne 1 ]]; then
                    if [ -d "$dir" ]
                    then 
                            
                        save_files_wName $dir $opcaoN

                    fi
                    if [ -f "$dir" ]; then 
                        fullfilename="$dir"
                        filename=$(basename "$fullfilename")
                        ext="${filename##*.}"
                        #echo "extensao" $ext
                        if [ "*.""$ext" == "$opcaoN" ]; then
                            result=$(dir_size $dir)
                            
                            #echo "Nome do Ficheiro" $dir "tamanho" $result
                            
                            ArrayGeral+=([$dir]=$result)
                        fi
                    fi
                fi
        else
            if [ -d "$dir" ]
            then 
                    
                save_files_wName $dir $opcaoN

            fi
            if [ -f "$dir" ]; then 
                fullfilename="$dir"
                filename=$(basename "$fullfilename")
                ext="${filename##*.}"
                #echo "extensao" $ext
                if [ "*.""$ext" == "$opcaoN" ]; then
                    result=$(dir_size $dir)
                    
                    #echo "Nome do Ficheiro" $dir "tamanho" $result
                    
                    ArrayGeral+=([$dir]=$result)
                fi
            fi
        fi
        done
    
}
function save_files_wName_tempo() { #opcao -L  #$1->directoria #$2>exte $3-> data size--> variavel global de L!!!
     for dir in $1/*
        do 
        if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                if [[ $proibicao -ne 1 ]]; then
                    if [ -d "$dir" ]
                    then 
                            
                        save_files_wName_tempo $dir $opcaoN "$opcaoD"

                    fi
                    if [ -f "$dir" ]; then 
                        fullfilename="$dir"
                        filename=$(basename "$fullfilename")
                        ext="${filename##*.}"
                        #echo "extensao" $ext
                        if [ "*.""$ext" == "$opcaoN" ]; then
                            ola=$(stat -c %y "$dir" | awk '{print $1,$2}') #retirar +hh:mm timezones
                            #echo $ola
                            input1=$(date -d "$ola" +%s)
                            #echo "input1" $input1
                            #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
                            #date -d "2014-12-01T21:34:03+02:00" +%s
                            input2=$(date -d "$opcaoD" +%s)
                            #echo "input2" $input2

                            if [[ $input1 -lt $input2 ]]; then
                                result=$(dir_size $dir)
                                
                                #echo "Nome do Ficheiro" $dir "tamanho" $result
                                
                                ArrayGeral+=([$dir]=$result)
                            fi
                        fi
                    fi
                fi
        else
            if [ -d "$dir" ]
            then 
                    
                save_files_wName_tempo $dir $opcaoN "$opcaoD"

            fi
            if [ -f "$dir" ]; then 
                fullfilename="$dir"
                filename=$(basename "$fullfilename")
                ext="${filename##*.}"
                #echo "extensao" $ext
                if [ "*.""$ext" == "$opcaoN" ]; then
                    ola=$(stat -c %y "$dir" | awk '{print $1,$2}') #retirar +hh:mm timezones
                    #echo $ola
                    input1=$(date -d "$ola" +%s)
                    #echo "input1" $input1
                    #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
                    #date -d "2014-12-01T21:34:03+02:00" +%s
                    input2=$(date -d "$opcaoD" +%s)
                    #echo "input2" $input2

                    if [[ $input1 -lt $input2 ]]; then
                        result=$(dir_size $dir)
                        
                        #echo "Nome do Ficheiro" $dir "tamanho" $result
                        
                        ArrayGeral+=([$dir]=$result)
                    fi
                fi
            fi
        fi
        done
    
} 


function save_directories_sizes_xfiles() { #opcao -l  #$2->tamanho #$1->directoria #$3-> terminacao
    #para opcao -l base
    
    #local -a tamanhos_dos_ficheiros
    local tamanho_do_diretorio=0   
 
        #array diretorias com os os espaços correspondentes ao maiores elementos ocupados com zeros
    for i in `seq 0 $opcaol`;
    do
        #echo "posicao do array temporario" $i
        tamanhos_dos_ficheiros[ $i ]=0     
    done 
    
        
    #result=$(dsize "$1"/"$dir") #neste caso corresponde ao tamanho do ficheiro
    #echo "diretorio/ficheiro: "$dir "   valor: " $result
    for dir in $1/*
    do 
        if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                if [[ $proibicao -ne 1 ]]; then    
                    if [ -d $dir ]; then 
                        save_directories_sizes_xfiles "$dir" $opcaol
                    elif [  -f $dir  ]; then
                        #echo "F: $dir"
                        result=$(dir_size $dir) #neste caso corresponde ao tamanho do ficheiro
                        #echo "tamanho do ficheiro" $result

                        if [ $result -gt ${tamanhos_dos_ficheiros[0]} ];then
                            #echo " "
                            #echo "Maior que o elemento [0]"

                            #echo "valor" $result
                            #echo "primeiro elemento" ${tamanhos_dos_ficheiros[0]} #supostamente o segundo mais alto naquele momento
                            #echo "segundo elemento"  ${tamanhos_dos_ficheiros[1]} #supostamente o primeiro mais alto naquele momento
                            # echo ${tamanhos_dos_ficheiros[0]}
                            tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                            
                            tamanhos_dos_ficheiros[0]=$result
                            #echo "primeiro elemento(c/ troca)" ${tamanhos_dos_ficheiros[0]} #supostamente o segundo mais alto naquele momento
                            #echo "segundo elemento(c/ troca)"  ${tamanhos_dos_ficheiros[1]} #supostamente o primeiro mais alto naquele momento
                            #tamanhos_dos_ficheiros=($(echo ${tamanhos_dos_ficheiros[*]}| sort -n -r)) #ordener normalmente
                            tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                            #echo "primeiro elemento(c/ ordenacao)" ${tamanhos_dos_ficheiros[0]} #supostamente o segundo mais alto naquele momento
                            #echo "segundo elemento(c/ ordenacao)"  ${tamanhos_dos_ficheiros[1]} #supostamente o primeiro mais alto naquele momento           
                        fi
                        tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )

                    fi
                fi
        else
            if [ -d $dir ]; then 
                save_directories_sizes_xfiles "$dir" $opcaol
            elif [  -f $dir  ]; then
                #echo "F: $dir"
                result=$(dir_size $dir) #neste caso corresponde ao tamanho do ficheiro
                #echo "tamanho do ficheiro" $result

                if [ $result -gt ${tamanhos_dos_ficheiros[0]} ];then
                    #echo " "
                    #echo "Maior que o elemento [0]"

                    #echo "valor" $result
                    #echo "primeiro elemento" ${tamanhos_dos_ficheiros[0]} #supostamente o segundo mais alto naquele momento
                    #echo "segundo elemento"  ${tamanhos_dos_ficheiros[1]} #supostamente o primeiro mais alto naquele momento
                    # echo ${tamanhos_dos_ficheiros[0]}
                    tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                    
                    tamanhos_dos_ficheiros[0]=$result
                    #echo "primeiro elemento(c/ troca)" ${tamanhos_dos_ficheiros[0]} #supostamente o segundo mais alto naquele momento
                    #echo "segundo elemento(c/ troca)"  ${tamanhos_dos_ficheiros[1]} #supostamente o primeiro mais alto naquele momento
                    #tamanhos_dos_ficheiros=($(echo ${tamanhos_dos_ficheiros[*]}| sort -n -r)) #ordener normalmente
                    tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                    #echo "primeiro elemento(c/ ordenacao)" ${tamanhos_dos_ficheiros[0]} #supostamente o segundo mais alto naquele momento
                    #echo "segundo elemento(c/ ordenacao)"  ${tamanhos_dos_ficheiros[1]} #supostamente o primeiro mais alto naquele momento           
                fi
                tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
            fi
        fi
    done
    #echo ".-------------------------."
    #echo ".-------------------------."
    #echo "Diretoria: $1"
    for i in `seq 0 $opcaol`;
    do
        elemento=${tamanhos_dos_ficheiros[ $i ]}
        tamanho_do_diretorio=$((tamanho_do_diretorio+elemento))
    done 
    ArrayGeral+=([$1]=$tamanho_do_diretorio)
    

    #echo ".-------------------------."
    #echo ".-------------------------."
}
function save_directories_sizes_xfiles_wName() { #opcao -l  #$2->tamanho #$3->directoria #$4-> terminacao
    local tamanho_do_diretorio=0   
    for i in `seq 0 $opcaol`;
    do
        tamanhos_dos_ficheiros[ $i ]=0     
    done 
    for dir in $1/*
    do 
    if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                if [[ $proibicao -ne 1 ]]; then   
                    if [ -d $dir ]; then 
                        save_directories_sizes_xfiles_wName "$dir" $opcaol "$opcaoN"
                    elif [  -f $dir  ]; then
                        result=$(dir_size $dir) #neste caso corresponde ao tamanho do ficheiro
                        fullfilename="$dir"
                        filename=$(basename "$fullfilename")
                        ext="${filename##*.}"
                        #echo "extensao" $ext
                        if [ "*.""$ext" == "$opcaoN" ]; then
                            if [ $result -gt ${tamanhos_dos_ficheiros[0]} ];then
                                tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                                
                                tamanhos_dos_ficheiros[0]=$result
                                tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                            fi
                        fi
                        tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )

                    fi
                fi
    else
        if [ -d $dir ]; then 
            save_directories_sizes_xfiles_wName "$dir" $opcaol "$opcaoN"
        elif [  -f $dir  ]; then
            result=$(dir_size $dir) #neste caso corresponde ao tamanho do ficheiro
            fullfilename="$dir"
            filename=$(basename "$fullfilename")
            ext="${filename##*.}"
            #echo "extensao" $ext
            if [ "*.""$ext" == "$opcaoN" ]; then
                if [ $result -gt ${tamanhos_dos_ficheiros[0]} ];then
                    tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                    
                    tamanhos_dos_ficheiros[0]=$result
                    tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                fi
            fi
            tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )

        fi
    fi
    done
    for i in `seq 0 $opcaol`;
    do
        elemento=${tamanhos_dos_ficheiros[ $i ]}
        tamanho_do_diretorio=$((tamanho_do_diretorio+elemento))
    done 
    ArrayGeral+=([$1]=$tamanho_do_diretorio)

}
function save_directories_sizes_xfiles_wName_tempo() { #opcao -l  #$2->tamanho #$3->directoria #$4-> terminacao
    local tamanho_do_diretorio=0   
    for i in `seq 0 $opcaol`;
    do
        tamanhos_dos_ficheiros[ $i ]=0     
    done 
    for dir in $1/*
    do 
    if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                if [[ $proibicao -ne 1 ]]; then   
                    if [ -d $dir ]; then 
                        save_directories_sizes_xfiles_wName_tempo "$dir" $opcaol "$opcaoN" "$opcaoD"
                    elif [  -f $dir  ]; then
                        result=$(dir_size $dir) #neste caso corresponde ao tamanho do ficheiro
                        fullfilename="$dir"
                        filename=$(basename "$fullfilename")
                        ext="${filename##*.}"
                        #echo "extensao" $ext
                        if [ "*.""$ext" == "$opcaoN" ]; then
                            ola=$(stat -c %y "$dir" | awk '{print $1,$2}') #retirar +hh:mm timezones
                            #echo $ola
                            input1=$(date -d "$ola" +%s)
                            #echo "input1" $input1
                            #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
                            #date -d "2014-12-01T21:34:03+02:00" +%s
                            input2=$(date -d "$opcaoD" +%s)
                            #echo "input2" $input2

                            if [[ $input1 -lt $input2 ]]; then
                                if [ $result -gt ${tamanhos_dos_ficheiros[0]} ];then
                                    tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                                    
                                    tamanhos_dos_ficheiros[0]=$result
                                    tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                                fi
                            fi
                        fi
                        tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )

                    fi
                fi
    else
        if [ -d $dir ]; then 
            save_directories_sizes_xfiles_wName_tempo "$dir" $opcaol "$opcaoN" "$opcaoD"
        elif [  -f $dir  ]; then
            result=$(dir_size $dir) #neste caso corresponde ao tamanho do ficheiro
            fullfilename="$dir"
            filename=$(basename "$fullfilename")
            ext="${filename##*.}"
            #echo "extensao" $ext
            if [ "*.""$ext" == "$opcaoN" ]; then
                ola=$(stat -c %y "$dir" | awk '{print $1,$2}') #retirar +hh:mm timezones
                #echo $ola
                input1=$(date -d "$ola" +%s)
                #echo "input1" $input1
                #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
                #date -d "2014-12-01T21:34:03+02:00" +%s
                input2=$(date -d "$opcaoD" +%s)
                #echo "input2" $input2

                if [[ $input1 -lt $input2 ]]; then
                    if [ $result -gt ${tamanhos_dos_ficheiros[0]} ];then
                        tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                        
                        tamanhos_dos_ficheiros[0]=$result
                        tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                    fi
                fi
            fi
            tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )

        fi
    fi
    done
    for i in `seq 0 $opcaol`;
    do
        elemento=${tamanhos_dos_ficheiros[ $i ]}
        tamanho_do_diretorio=$((tamanho_do_diretorio+elemento))
    done 
    ArrayGeral+=([$1]=$tamanho_do_diretorio)

}
function save_directories_sizes_xfiles_tempo() { #opcao -l  #$2->tamanho #$3->directoria #$4-> terminacao
     local tamanho_do_diretorio=0   
    for i in `seq 0 $opcaol`;
    do
        tamanhos_dos_ficheiros[ $i ]=0     
    done 
    for dir in $1/*
    do 
    if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                #echo $proibicao
                if [[ $proibicao -ne 1 ]]; then   
                    if [ -d $dir ]; then 
                        save_directories_sizes_xfiles_tempo "$dir" $opcaol "$opcaoD"
                    elif [  -f $dir  ]; then
                        result=$(dir_size $dir) #neste caso corresponde ao tamanho do ficheiro
                    
                        ola=$(stat -c %y "$dir" | awk '{print $1,$2}') #retirar +hh:mm timezones
                        #echo $ola
                        input1=$(date -d "$ola" +%s)
                        #echo "input1" $input1
                        #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
                        #date -d "2014-12-01T21:34:03+02:00" +%s
                        input2=$(date -d "$opcaoD" +%s)
                        #echo "input2" $input2

                        if [[ $input1 -lt $input2 ]]; then
                            if [ $result -gt ${tamanhos_dos_ficheiros[0]} ];then
                                tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                                
                                tamanhos_dos_ficheiros[0]=$result
                                tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                            fi
                        fi
                    
                        tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )

                    fi
                fi
    else
       if [ -d $dir ]; then 
            save_directories_sizes_xfiles_tempo "$dir" $opcaol "$opcaoD"
        elif [  -f $dir  ]; then
            result=$(dir_size $dir) #neste caso corresponde ao tamanho do ficheiro
        
            ola=$(stat -c %y "$dir" | awk '{print $1,$2}') #retirar +hh:mm timezones
            #echo $ola
            input1=$(date -d "$ola" +%s)
            #echo "input1" $input1
            #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
            #date -d "2014-12-01T21:34:03+02:00" +%s
            input2=$(date -d "$opcaoD" +%s)
            #echo "input2" $input2

            if [[ $input1 -lt $input2 ]]; then
                if [ $result -gt ${tamanhos_dos_ficheiros[0]} ];then
                    tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                    
                    tamanhos_dos_ficheiros[0]=$result
                    tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                fi
            fi
        
            tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )

        fi 
    fi
    done
    for i in `seq 0 $opcaol`;
    do
        elemento=${tamanhos_dos_ficheiros[ $i ]}
        tamanho_do_diretorio=$((tamanho_do_diretorio+elemento))
    done 
    ArrayGeral+=([$1]=$tamanho_do_diretorio)


}

function imprimir_array() {
    #permite imprimir o array que se pretende colocar no terminal
    #verificar opcoes aqui!!!!!!!
    #echo $#
    if [[ $opcaoA -eq 1 ]] && [[ $opcaoR -eq 1 ]] && [[ $opcaoL -ne 0 ]]; then 
        echo "imprime 1"
        {
        for k in "${!ArrayGeral[@]}"  #imprimir keys
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -nr -k2 | head -$opcaoL
    elif [[ $opcaoA -eq 1 ]] && [[ $opcaoR -eq 1 ]]; then 
        echo "imprime 2"
        
        {
        for k in "${!ArrayGeral[@]}"  #imprimir keys
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -nr -k2
    
    elif [[ $opcaoA -eq 1 ]] && [[ $opcaoL -ne 0 ]]; then 
        echo "imprime 3"
        
        {
        for k in "${!ArrayGeral[@]}"  #imprimir keys
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -n -k2 | head -$opcaoL    
        
    elif [[ $opcaoR -eq 1 ]] && [[ $opcaoL -ne 0 ]]; then 
        echo "imprime 4"
        {
        for k in "${!ArrayGeral[@]}"  #imprimir keys
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -nr | head -$opcaoL    
    elif [[ $opcaoA -eq 1 ]]; then 
        echo "imprime 5"
        {
        for k in "${!ArrayGeral[@]}"  #imprimir keys
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -n -k2 

    elif [[ $opcaoR -eq 1 ]]; then 
        echo "imprime 6"
        
        {
        for k in "${!ArrayGeral[@]}"  #imprimir keys
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -nr     
    elif [[ $opcaoL -ne 0 ]]; then 
        echo "imprime 7"
        
        {
        for k in "${!ArrayGeral[@]}"  #imprimir keys
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -n | head -$opcaoL
    else 
        {
        for k in "${!ArrayGeral[@]}"  #imprimir keys
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -n
    fi
}

#nao consegui implementa funcao main.. extensashift $((OPTIND-1))
#HELP
#while getopts 'abf:v' flag; do
#     case "${flag}" in
#         a) a_flag='true' ;;
#         b) b_flag='true' ;;
#         f) files="${OPTARG}" ;;
#         v) verbose='true' ;;
#         *) print_usage
#         exit 1 ;;
#     esac
# done  


while getopts "n:l:d:L:rae:" option; do
    case $option in
        n)  
            opcaoN=${OPTARG}
            #http://wiki.bash-hackers.org/syntax/shellvars#optarg
            #$OPTARG
            #echo $OPTARG

            #echo "Opcao -n   "
            
        ;;
        d) opcaoD=${OPTARG}
        
        #HELP data
        #https://stackoverflow.com/questions/16391208/print-a-files-last-modified-date-in-bash
        #arranjar data do file
        #ola=$(stat -c %y "exemplo_de_teste" | awk '{print $1,$2}') #retirar +hh:mm timezones
        #echo $ola
        #input1=$(date -d "$ola" +%s)
        #echo "input1" $input1
        #https://stackoverflow.com/questions/27429653/date-comparison-in-bash
        #date -d "2014-12-01T21:34:03+02:00" +%s
        #input2=$(date -d "$1" +%s)
        #echo "input2" $input2
        #########################################

        ;;

        l) opcaol=1 
            if [[ $opcaoL -ne 0 ]]; then
                echo "-l e -L não podem estar em simultâneo"
                exit 1  
            fi

        ;;
        a) 
            opcaoA=1
        ;;
        r)
            opcaoR=1;
        ;;
        e)
            opcaoE=${OPTARG}

        ;;
        L)  opcaoL=${OPTARG}
           
            if [[ $opcaol -ne 0 ]]; then
                
                echo "-l e -L não podem estar em simultâneo"
                exit 1
            fi
            
            # if [[ $opcaoN -eq 1 ]]; then
            #     save_files_wName $3 $5
            #     imprimir_array
            # else
            #     save_files $3
            #     imprimir_array

            # fi
        ;;
        \?)
            echo "Opção inválida!"
            exit 1
            ;;
    esac


done #shift $((OPTIND-1))
#HELP
#while getopts 'abf:v' flag; do
#     case "${flag}" in
#         a) a_flag='true' ;;
#         b) b_flag='true' ;;
#         f) files="${OPTARG}" ;;
#         v) verbose='true' ;;
#         *) print_usage
#         exit 1 ;;
#     esac
# done


i=0	
inputs=() 

#guardar argumentos e usar a ultima posicao do array para obter "<diretoria>"
for arg in "$@"; do
	inputs[i]=$arg
	i=$((i + 1))
done
localizacao_diretoria=${#inputs[@]}
diretoria_nome=${inputs[$localizacao_diretoria-1]} 

if [[ $opcaoL -ne 0 ]] && [[ $opcaol -ne 0 ]]; then
        echo "L e l nao podem ser usadas juntas"
        exit 1
fi

if [[ $opcaol -eq 0 ]]; then
    if [[ $opcaoL -eq 0 ]]; then #inclui opcaol =0
        if [[ $opcaoN == 0 ]]; then
            if [[ $opcaoD == 0 ]]; then
                #echo "./function.sh sop"
                #done #done
                base "$diretoria_nome"
            else
                #echo "./function.sh -d Sep 10 10:00 sop"
                #done #done
                base_tempo "$diretoria_nome" $opcaoD

            fi
        else
            if [[ $opcaoD == 0 ]]; then
                #echo "./function.sh -n ".sh" sop"
                #done   #done
                base_com_termincao "$diretoria_nome" "$opcaoN"
                
            else
                # "./function.sh -n ".sh" -d Sep 10 10:00 sop"
                #done   #done   
                base_com_termincao_tempo "$diretoria_nome" "$opcaoN" $opcaoD
            fi
        fi
    elif [[ $opcaoL -ne 0 ]]; then #com valor de L--> L -ne 0
        if [[ $opcaoN == 0 ]]; then
            if [[ $opcaoD == 0 ]]; then
                #echo "./function.sh -L 2 sop"
                #done   #done
                save_files "$diretoria_nome" $opcaoL  
            else
                #echo "./function.sh -L 2 -d "Sep 10 10:00" sop"
                #done   #done
                save_files_tempo "$diretoria_nome" $opcaoD
            fi
        else
            if [[ $opcaoD == 0 ]]; then
                #echo "./function.sh -L 2 -n "*.sh" sop"
                #done   #done
                save_files_wName "$diretoria_nome" $opcaoN
            else
                #echo "./function.sh -L 2 -n "*.sh" -d "Sep 10 10:00" sop"
                #done   #done
                save_files_wName_tempo "$diretoria_nome" $opcaoN "$opcaoD"
            fi
        fi
    fi
elif [[ $opcaol -ne 0 ]]; then
    if [[ $opcaoN == 0 ]]; then
        if [[ $opcaoD == 0 ]]; then
            #echo "./function.sh -l 2 sop"
            
            save_directories_sizes_xfiles "$diretoria_nome" $opcaol
        else
            #echo "./function.sh -l 2 -d "Sep 10 10:00" sop"
            save_directories_sizes_xfiles_tempo "$diretoria_nome" $opcaol "$opcaoD"
            
        fi
    else
        if [[ $opcaoD == 0 ]]; then
            #echo "./function.sh -l 2 -n "*.sh" sop"
            save_directories_sizes_xfiles_wName "$diretoria_nome" $opcaol "$opcaoN"

            
        else
            #echo "./function.sh -l 2 -n "*.sh" -d "Sep 10 10:00" sop"
            save_directories_sizes_xfiles_wName_tempo "$diretoria_nome" $opcaol "$opcaoN" "$opcaoD"
            
        fi
    fi
fi
imprimir_array

# ###################################################################
# ######################### HELP FICHEIROS PROIBIDOS ################
# #https://br.ccm.net/faq/2269-como-ler-um-arquivo-linha-por-linha
# i=0
# for line in $(cat proibidos.txt); 
# do 
#     y=$(dir_size "$line")
#     echo $y "$line"
#     proibidos[ $i ]=$line
    
#     i=$((i+1))
#     #echo "O i trocou:  $i"
# done

# #https://stackoverflow.com/questions/16860877/remove-an-element-from-a-bash-array
# #array=(pluto pippo)
# #delete=(pluto)
# #echo ${array[@]/$delete}
# #pippo
# #array=( "${array[@]/$delete}" )

# for k in "${!ArrayGeral[@]}"  #imprimir keys
#     do
#     echo "${ArrayGeral[$k]} ${k}"

#     #echo "Proibidos: "
#     echo "${k}"  ---> keys
#     for i in ${proibidos[@]}; 
#     do 
#         #echo "     " $i #proibidos
#         if [ "${k}" == "$i" ];then
#             echo "foi este" "${k}"
#             erro="${k}"
#             #echo "${ArrayGeral[@]//$delete}"
#             #https://www.artificialworlds.net/blog/2012/10/17/bash-associative-array-examples/
#             #unset ${ArrayGeral[${k}]}
#             unset 'ArrayGeral[$erro]'
            
#         fi
#     done
   
# done 
# echo "dps"
# for k in "${!ArrayGeral[@]}"  #imprimir keys
#     do
#     echo "${ArrayGeral[$k]} ${k}"



# done 
#proibicao=$(ser_proibido $1)
#echo $proibicao
# ###################################################################
# ###################################################################
