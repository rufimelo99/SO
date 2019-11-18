#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
    int i, j, numChars;
    char *username;
    char  arg[100], strings[100];

    if(argc < 2)
    {
        printf("Nao foram introduzidos argumentos sufucientes");
        EXIT_FAILURE;
    }

    numChars = 0;
    for(i = 1 ; i < argc ; i++)
    {
        strcpy(arg, argv[i]);
        if(isalpha(arg[0]) != 0)
        {
            for( j = 0 ; j < strlen(arg); j++)
            {
                strings[numChars] = arg[j];
                numChars++;
            }
        }
    }

    printf("frase(apenas strings): %s \n", strings);
    return EXIT_SUCCESS;
}
