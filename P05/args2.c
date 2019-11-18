#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
    int i, j, numChars;
    char *username;
    char frase[100], arg[100];

    username = getenv("USER");
    if(username != NULL)
    {
        printf("This program is being executed by %s\n", username);
    }
    else
    {
        printf("ERROR: USER not defined\n");
        return EXIT_FAILURE;
    }

    numChars = 0;
    for(i = 1 ; i < argc ; i++)
    {
        //numChars += strlen(argv[i]);
        strcpy(arg, argv[i]);
        for( j = 0 ; j < strlen(arg); j++)
        {
            frase[numChars] = arg[j];
            numChars++;
        }

    }

    printf("All arguments have %d characters\n", numChars);
    printf("frase(argumentos todos juntos): %s \n", frase);
    return EXIT_SUCCESS;
}
