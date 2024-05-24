#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>
#define N 50000
int rows = N;
int columns = N;
int main()
{
    srand(time(0));
    int* a = (int*)malloc(rows * columns * sizeof(int));
    int* b = (int*)malloc(rows * columns * sizeof(int));
    int* c = (int*)malloc(rows * columns * sizeof(int));
    
    for(int i = 0; i < rows; i ++)
    {
        for(int j = 0; j < columns; j++)
        {
            a[i * columns + j] = rand() % 100;
            b[i * columns + j] = rand() % 100;
        }
    }

    #pragma omp parallel for
    for(int i = 0; i < N; i ++)
    {
        for(int j = 0; j < N; j++)
        {
            c[i * columns + j] = a[i * columns + j] + b[i * columns + j];
        }
    }
   int flag = 1;
    for(int i = 0; i < N; i ++)
    {
        for(int j = 0; j < N; j++)
        {
            // printf("%d + %d = %d \n", a[i * columns + j],b[i * columns + j],c[i * columns + j]);
           if (a[i * columns + j] + b[i * columns + j] != c[i * columns + j])
           {
                printf("Error! %d + %d != %d \n", a[i * columns + j],b[i * columns + j],c[i * columns + j]);
                flag = 0;
           }
        }
    }
    if(flag)
    {
        printf("Program executed successfully\n");
    }

    free(a);
    free(b);
    free(c);
}