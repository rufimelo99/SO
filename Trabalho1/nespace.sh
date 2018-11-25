#! /bin/bash
#Rui Melo
#Mariana Gameiro
#LEI
#2018/19
declare -A ArrayGeral
opcaoA=0 
opcaoR=0
opcaoL=0
opcaol=0
opcaoN=0
opcaoD=0
opcaoE="0"

function ser_proibido() { 
    i=0
    e_proibido=0
    for line in $(cat "$opcaoE"); 
    do 
        y=$(dir_size "$line")
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
function ser_proibido_v2() { 
    i=0
    e_proibido=0
    while IFS='' read -r line || [[ -n "$line" ]]; do  
        y=$(dir_size "$line")
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
    y=$(du -sb $1 | awk '{printf "%10s \n", $1}')
    echo "$y"
}
function base() {
    for dir in "$1"/* ; do
        if [ -d "$dir" ]; then
            if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                if [[ $proibicao -ne 1 ]]; then
                    size=$(dir_size $dir)
                    ArrayGeral["$dir"]=$size
                    base "$dir"
                fi
            else
                size=$(dir_size $dir)
                ArrayGeral["$dir"]=$size
                base "$dir"
            fi
        fi
    done
}
function base_tempo() {
    for dir in "$1"/* ; do
        if [ -d "$dir" ]; then
            if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                if [[ $proibicao -ne 1 ]]; then  
                    ola=$(stat -c %y "$dir" | awk '{print $1,$2}')
                    input1=$(date -d "$ola" +%s)
                    input2=$(date -d "$opcaoD" +%s)
                    if [[ $input1 -lt $input2 ]]; then
                        size=$(dir_size $dir)
                        ArrayGeral["$dir"]=$size
                    fi
                    base_tempo "$dir" $opcaoD
                fi
            else
                     ola=$(stat -c %y "$dir" | awk '{print $1,$2}')
                    input1=$(date -d "$ola" +%s)
                    input2=$(date -d "$opcaoD" +%s)
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
    for dir in "$1"/*; do
        if [ -d "$dir" ]; then
            if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                if [[ $proibicao -ne 1 ]]; then
                    base_com_termincao "$dir" "$opcaoN"
                fi
            else
                base_com_termincao "$dir" "$opcaoN"

            fi
        else
            fullfilename="$dir"
            filename=$(basename "$fullfilename")
            ext="${filename##*.}"
            if [ "*.""$ext" == "$opcaoN" ]; then
                if [[ "$opcaoE" != "0" ]]; then
                    proibicao=$(ser_proibido_v2 $dir $opcaoE)
                    if [[ $proibicao -ne 1 ]]; then
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
    for dir in "$1"/*; do
        if [ -d "$dir" ]; then
            if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                if [[ $proibicao -ne 1 ]]; then
                    base_com_termincao_tempo "$dir" "$opcaoN" $opcaoD
                fi
            else
                base_com_termincao_tempo "$dir" "$opcaoN" $opcaoD
            fi
        else
            fullfilename="$dir"
            filename=$(basename "$fullfilename")
            ext="${filename##*.}"
            if [ "*.""$ext" == "$opcaoN" ]; then
                if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                    if [[ $proibicao -ne 1 ]]; then
                        ola=$(stat -c %y "$dir" | awk '{print $1,$2}') 
                        input1=$(date -d "$ola" +%s)
                        input2=$(date -d "$opcaoD" +%s)
                        if [[ $input1 -lt $input2 ]]; then
                            result=$(dir_size $dir)   
                            tamanho_do_diretorio=$((tamanho_do_diretorio+result))
                        fi
                    fi    
                else
                    ola=$(stat -c %y "$dir" | awk '{print $1,$2}')
                        input1=$(date -d "$ola" +%s)
                        input2=$(date -d "$opcaoD" +%s)
                        if [[ $input1 -lt $input2 ]]; then
                            result=$(dir_size $dir)   
                            tamanho_do_diretorio=$((tamanho_do_diretorio+result))
                        fi
                fi
            fi
        fi
    done
    ArrayGeral["$1"]=$tamanho_do_diretorio
}
function save_files() { 
    for dir in $1/*
        do 
        if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                if [[ $proibicao -ne 1 ]]; then
                    if [ -d "$dir" ]
                    then 
                        save_files $dir
                    fi
                    if [ -f "$dir" ]; then 
                        result=$(dir_size $dir)
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
                        ArrayGeral+=([$dir]=$result)
                    fi
        fi
        done
    
} 
function save_files_tempo() { 
    for dir in $1/*
        do
        if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                if [[ $proibicao -ne 1 ]]; then
                    if [ -d "$dir" ]
                    then     
                        save_files_tempo $dir $opcaoD
                    fi
                    if [ -f "$dir" ]; then 
                        ola=$(stat -c %y "$dir" | awk '{print $1,$2}')
                        input1=$(date -d "$ola" +%s)
                        input2=$(date -d "$opcaoD" +%s)
                        if [[ $input1 -lt $input2 ]]; then
                            result=$(dir_size $dir)
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
                ola=$(stat -c %y "$dir" | awk '{print $1,$2}')
                input2=$(date -d "$opcaoD" +%s)
                if [[ $input1 -lt $input2 ]]; then
                    result=$(dir_size $dir)
                    ArrayGeral+=([$dir]=$result)
                fi
            fi
        fi
        done
    
} 
function save_files_wName() { 
    for dir in $1/*
        do 
        if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                if [[ $proibicao -ne 1 ]]; then
                    if [ -d "$dir" ]
                    then 
                        save_files_wName $dir $opcaoN
                    fi
                    if [ -f "$dir" ]; then 
                        fullfilename="$dir"
                        filename=$(basename "$fullfilename")
                        ext="${filename##*.}"
                        if [ "*.""$ext" == "$opcaoN" ]; then
                            result=$(dir_size $dir)
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
                if [ "*.""$ext" == "$opcaoN" ]; then
                    result=$(dir_size $dir)
                    ArrayGeral+=([$dir]=$result)
                fi
            fi
        fi
        done
    
}
function save_files_wName_tempo() { 
     for dir in $1/*
        do 
        if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                if [[ $proibicao -ne 1 ]]; then
                    if [ -d "$dir" ]
                    then 
                        save_files_wName_tempo $dir $opcaoN "$opcaoD"
                    fi
                    if [ -f "$dir" ]; then 
                        fullfilename="$dir"
                        filename=$(basename "$fullfilename")
                        ext="${filename##*.}"
                        if [ "*.""$ext" == "$opcaoN" ]; then
                            ola=$(stat -c %y "$dir" | awk '{print $1,$2}')
                            input1=$(date -d "$ola" +%s)
                            input2=$(date -d "$opcaoD" +%s)
                            if [[ $input1 -lt $input2 ]]; then
                                result=$(dir_size $dir)
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
                if [ "*.""$ext" == "$opcaoN" ]; then
                    ola=$(stat -c %y "$dir" | awk '{print $1,$2}')
                    input1=$(date -d "$ola" +%s)
                    input2=$(date -d "$opcaoD" +%s)
                    if [[ $input1 -lt $input2 ]]; then
                        result=$(dir_size $dir)
                        ArrayGeral+=([$dir]=$result)
                    fi
                fi
            fi
        fi
        done
    
} 
function save_directories_sizes_xfiles() {
    local tamanho_do_diretorio=0   
    for i in `seq 0 $opcaol`;
    do
        tamanhos_dos_ficheiros[ $i ]=0     
    done 
    for dir in $1/*
    do 
        if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                if [[ $proibicao -ne 1 ]]; then    
                    if [ -d $dir ]; then 
                        save_directories_sizes_xfiles "$dir" $opcaol
                    elif [  -f $dir  ]; then
                        result=$(dir_size $dir) 
                        if [ $result -gt ${tamanhos_dos_ficheiros[0]} ];then
                            tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                            tamanhos_dos_ficheiros[0]=$result
                            tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )          
                        fi
                        tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                    fi
                fi
        else
            if [ -d $dir ]; then 
                save_directories_sizes_xfiles "$dir" $opcaol
            elif [  -f $dir  ]; then
                result=$(dir_size $dir)
                if [ $result -gt ${tamanhos_dos_ficheiros[0]} ];then
                    tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )
                    tamanhos_dos_ficheiros[0]=$result
                    tamanhos_dos_ficheiros=( $(printf "%s\n" ${tamanhos_dos_ficheiros[@]} | sort -n) )      
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
function save_directories_sizes_xfiles_wName() { 
    for i in `seq 0 $opcaol`;
    do
        tamanhos_dos_ficheiros[ $i ]=0     
    done 
    for dir in $1/*
    do 
    if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                if [[ $proibicao -ne 1 ]]; then   
                    if [ -d $dir ]; then 
                        save_directories_sizes_xfiles_wName "$dir" $opcaol "$opcaoN"
                    elif [  -f $dir  ]; then
                        result=$(dir_size $dir) 
                        fullfilename="$dir"
                        filename=$(basename "$fullfilename")
                        ext="${filename##*.}"
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
            result=$(dir_size $dir) 
            fullfilename="$dir"
            filename=$(basename "$fullfilename")
            ext="${filename##*.}"
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
function save_directories_sizes_xfiles_wName_tempo() { 
    local tamanho_do_diretorio=0   
    for i in `seq 0 $opcaol`;
    do
        tamanhos_dos_ficheiros[ $i ]=0     
    done 
    for dir in $1/*
    do 
    if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                if [[ $proibicao -ne 1 ]]; then   
                    if [ -d $dir ]; then 
                        save_directories_sizes_xfiles_wName_tempo "$dir" $opcaol "$opcaoN" "$opcaoD"
                    elif [  -f $dir  ]; then
                        result=$(dir_size $dir) 
                        fullfilename="$dir"
                        filename=$(basename "$fullfilename")
                        ext="${filename##*.}"
                        if [ "*.""$ext" == "$opcaoN" ]; then
                            ola=$(stat -c %y "$dir" | awk '{print $1,$2}') 
                            input1=$(date -d "$ola" +%s)
                            input2=$(date -d "$opcaoD" +%s)
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
            result=$(dir_size $dir)
            fullfilename="$dir"
            filename=$(basename "$fullfilename")
            ext="${filename##*.}"
            if [ "*.""$ext" == "$opcaoN" ]; then
                ola=$(stat -c %y "$dir" | awk '{print $1,$2}') 
                input1=$(date -d "$ola" +%s)
                input2=$(date -d "$opcaoD" +%s)
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
function save_directories_sizes_xfiles_tempo() { 
     local tamanho_do_diretorio=0   
    for i in `seq 0 $opcaol`;
    do
        tamanhos_dos_ficheiros[ $i ]=0     
    done 
    for dir in $1/*
    do 
    if [[ "$opcaoE" != "0" ]]; then
                proibicao=$(ser_proibido_v2 $dir $opcaoE)
                if [[ $proibicao -ne 1 ]]; then   
                    if [ -d $dir ]; then 
                        save_directories_sizes_xfiles_tempo "$dir" $opcaol "$opcaoD"
                    elif [  -f $dir  ]; then
                        result=$(dir_size $dir)
                        ola=$(stat -c %y "$dir" | awk '{print $1,$2}')
                        input1=$(date -d "$ola" +%s)
                        input2=$(date -d "$opcaoD" +%s)
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
            result=$(dir_size $dir) 
            ola=$(stat -c %y "$dir" | awk '{print $1,$2}') 
            input1=$(date -d "$ola" +%s)
            input2=$(date -d "$opcaoD" +%s)
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
    if [[ $opcaoA -eq 1 ]] && [[ $opcaoR -eq 1 ]] && [[ $opcaoL -ne 0 ]]; then 
        {
        for k in "${!ArrayGeral[@]}" 
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -nr -k2 | head -$opcaoL
    elif [[ $opcaoA -eq 1 ]] && [[ $opcaoR -eq 1 ]]; then 
        {
        for k in "${!ArrayGeral[@]}"  
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -nr -k2
    elif [[ $opcaoA -eq 1 ]] && [[ $opcaoL -ne 0 ]]; then 
        {
        for k in "${!ArrayGeral[@]}"  
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -n -k2 | head -$opcaoL   
    elif [[ $opcaoR -eq 1 ]] && [[ $opcaoL -ne 0 ]]; then 
        {
        for k in "${!ArrayGeral[@]}" 
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -nr | head -$opcaoL    
    elif [[ $opcaoA -eq 1 ]]; then 
        {
        for k in "${!ArrayGeral[@]}" 
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -n -k2 
    elif [[ $opcaoR -eq 1 ]]; then 
        {
        for k in "${!ArrayGeral[@]}"  
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -nr     
    elif [[ $opcaoL -ne 0 ]]; then 
        {
        for k in "${!ArrayGeral[@]}"
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -n | head -$opcaoL
    else 
        {
        for k in "${!ArrayGeral[@]}"
            do
            echo "${ArrayGeral[$k]} ${k}"
        done } | sort -n
    fi
}
while getopts "n:l:d:L:rae:" option; do
    case $option in
        n) opcaoN=${OPTARG}
        ;;
        d) opcaoD=${OPTARG}
        ;;
        l) opcaol=1 
            if [[ $opcaoL -ne 0 ]]; then
                echo "-l e -L não podem estar em simultâneo"
                exit 1  
            fi
        ;;
        a) opcaoA=1
        ;;
        r) opcaoR=1;
        ;;
        e) opcaoE=${OPTARG}
        ;;
        L) opcaoL=${OPTARG}
            if [[ $opcaol -ne 0 ]]; then
                echo "-l e -L não podem estar em simultâneo"
                exit 1
            fi
        ;;
        \?)
            echo "Opção inválida!"
            exit 1
            ;;
    esac
done 


i=0	
inputs=() 
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
    if [[ $opcaoL -eq 0 ]]; then 
        if [[ $opcaoN == 0 ]]; then
            if [[ $opcaoD == 0 ]]; then
                base "$diretoria_nome"
            else
                base_tempo "$diretoria_nome" $opcaoD
            fi
        else
            if [[ $opcaoD == 0 ]]; then
                base_com_termincao "$diretoria_nome" "$opcaoN"
            else
                base_com_termincao_tempo "$diretoria_nome" "$opcaoN" $opcaoD
            fi
        fi
    elif [[ $opcaoL -ne 0 ]]; then 
        if [[ $opcaoN == 0 ]]; then
            if [[ $opcaoD == 0 ]]; then
                save_files "$diretoria_nome" $opcaoL  
            else
                save_files_tempo "$diretoria_nome" $opcaoD
            fi
        else
            if [[ $opcaoD == 0 ]]; then
                save_files_wName "$diretoria_nome" $opcaoN
            else
                save_files_wName_tempo "$diretoria_nome" $opcaoN "$opcaoD"
            fi
        fi
    fi
elif [[ $opcaol -ne 0 ]]; then
    if [[ $opcaoN == 0 ]]; then
        if [[ $opcaoD == 0 ]]; then
            save_directories_sizes_xfiles "$diretoria_nome" $opcaol
        else
            save_directories_sizes_xfiles_tempo "$diretoria_nome" $opcaol "$opcaoD"
        fi
    else
        if [[ $opcaoD == 0 ]]; then
            save_directories_sizes_xfiles_wName "$diretoria_nome" $opcaol "$opcaoN"
        else
            save_directories_sizes_xfiles_wName_tempo "$diretoria_nome" $opcaol "$opcaoN" "$opcaoD"
        fi
    fi
fi
imprimir_array