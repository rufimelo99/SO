#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char **argv){

     if (argc != 4){ //pus 3 uma vez que quando chamo o ficheiro para ser executado, o seu nome conta como argumento
        fprintf(stderr, "nao colocou 3 argmentos \n");

        exit(1);
    }

    double arg1 = atof(argv[1]);
    double arg2 = atof(argv[3]);
    
    char op  = argv[2][0];


    double resultado = 0;
    switch(op){
        case 'x':
        printf("%f \n", arg1 * arg2);
            
        break;

        case '-':
        printf("%f \n", arg1 - arg2);
            
        break;

        case '+':
        printf("%f \n", arg1 + arg2);
            
        break;

        case '/':
        printf("%f \n", arg1 / arg2);
            
        break;


        case 'p':
        printf("%f \n", pow(arg1, arg2));
        break;

        default:
            printf("Operador errado\n");

        
    }
    return 0;
}
