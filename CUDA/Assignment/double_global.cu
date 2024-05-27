#include <stdio.h>
#include <cuda_runtime.h>

int size = 1000000;
int threadPerBlock = 1024;
int blockPerGrid = (size + threadPerBlock - 1) / threadPerBlock;

__global__ void square(int* num)
{
    int value = *num;
    *num = value * value;
}

__global__ void doubleValues(int* data, int size)
{
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    if (i < size)
    {
        int value = data[i];
        int* d_value;
        cudaMalloc((void**)&d_value, sizeof(int));
        cudaMemcpy(d_value, &value, sizeof(int), cudaMemcpyHostToDevice);

        // Launch square kernel dynamically
        square<<<1, 1>>>(d_value);
        cudaDeviceSynchronize(); // Wait for the square kernel to complete

        cudaMemcpy(&value, d_value, sizeof(int), cudaMemcpyDeviceToHost);
        cudaFree(d_value);

        data[i] = value * 2;
    }
}

int main()
{
    int* data_host = new int[size];
    int* data_device;
    cudaMalloc(&data_device, size * sizeof(int));

    for (int i = 0; i < size; i++)
    {
        data_host[i] = i;
    }
    cudaMemcpy(data_device, data_host, size * sizeof(int), cudaMemcpyHostToDevice);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    doubleValues<<<blockPerGrid, threadPerBlock>>>(data_device, size);
    cudaDeviceSynchronize(); // Wait for the doubleValues kernel to complete

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms = 0;
    cudaEventElapsedTime(&ms, start, stop);

    cudaMemcpy(data_host, data_device, size * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Time taken to execute kernel function: %fms\n", ms);
    
    cudaFree(data_device);
    delete[] data_host;
    return 0;
}