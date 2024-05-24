#include <stdio.h>
#include <cuda_runtime.h>
#define N 90000
int threads = 1024;
//calculating number of blocks
int block = (N+threads-1)/threads;

__global__ void add(int* dev_a, int* dev_b, int* dev_c)
{
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
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


    for(int i = 0; i < N; i++)
    {
        a[i] = i;
        b[i] = i;
    }

    int* dev_a;
    int* dev_b;
    int* dev_c;

    cudaMalloc((void**)&dev_a, N * sizeof(int));
    cudaMalloc((void**)&dev_b, N * sizeof(int));
    cudaMalloc((void**)&dev_c, N * sizeof(int));

    cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice);

    //start timing GPU execution 
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    add <<<block,threads>>> (dev_a, dev_b, dev_c);
    
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms = 0;
    cudaEventElapsedTime(&ms, start, stop);

    cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);

    bool verify = true;
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

    printf("Time taken by GPU: %fms\n", ms);

    free(a);
    free(b);
    free(c);

    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);

}

