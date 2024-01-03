#include <stdio.h>

char *change_string(char *s, int v);

int main(int argc, char *argv[])
{
    int x;
    if (sscanf(argv[1], "%d", &x))
        printf("arg %d is number %d\n", 1, x);
    else
        printf("wrong argument %d\n", 1);
    char *s = argv[11];
    printf("%i \n", x);
    printf("%s \n", change_string(s, x));
}