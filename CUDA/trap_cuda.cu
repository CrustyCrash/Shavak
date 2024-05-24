#include <stdio.h>
#include <cuda_runtime.h>

__device__ double f(double x)
{
    return 1/(1+x*x);
}

__global__ void trapezoidal(double a, double b, int n)
{
    double h = (b-a)/n;
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if(tid > 1 && tid < n)
    {
    double x = a + tid * h;
    double my_trap = f(x);
    atomicAdd(sum, my_trap);
    }
}

int main()
{
    double a = 0.0;
    double b = 1.0;
    double* sum;
    int n = 100000;
    cudaMallocManaged(&sum, sizeof(double));

    *sum = 0.5(f(a) + f(b));
    

}

