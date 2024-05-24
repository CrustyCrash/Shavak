#include <stdio.h>
#include <cuda_runtime.h>

// kernel to be executed on gpu
__global__ void gpu_print(void)
{
  printf("Block ID: %d, Thread ID: %d\n", blockIdx.x, threadIdx.x);
  printf("Global ID: %d\n", threadIdx.x + blockIdx.x * blockDim.x);
}

void cpu_print(void)
{
  printf("Hello from CPU\n");
}

int main()
{
  gpu_print<<<2,10>>>();
  cudaDeviceSynchronize();

  cpu_print();
  
  return 0;
}