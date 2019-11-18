#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    int i;
    if (argc != 3){ //pus 3 uma vez que quando chamo o ficheiro para ser executado, o seu nome conta como argumento
        fprintf(stderr, "nao colocou dois argmentos\n");

        exit(1);
    }

    //nao funciona!!! ver!!

    else {
    for(i = 0 ; i < argc ; i++)
    {
        printf("Argument %d: \"%s\"\n", i, argv[i]);        
    }
    }
    return EXIT_SUCCESS;
}
