#include <stdio.h>
#include <time.h>
#include <math.h>
#define N 100001

int main()
{
    int count = 0;
    
    for(int i = 2; i < N+1; i++)
    {
        if (i==2) 
        {
            count++;
            continue;
        }
        if(i%2==0)
        {
            continue;
        }

        bool flag = true;
        
        for(int j = 3; j <= sqrt(i); j+=2 )
        {
            if(i%j==0)
            {
                flag = false;
                break;
            }
        }
        if(flag)
        {
            count++;
        }   

    }
    printf("%d\n",count);

}