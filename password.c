#include <stdio.h>
#include <string.h>

int main(void)
{
    char buff[15];
    int pass = 0;
    printf("Enter password: \n");
    gets(buff);
    if(!strcmp(buff, "hanism"))
    {
        printf ("Acces granted! \n");
	pass = 1;
    }
    else
    {
        printf ("Try again, may the force be with you! \n");
    }

    if(pass)
    {
       /* Now Give root or admin rights to user*/
        printf ("\nRoot access \n");
    }

    return 0;
}
