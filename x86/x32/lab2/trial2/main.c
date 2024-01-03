#include <stdio.h>

int change_string(char *s); // return the first sequence of digits in s as an integer, possibly negative

int main(int argc, char* argv[]) {
    printf("%s \n" , argv[1]) ;
    printf("%i \n" , change_string(argv[1]));
}