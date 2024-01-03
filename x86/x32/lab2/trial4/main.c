#include <stdio.h>

char *change_string(char *s, char a);  // replace each sequence of digits in s with a

int main(int argc, char* argv[]) {
    printf("%i\n", argc);
    printf("%s\n", argv[1]);
    printf("%s\n", argv[2]);
    printf("%s\n", change_string(argv[1], argv[2][0]));
}