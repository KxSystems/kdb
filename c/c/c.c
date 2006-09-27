// q trade.q -p 5001
// l32: gcc ../c/c/c.c c.o -lpthread
// s32: /usr/local/gcc-3.3.2/bin/gcc ../c/c/c.c c.o -lsocket -lnsl -lpthread
// w32: cl  ../c/c/c.c c.lib ws2_32.lib
#include"k.h"

int main(){
  int c=khp("localhost",5001);                         //connect
  k(-c,"`trade insert(14:34:56.789;`IBM;99.54;300)",(K)0);//insert
  k(c,"",(K)0); // flush                              
  return 0;}

/*
#define Q(e,s) {if(e)return printf("%s\n",s),-1;}      //error

int main(){K x,y;int c=khpu("localhost",5001,"usr:pwd");
 Q(c<0,"connect")Q(!c,"access")
 Q(!k(-c,"`trade insert(12:34:56.789;`xx;93.5;300)",(K)0),"err") // statement insert
 Q(!(x=k(c,"select sum size by sym from trade",0)),"err")    // statement select
 Q(!(x=ktd(x)),"type")                   // flip from keyedtable(dict)
  y=x->k;                                // dict from flip
  y=kK(y)[1],printf("%d cols:\n",y->n);  // data from dict
  y=kK(y)[0],printf("%d rows:\n",y->n);  // column 0
  printf("%s\n",kS(y)[0]);               // sym 0 
  r0(x);                                 // release memory
 x=knk(4,kt(1000*(time(0)%86400)),ks("xx"),kf(93.5),ki(300)); // data record
// DO(10000,Q(!k(-c,"insert",ks((S)"trade"),r1(x),(K)0),es)) // 10000 asynch inserts
// k(c,"",(K)0); // synch chase
// return 0;
 Q(!k(-c,"insert",ks("trade"),x,(K)0),"err")                           // parameter insert
 Q(!(x=k(c,"{[x]select from trade where size>x}",ki(100),(K)0)),"err") // parameter select
  r0(x);
 close(c);
 return 0;}
*/
