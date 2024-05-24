#include <stdio.h>
#include
#include <cuda_runtime.h>
#include<stdlib.h>

#define N 4
int rows = 10;
int cols = 10;
dim3 dimBlock(N,N);
dim3 dimGrid(rows + N - 1 / N, cols + N - 1 / N);

__global__ void displayGlobalId()
{
    int tidX = threadIdx.x + blockIdx.x * blockDim.x;
    int tidY = threadIdx.y + blockIdx.y * blockDim.y;
    int tBlocks = N*N;
    int Gid = tidX * tBlocks + tidY;
    printf("Global TID: %d\n", Gid);
}

int main()
{
    displayGlobalId<<<dimGrid,dimBlock>>>();
    cudaDeviceSynchronize();
    return 0;
}
