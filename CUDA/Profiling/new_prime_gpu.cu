#include <stdio.h>
#include <cuda_runtime.h>
#include <time.h>

#include <math.h>

#define N 100
int threads = 100;
// Calculating number of blocks
int blocks = (N + threads - 1) / threads;

__device__ bool isprime(int tid)
{
    if(tid < 2) return false;
    if (tid % 2 == 0) return false;
    if (tid == 2) return true;
 
    for (int i = 3; i <= sqrtf((float)tid); i += 2)
    {
        if (tid % i == 0) return false;
    }
    return true;
}

__global__ void prime(int* count)
{
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid >= 2 && tid < N && isprime(tid))
    {
        atomicAdd(count, 1);
    }
}

int main()
{
    int* count;

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaMalloc((void**)&count, sizeof(int));
    cudaMemset(count, 0, sizeof(int));

    
    cudaEventRecord(start);
    prime<<<blocks, threads>>>(count);
    cudaDeviceSynchronize();
    cudaEventRecord(stop);

    int result;
    cudaMemcpy(&result, count, sizeof(int), cudaMemcpyDeviceToHost);
    cudaEventSynchronize(stop);

    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    printf("Number of primes between 2 and %d: %d\n", N, result);
    printf("Time taken: %f ms\n", milliseconds);

    cudaFree(count);
    return 0;
}