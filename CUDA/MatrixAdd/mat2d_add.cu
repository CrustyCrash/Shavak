#include <stdio.h>
#include <cuda_runtime.h>
#include <math.h>

#define N 16

__global__ void add2D(int* a, int* b, int* c, int rows, int cols)
{
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    int j = threadIdx.y + blockIdx.y * blockDim.y;

   if(i < rows && j < cols) 
    {
        c[i*cols + j] = a[i*cols + j] + b[i*cols + j];
    } 
}

int main()
{
    int rows = 4096;
    int cols = 2048;
    dim3 dimBlock(N,N);
    dim3 dimGrid ((rows+N-1)/N, (cols+N-1)/N);
    int *a = (int*)malloc(rows * cols * sizeof(int));
    int *b = (int*)malloc(rows * cols * sizeof(int));
    int *c = (int*)malloc(rows * cols * sizeof(int));

    int* dev_a;
    int* dev_b;
    int* dev_c;

    cudaError_t err = cudaMalloc((void**)&dev_a, rows*cols*sizeof(int));
    if(err!= cudaSuccess)
    {
        printf("Error: %s in file %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
        exit(EXIT_FAILURE);
    }

    err = cudaMalloc((void**)&dev_b, rows*cols*sizeof(int));
    if(err!= cudaSuccess)
    {
        printf("Error: %s in file %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
        exit(EXIT_FAILURE);
    }

    err = cudaMalloc((void**)&dev_c, rows*cols*sizeof(int));
    if(err!= cudaSuccess)
    {
        printf("Error: %s in file %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
        exit(EXIT_FAILURE);
    }

    for(int i = 0; i < rows; i++)
    {
        for(int j = 0; j < cols; j++)
        {
            a[i*cols+j] = i+i;
            b[i*cols+j] = i+j;
        }
    }

    cudaError_t memCheck = cudaMemcpy(dev_a,a,rows*cols*sizeof(int),cudaMemcpyHostToDevice);
    if(memCheck!= cudaSuccess)
    {
        printf("Error: %s in file %s at line %d\n", cudaGetErrorString(memCheck), __FILE__, __LINE__);
        exit(EXIT_FAILURE);
    }

    memCheck = cudaMemcpy(dev_b,b,rows*cols*sizeof(int),cudaMemcpyHostToDevice);
    if(memCheck!= cudaSuccess)
    {
        printf("Error: %s in file %s at line %d\n", cudaGetErrorString(memCheck), __FILE__, __LINE__);
        exit(EXIT_FAILURE);
    }

    add2D<<<dimGrid,dimBlock>>>(dev_a, dev_b, dev_c, rows, cols);

    memCheck = cudaMemcpy(c,dev_c,rows*cols*sizeof(int),cudaMemcpyDeviceToHost);
    if(memCheck!= cudaSuccess)
    {
        printf("Error: %s in file %s at line %d\n", cudaGetErrorString(memCheck), __FILE__, __LINE__);
        exit(EXIT_FAILURE);
    }

    bool flag = true;
    for(int i = 0; i < rows; i++)
    {
        for(int j = 0; j < cols; j++)
        {
            if(c[i*cols+j]!=a[i*cols+j]+b[i*cols+j])
            {
                printf("Error! %d + %d != %d ", a[i*cols+j], b[i*cols+j], c[i*cols+j] );
                flag = false;
            }

        }
    }
    if(flag)
    {
        printf("Program executed successfully!");
    }

    free(a);
    free(b);
    free(c);
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    
}
