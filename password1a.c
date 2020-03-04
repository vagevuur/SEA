#include <stdio.h>
#include <string.h>
#define MAX 15

int main(void)
{
    char buff[15];
    int pass = 0;
    printf("Enter password: \n");
    fgets(buff, MAX, stdin);
    int sum = 0;
    for (int i=0; i < strlen(buff); i++){
	sum += (int)buff[i];
    }
    printf("Value is: %d\n", sum);
    if(sum == 650) {
        printf ("Acces granted! \n");
	pass = 1;
    } else {
        printf ("Try again, may the force be with you! \n");
    }

    if(pass) {
       /* Now Give root or admin rights to user*/
        printf ("\nRoot access \n");
    }
    return 0;
}
