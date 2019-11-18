#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

typedef struct
{
    int age;
    double height;
    char name[64];
} Person;

void printPersonInfo(Person *p)
{
    printf("Person: %s, %d, %f\n", p->name, p->age, p->height);
}

int main (int argc, char *argv[])
{
    FILE *fp = NULL;
    int i;
    Person p = {35, 1.65, "xpto"};

    /* Validate number of arguments */
    if(argc != 2)
    {
        printf("USAGE: %s fileName\n", argv[0]);
        return EXIT_FAILURE;
    }

    /* Open the file provided as argument */
    errno = 0;
    fp = fopen(argv[1], "wb");
    if(fp == NULL)
    {
        perror ("Error opening file!");
        return EXIT_FAILURE;
    }
    int people;
    /* Write 10 itens on a file */
    printf("How many people, dude?");
    scanf("%d", &people);

    for(i = 0 ; i < people ; i++)
    {   
        printf("What's his/her name, dude?\n");
        scanf("%s", p.name);
        printf("What's his/her age, dude?\n");
        scanf("%i", &p.age);
        printf("What's his/her height, dude?\n");
        scanf("%lf", &p.height);




        fwrite(&p, sizeof(Person), 1, fp);
    }

    fclose(fp);

    return EXIT_SUCCESS;
}
