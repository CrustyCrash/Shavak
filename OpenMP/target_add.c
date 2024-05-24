#include <stdio.h>
#include <omp.h>
#define N 100

int main()
{
    int A[N][N], B[N][N], C[N][N];
    /* initialize the arrays */
    for(int i = 0; i < N; i++)
    {
        for(int j = 0; j < N; j++)
        {
            A[i][j] = i+j;
            B[i][j] = -i-j;
        }
    }

    #pragma omp target
    {
        for(int i = 0; i < N; i++)
        {
            for(int j = 0; j < N; j++)
            {
                C[i][j] = A[i][j] + B[i][j];
            }
        }
    }

    for(int i = 0; i < N; i++)
    {
        for(int j = 0; j < N; j++)
        {
            printf("%d\t", C[i][j]);
        }
    }
}