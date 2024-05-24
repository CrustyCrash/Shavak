#include <iostream>
#include <chrono>
#include <stdlib.h>

#define N 90000

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

// record start time
    auto start_time = std::chrono::high_resolution_clock::now();
    for(int i = 0; i < N; i++)
    {
        c[i] = a[i] + b[i];
    }
// record end time
    auto end_time = std::chrono::high_resolution_clock::now();

    //calulate duration
    auto duration_ns = std::chrono::duration_cast<std::chrono::nanoseconds>(end_time - start_time).count();
    double ms = duration_ns / 1000000.0; //convert ns to ms
    std::cout<< "time taken by CPU: " << ms << "ms" <<std::endl;
    

    free(a);
    free(b);
    free(c);

    return 0;
}