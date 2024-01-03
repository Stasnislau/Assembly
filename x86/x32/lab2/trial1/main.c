#include <stdio.h>


char *change_string(char *s); // replace every third character in s with x

int main(int argc, char* argv[]) {
    printf("%i\n", argc);
    printf("%s\n", argv[1]);
    printf("%s\n", change_string(argv[1]));
}