#include <stdio.h>

char *change_string(char *s, char a, char b); // remove all characters in s that are between a and b

int main(int argc, char* argv[]) {
    printf("%i\n", argc);
    printf("%s\n", argv[1]);
    printf("%s\n", argv[2]);
    printf("%s\n", argv[3]);
    printf("%s\n", change_string(argv[1], argv[2][0], argv[3][0]));
}