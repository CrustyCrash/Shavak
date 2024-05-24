#include <stdio.h>
#include <cuda_runtime.h>

__global__ void gpu_print(void)
{
  printf("Hello from GPU\n");
}

void cpu_print(void)
{
  printf("Hello from CPU\n");
}

int main()
{
  gpu_print<<<1,1>>>();
  gpu_print<<<1,1>>>();
  gpu_print<<<1,1>>>();

  cudaDeviceSynchronize();

  cpu_print();
  cpu_print();
  cpu_print();

  return 0;
}