#include <stdio.h>
#include <stdlib.h>

void emphasize8(char *img, int width, int height, int stride);

int main(
    int argc,
    char *argv[])
{
    char *file_name =  argv[1];
    int width, height;
    char *img;

    FILE *fp = fopen(file_name, "rb");
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
    int startOfImage = *(int *)(file_header + 10);
    int stride = (fileWidth + 3) / 4 * 4;
    printf("file size: %d\n", fileSize);
    printf("file width: %d\n", fileWidth);
    printf("file height: %d\n", fileHeight);
    printf("stride: %d\n", stride);
    printf("start of image: %d\n", startOfImage);

    char *file_header_with_palette = (char *)malloc(startOfImage - 54);
    fread(file_header_with_palette, 1, startOfImage - 54, fp);

    // read image data
    img = (char *)malloc(fileSize - startOfImage);
    fread(img, 1, fileSize - startOfImage, fp);
    fclose(fp);
    emphasize8(img, fileWidth, fileHeight, stride);


    fp = fopen("output.bmp", "wb");
    fwrite(file_header, 1, 54, fp);
    fwrite(file_header_with_palette, 1, startOfImage - 54, fp);
    fwrite(img, 1, fileSize - startOfImage, fp);

    return 0;
}