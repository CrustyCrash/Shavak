#include <stdio.h>
#include <cuda_runtime.h>

__global__ void hello()
{
  printf("Hello from GPU thread %d\n", threadIdx.x);
}

int main()
{
  hello<<<1,10>>>();
  cudaDeviceSynchronize();
  printf("Hello from CPU\n");
}