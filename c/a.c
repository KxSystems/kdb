// w32>cl /LD ..\c\a.c a.def q.lib
// l32>/usr/local/gcc-3.3.2/bin/gcc -shared ../c/a.c -o a.so
// s32>/usr/local/gcc-3.3.2/bin/gcc -G      ../c/a.c -o a.so

#include"k.h"
K f(K x){return ki(x->i+1);}  // q calls c
K g(K x){return k(0,"1+",r1(x),0);} // c calls q


/*
f:`a 2:(`f;1)
g:`a 2:(`g;1)
f 2
g 3
*/