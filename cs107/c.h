#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<sys/mman.h>
typedef void V;typedef int I;typedef double F;typedef unsigned char C,*S;typedef long L;
#define O           printf
#define R           return
#define I(a...)     if(a)
#define W(a...)     while(a)

#define A(a...)     {if(!(a))R 0;}
#define Q(x,s)      {if(x)R O("ERROR: %s\n",s),(S)0;}

#define P(x,a...)   {if(x)R a;}
#define N(n,a...)   {I i=0,_i=(n);for(;i<_i;++i){a;}}
#define J(n,a...)   {I j=0,_j=(n);for(;j<_j;++j){a;}}
#define MIN(a,b)    ({typeof(a)_a=(a);typeof(a)_b=(b);_a<_b?_a:_b;})
#define MAX(a,b)    ({typeof(a)_a=(a);typeof(a)_b=(b);_a>_b?_a:_b;})
#define L8          (8==sizeof(L))
__inline S map(L*n,S s){I d=open(s,0);Q(0>d,s)L b[22];R fstat(d,&b),s=mmap(0,*n=b[L8+5],PROT_READ,MAP_PRIVATE,d,0),close(d),s;}

