#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* SUGESTÂO: utilize as páginas do manual para conhecer mais sobre as funções usadas:
 man qsort
*/
#define LINEMAXSIZE 80 /* or other suitable maximum line size */


int compareInts(const void *px1, const void *px2)
{
    int x1 = *((int *)px1);
    int x2 = *((int *)px2);
    return(x1 < x2 ? -1 : 1);
}

int main(int argc, char *argv[])
{
    int i, numSize, nlinha;
    int *numbers;

    numSize = argc - 1;
    FILE *fp = NULL;
    char line [LINEMAXSIZE]; 
    /* Memory allocation for all the numbers in the arguments */
    numbers = (int *) malloc(sizeof(int) * numSize);

    fp = fopen(argv[i], "r");

    if(fp == NULL)
    {
        perror ("Error opening file!");
        return EXIT_FAILURE;
    }
    
    /* read all the lines of the file */
    while(fscanf(fp, "%d", &line) == 1 )
    {
        numbers[nlinha] = val;
        nlinha++;
    }
    printf("\n.........End of the file\n");
    fclose (fp);
    

    /* void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *)); 
         The qsort() function sorts an array with nmemb elements of size size.*/
    qsort(numbers, nlinha, sizeof(int), compareInts);

    printf("Sorted numbers: \n");
    for(i = 0 ; i < nlinha ; i++)
    {
        printf("%d\n", numbers[i]);
    }

    return EXIT_SUCCESS;
}

