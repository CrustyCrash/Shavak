#include <stdio.h>
#include <cuda_runtime.h>

__device__ int square(int num)
{
    // printf("Thread (%d, %d) - squaring value \n", blockIdx.x, threadIdx.x);
    return num * num;
}

__global__ void doubleValues(int* data, int size)
{
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    if (i < size)
    {
        int value = data[i];
        int squared_value = square(value);
        // printf("Thread (%d, %d) - doubling squared value \n", blockIdx.x, threadIdx.x);
        data[i] = squared_value*2;
    }
}

int main()
{
    int size = 1000000;
    int* data_host = new int[size];
    int* data_device;
    cudaMalloc(&data_device, size * sizeof(int));

    for(int i = 0; i < size; i++)
    {
        data_host[i] = i;
    }
    cudaMemcpy(data_device, data_host, size * sizeof(int), cudaMemcpyHostToDevice);

    int threadPerBlock = 1024;
    int blockPerGrid = (size + threadPerBlock - 1) / threadPerBlock;

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    doubleValues<<<blockPerGrid, threadPerBlock>>>(data_device, size);

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms = 0;
    cudaEventElapsedTime(&ms, start, stop);

    cudaMemcpy(data_host, data_device, size*sizeof(int), cudaMemcpyDeviceToHost);
    // for(int i = 0; i < size; i++)
    // {
    //     printf("%d ", data_host[i]);
        
    // }
    printf("Time taken to execute kernel function: %fms\n", ms);
    cudaFree(data_device);
    delete[] data_host;
    return 0;
}