    #include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{ 
     printf("=============================================\n"); 
    int stat;

    printf ("Pai (antes do fork): PID = %u, PPID = %u\n", getpid (), getppid ());
    switch (fork ())
    {
      case -1: /* fork falhou */
               perror ("Erro no fork\n");
               return EXIT_FAILURE;
      case 0:  /* processo filho */
               execl ("/bin/ls", "/bin/ls", "-la", NULL);
                perror ("erro no lancamento da aplicacao");
                return EXIT_FAILURE;
            
               break;
      default: /* processo pai */
               printf ("Pai (depois do fork): PID = %u, PPID = %u\n", getpid (), getppid ());
               wait (&stat);
               printf("=============================================\n"); 
                perror ("erro na espera da terminação do processo-filho");
                return EXIT_FAILURE;
            
               printf ("Pai: o processo-filho terminou. ");
               if (WIFEXITED (stat) != 0) {
                   printf ("O seu status de saída foi %d.\n", WEXITSTATUS (stat));
               }
               else {
                   printf ("O processo filho terminou de forma anormal.\n");
               }
    }

    return EXIT_SUCCESS;
}
