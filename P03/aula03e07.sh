#!/bin/bash
# Calculate the sum of a series of numbers.
SCORE="0"
SUM="0"
Media="0"
contador="0"
while true; do
    echo -n "Enter your score [0-10] ('q' to quit): "
    read SCORE;
    if (("$SCORE" < "0")) || (("$SCORE" > "10")); then
        echo "Try again: "
    elif [[ "$SCORE" == "q" ]]; then
        echo "Sum: $SUM."
        echo "Contador: $contador."
        echo "Media: $Media."
        break
    elif [[ "$SCORE" == "r" ]]; then
        echo "Contagem e soma reiniciados"
        Media=$((0))  
        contador=$((0))
        SUM=$((0))
    else
        SUM=$((SUM + SCORE))
        contador=$(($contador+1))
        Media=$(($SUM/$contador))
    fi
done
echo "Exiting."