#include <stdio.h>
#include <cuda_runtime.h>
#include <stdlib.h>
#include <time.h>

const int size = 100;
__global__ void kernel(int* dev_a, int* dev_b, int* dev_c)
{
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    // int blockID = blockIdx.x;
    // int threadID = threadIdx.x;
    // int stride = blockDim.x * gridDim.x;
    // int threadPerBlock = blockDim.x;

    if(tid < size)
    {
        dev_c[tid] = dev_a[tid] + dev_b[tid];
    }
}


int main()
{
    
    srand(time(0));
    int hostarray[size];
    int hostarray2[size];
    int hostresult[size];

    for(int i = 0 ; i < size; i++)
    {
        hostarray[i] = rand() % 100;
        hostarray2[i] = rand() % 100;

    } 

    //GPU data
    int* deviceArray1;
    int* deviceArray2;
    int* deviceResultArray;

    //allocate device memory
    cudaError_t cudaStatus;

    cudaStatus = cudaMalloc((void**)&deviceArray1, size*sizeof(int));
    if (cudaStatus != cudaSuccess) 
    {
        fprintf(stderr, "cudaMalloc failed for deviceArray1! : %s in %s at line %d\n", cudaGetErrorString(cudaStatus),__FILE__,__LINE__);
        cudaFree(deviceArray1);
        exit(EXIT_FAILURE);
    }
    cudaStatus = cudaMalloc((void**)&deviceArray2, size*sizeof(int));
    if (cudaStatus != cudaSuccess) 
    {
        fprintf(stderr, "cudaMalloc failed for deviceArray2! :%s in %s at line %d\n", cudaGetErrorString(cudaStatus),__FILE__,__LINE__);
        cudaFree(deviceArray1);
        cudaFree(deviceArray2);
        exit(EXIT_FAILURE);
    }
    cudaStatus = cudaMalloc((void**)&deviceResultArray, size*sizeof(int));
    if (cudaStatus != cudaSuccess) 
    {
        fprintf(stderr, "cudaMalloc failed for deviceResultArray! : %s in %s at line %d\n", cudaGetErrorString(cudaStatus),__FILE__,__LINE__);
        cudaFree(deviceArray1);
        cudaFree(deviceArray2);
        cudaFree(deviceResultArray);
        exit(EXIT_FAILURE);
    }
    //copy host data to device
    cudaStatus = cudaMemcpy(deviceArray1, hostarray, size*sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess)
    {
        fprintf(stderr, "cudaMemcpy failed for deviceArray1! :  %s in %s at line %d\n", cudaGetErrorString(cudaStatus),__FILE__,__LINE__);
        cudaFree(deviceArray1);
        cudaFree(deviceArray2);
        cudaFree(deviceResultArray);
        exit(EXIT_FAILURE);
    }
    cudaStatus = cudaMemcpy(deviceArray2, hostarray2, size*sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess)
    {
        fprintf(stderr, "cudaMemcpy failed for deviceArray2! :  %s in %s at line %d\n", cudaGetErrorString(cudaStatus),__FILE__,__LINE__);
        cudaFree(deviceArray1);
        cudaFree(deviceArray2);
        cudaFree(deviceResultArray);
        exit(EXIT_FAILURE);
    }


    //launching the kernel
    kernel<<<1,size>>>(deviceArray1,deviceArray2,deviceResultArray);
    cudaStatus = cudaDeviceSynchronize();
    if (cudaStatus != cudaSuccess)
    {
        fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
        cudaFree(deviceArray1);
        cudaFree(deviceArray2);
        cudaFree(deviceResultArray);
        exit(EXIT_FAILURE);
    }
    //copying the result from device to host
    cudaStatus = cudaMemcpy(hostresult, deviceResultArray, size*sizeof(int), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess)
    {
        fprintf(stderr,"Failed MemcpyDeviceToHost:  %s in %s at line %d\n", cudaGetErrorString(cudaStatus),__FILE__,__LINE__);
        cudaFree(deviceArray1);
        cudaFree(deviceArray2);
        cudaFree(deviceResultArray);
        exit(EXIT_FAILURE);
    }
    //printing the result
    for (int i = 0; i < size; i++)
    {
        printf("%d + %d = %d \n",hostarray[i], hostarray2[i], hostresult[i]);
    }
    printf("\n");
    //freeing the memory
    cudaFree(deviceArray1);
    cudaFree(deviceArray2);
    cudaFree(deviceResultArray);
}