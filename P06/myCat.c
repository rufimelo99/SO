#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>

/* SUGESTÂO: utilize as páginas do manual para conhecer mais sobre as funções usadas:
 man fopen
 man fgets
*/

#define LINEMAXSIZE 80 /* or other suitable maximum line size */


int main(int argc, char *argv[])
{
    int i;
    FILE *fp = NULL;
    char line [LINEMAXSIZE]; 

    /* Validate number of arguments */
    if(argc < 2)
    {
        printf("USAGE: %s fileName\n", argv[0]);
        return EXIT_FAILURE;
    }
    
    
    for(int i=1; i < argc; i++ ){
    printf("I: %i\n", i);

    /* Open the file provided as argument */
    errno = 0;
    int nlinha = 1; //numeero da linha
    fp = fopen(argv[i], "r");
    if(fp == NULL)
    {
        perror ("Error opening file!");
        return EXIT_FAILURE;
    }

    /* read all the lines of the file */
    while(fgets(line, sizeof(line), fp) != NULL )
    {

        // printf("(%i)-> %s", nlinha, line);
         printf("%s (%i)", line, nlinha);
         nlinha++;
    }
    printf("\n.........End of the file\n");
    fclose (fp);
    }
    return EXIT_SUCCESS;
}
