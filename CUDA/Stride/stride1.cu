#include <stdio.h>
#include <cuda_runtime.h>
#define N 1000

__global__ void vector_add(int* dev_a, int* dev_b, int* dev_c)
{
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    for(int i = tid; i < N; i+=blockDim.x)
    {
        dev_c[i] = dev_a[i] + dev_b[i];
    }
}

int main()
{
    int* a = (int*)malloc(N * sizeof(int));
    int* b = (int*)malloc(N * sizeof(int));;
    int* c = (int*)malloc(N * sizeof(int));;
    int *dev_a, *dev_b, *dev_c;

    for(int i = 1; i < N; i++)
    {
        a[i] = i;
        b[i] = i;
    }

    cudaMalloc((void**)&dev_a, N * sizeof(int));
    cudaMalloc((void**)&dev_b, N * sizeof(int));
    cudaMalloc((void**)&dev_c, N * sizeof(int));

    cudaMemcpy(dev_a,a,N*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b,b,N*sizeof(int), cudaMemcpyHostToDevice);

    int block_size = 1;
    int thread_num = 100;

    vector_add<<<block_size,thread_num>>>(dev_a,dev_b,dev_c);

    cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);

    bool flag = true;
    for(int i = 0; i < N; i++)
    {

        if(a[i] + b[i] != c[i])
        {
            printf("Error at %d + %d != %d\n",a[i],b[i],c[i]);
            flag = false;
        }
    }
    if(flag)
    {
        printf("Program executed successfully!\n");
    }
    free(a);
    free(b);
    free(c);
    
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
}