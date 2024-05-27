#include <iostream>
#include <math.h>
#define N 100

int main()
{
   
    int count = 0;
    for(int i = 4; i < N; i++)
    {
        bool flag = true;
        for(int j = 2; j <= sqrt(i); j++)
        {
            if (i%j == 0)
            {
                flag = false;
                break;
            }

        }
        if (flag)
        {
            std::cout<<i<<std::endl;
            count++;
        }

    }

    std::cout<<"Total prime number between 1-100 are: "<< 2 + count <<std::endl;

}