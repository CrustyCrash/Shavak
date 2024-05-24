#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#define N (33 * 1024)

//kernel to be excuted on GPU
__global__ void sum(int* dev_a, int* dev_b, int* dev_c)
{
    // global thread id
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    
    //only making the threads with index < N perform the action to prevent out of bound errors
    if (tid < N)
    {
        dev_c[tid] = dev_a[tid] + dev_b[tid];
    }
}

int main()
{
    int* a = (int*)malloc(N * sizeof(int));
    int* b = (int*)malloc(N * sizeof(int));
    int* c = (int*)malloc(N * sizeof(int));

    //initialising the array on the cpu
    for(int i = 0; i < N; i++)
    {
        a[i] = i;
        b[i] = -i;
    }

    // pointers on device
    int* dev_a;
    int* dev_b;
    int* dev_c;

    //allocating memory on the device
    cudaMalloc((void**)&dev_a, N * sizeof(int));
    cudaMalloc((void**)&dev_b, N * sizeof(int));
    cudaMalloc((void**)&dev_c, N * sizeof(int));

    //copying array from host to device
    cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice);

    //calling kernel with 512 blocks and 512 threads
    sum <<<512,512>>>(dev_a, dev_b, dev_c);
    
    //copying result from device to host
    cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);
    bool verify = true;

    //verifying if the output is correct
    for(int i = 0; i < N; i++)
    {
        if(a[i] + b[i] != c[i])
        {
            printf("Failed at %d + %d != %d\n",a[i],b[i],c[i]);
            verify = false;
        }
    }
    
    if(verify)
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