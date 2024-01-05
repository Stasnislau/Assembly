#include <stdio.h>
#include <stdlib.h>

int emphasize8(char *img, int width, int height, int stride);

int main()
{
    int width, height;
    char *img;


    FILE *fp = fopen("generatedTest.bmp", "rb");
    if (fp == NULL)
    {
        printf("Error: cannot open file\n");
        return 1;
    }

    // read file header
    char *file_header = (char *)malloc(54);
    fread(file_header, 1, 54, fp);
    int fileSize = *(int *)(file_header + 2);
    int fileHeight = *(int *)(file_header + 22);
    int fileWidth = *(int *)(file_header + 18);
    int stride = (fileWidth + 3) / 4 * 4;
    printf("file size: %d\n", fileSize);
    printf("file width: %d\n", fileWidth);
    printf("file height: %d\n", fileHeight);
    printf("stride: %d\n", stride);

    // read image data
    img = (char *)malloc(fileSize - 54);
    fread(img, 1, fileSize - 54, fp);
    fclose(fp);

    unsigned int result = emphasize8(img, fileWidth, fileHeight, stride);
    // print as unsigned number
    printf("result: %u\n", result);

    fp = fopen("output.bmp", "wb");
    fwrite(file_header, 1, 54, fp);
    fwrite(img, 1, fileSize - 54, fp);

    return 0;
}