#include <stdio.h>
#include <time.h>
#include <stdlib.h>


int main(int argc, char **argv)
{
    int i;
    if (argc != 2){ //pus 3 uma vez que quando chamo o ficheiro para ser executado, o seu nome conta como argumento
    fprintf(stderr, "nao colocou um argumento\n");

    exit(1);
    }

    


    /*int arg1 = **argv[1];
    printf(arg1);
    */

int numeroAleatorio;
/* initialize random seed: */
srand (time(NULL));

/* generate secret number between 1 and 10: */
numeroAleatorio = rand() % 10 + 1;

//printf("\n%i\n", numeroAleatorio);
int escolha;do{
    scanf("%d", &escolha);
    //printf("\n%i\n", escolha    );
    if (escolha < numeroAleatorio){
        printf("O numero gerado é superior\n");
    }
    else if(escolha > numeroAleatorio){
        printf("O numero gerado é inferior\n");
    }
    else{
        printf("Acertou!! Parabens!!\n");
    }
} while(escolha != numeroAleatorio);

return 0;
}