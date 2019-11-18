#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    int ret;

    printf ("Antes do fork: PID = %d, PPID = %d\n", getpid (), getppid ()); //executado pelo pai
    if ((ret = fork ()) < 0) { //executado pelo pai e pelo filho
        perror ("erro na duplicação do processo");
        return EXIT_FAILURE;
    }
    if (ret > 0) /*executado pelo pai e filho*/ sleep (1); //executado pelo pai
    printf ("Quem sou eu?\nApós o fork: PID = %d, PPID = %d\n", getpid (), getppid ());//executado pelo pai e filho

    return EXIT_SUCCESS;
}
