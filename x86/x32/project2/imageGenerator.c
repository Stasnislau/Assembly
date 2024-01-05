#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
    srand(time(NULL));
    int width = 1020;
    int height = 1020;
    const int boundary = 20;
    char *file_name = "generatedTest.bmp";

    FILE *fp = fopen(file_name, "wb");
    if (fp == NULL)
    {
        printf("Error: cannot open file\n");
        return 1;
    }

    int stride = (width + 3) / 4 * 4; // Each row is padded to a multiple of 4 bytes

    // Create and write the BMP header
    unsigned char file_header[54] = {'B', 'M'};
    *(int *)(file_header + 2) = 54 + 256 * 4 + stride * height; // File size
    *(int *)(file_header + 10) = 54 + 256 * 4;                  // Offset to bitmap data
    *(int *)(file_header + 14) = 40;                            // Size of BITMAPINFOHEADER
    *(int *)(file_header + 18) = width;                         // Image width
    *(int *)(file_header + 22) = height;                       // Image height 
    *(short *)(file_header + 26) = 1;                           // Number of color planes
    *(short *)(file_header + 28) = 8;                           // Bits per pixel
    *(int *)(file_header + 34) = stride * height;               // Size of bitmap data
    fwrite(file_header, 1, 54, fp);

    // Create the color palette
    unsigned char palette[256 * 4];
    for (int i = 0; i < 256; i++)
    {
        palette[i * 4] = i;
        palette[i * 4 + 1] = i;
        palette[i * 4 + 2] = i;
        palette[i * 4 + 3] = 0;
    }

    // Write the color palette to the file
    fwrite(palette, 1, sizeof(palette), fp);

    // Allocate memory for the image data
    unsigned char *img = malloc(stride * height);
    if (img == NULL)
    {
        printf("Error: cannot allocate memory\n");
        return 1;
    }

    // Generate the random pixel values
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            img[i * stride + j] = (unsigned char)(rand() % (256 - boundary) + boundary);
        }
    }

    fwrite(img, 1, stride * height, fp);

    free(img);
    fclose(fp);

    return 0;
}