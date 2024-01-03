#include <stdio.h>

char *change_string(char *s);  // leave longest sequence of decimal digits

int main(int argc, char* argv[]) {
    printf("%i\n", argc);
    printf("%s\n", argv[1]);
    printf("%s\n", change_string(argv[1]));
}