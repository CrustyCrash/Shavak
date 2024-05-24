#include <stdio.h>
#include <omp.h>
#include <stdlib.h>
#include <time.h>

#define N 10

int rows = N;
int cols = N;

int main()
{
    int* a = (int*)malloc(N * N * sizeof(int));
    int* b = (int*)malloc(N * N * sizeof(int));
    int* c = (int*)malloc(N * N * sizeof(int));
    srand(time(0));

    for(int i = 0; i < N; i++)
    {
        for(int j = 0; j < N; j++)
        {
            a[i * cols + j] = rand() % 100;
            b[i * cols + j] = rand() % 100;
            c[i * cols + j] = 0;
        }
    }

    #pragma omp parallel for collapse(2) 
    for(int i = 0; i < N; i++)
    {
        for(int j = 0; j < N; j++)
        {
            for(int k = 0; k < N; k++)
            {
                c[i * cols + j] += a[i * cols + j] * b[i * cols + k];
            }
            
        }
    }

    for(int i = 0; i < N; i++)
    {
        for(int j = 0; j < N; j++)
        {
            for(int k = 0; k < N; k++)
            {
                printf("%d * %d = %d\n", a[i * cols + j], b[i * cols + k], c[i * cols + j]);
            }
            
        }
    }
}