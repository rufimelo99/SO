#include <stdio.h>
#include <time.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
    int i, j;
    if (argc < 2){ //pus 3 uma vez que quando chamo o ficheiro para ser executado, o seu nome conta como argumento
    fprintf(stderr, "nao colocou argumentos\n");

    exit(1);
    }
    printf("numArgs: %d\n", argc-1);
    char ArgumentosOrdenados[argc];
    int ordem[argc];
    for (i=1; i< argc; i++){
        ArgumentosOrdenados[i]=i; //posicoes iniciais dos argumentos
    }    
    for (int u = 1; u< argc; u++){
        printf("%d: %s\n", ArgumentosOrdenados[u], argv[ArgumentosOrdenados[u]]);
       
    }
    int min = 1;
    int condicao = 0;
    do {
        printf("Novo ciclo iniciado \n");
        int trocas = 0;
         for(i = 1 ; i < sizeof(ArgumentosOrdenados)/sizeof(ArgumentosOrdenados[0]) ; i++)
        {   
            for(j = i+1 ; j < sizeof(ArgumentosOrdenados)/sizeof(ArgumentosOrdenados[0]) ; j++)
            { 
            
            //printf("O caractér inicial do arg i: %c = %d\n", argv[i][0], argv[i][0] );
            //printf("O caractér inicial do arg j: %c = %d\n\n", argv[j][0], argv[j][0] );
              if((int) argv[ArgumentosOrdenados[i]][0] > (int) argv[ArgumentosOrdenados[j]][0])  {
                min = j;
                /*
                printf("okay, temos de trocar.\n");
                for (int u = 1; u< argc; u++){
                         printf("Ordenacao Previa \n%d: \n\n", ArgumentosOrdenados[u]);
                    }
                */
                ArgumentosOrdenados[j] = i;
                ArgumentosOrdenados[i] = j; //Erro aqui
                printf("i: %i\n", i);
                printf("j: %i\n", j);
                printf("ArgumentosOrdenados[i]: %i\n", ArgumentosOrdenados[i]);
                printf("ArgumentosOrdenados[j]: %i\n", ArgumentosOrdenados[j]);
                //IMprimir Argumentso Ordenados Provisoriamente
                for (int u = 1; u < argc; u++){
                         printf("Ordenacao Posterior\n%d: %s\n", ArgumentosOrdenados[u], argv[ArgumentosOrdenados[u]]);
                    }
                //i = j;
                //j++;
                trocas ++;
            }
            }
        
        }
        if(trocas == 0){
            //return 0;
            break;
        }
       
    } while (1) ;



    printf("O elemento alfabeticamente primeiro: %s\n", argv[min]);
    printf("Argumentos Ordenads: \n");
    for (int u = 1; u < argc; u++){

        printf("%d\n", ArgumentosOrdenados[u]);
        printf("%s\n", argv[ArgumentosOrdenados[u]]);
    }



}
