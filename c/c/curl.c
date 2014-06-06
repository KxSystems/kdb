//see http://code.kx.com/wiki/Cookbook/ExtendingWithC
//gcc -DKXVER=3 curl.c -o curl.so -lcurl -fPIC -shared
//{x set`:./curl 2:x,y}'[`cget`cpost;1 2]
//cget"http://kx.com"
#include<curl/curl.h>
#include"k.h"
#define so(c,o,v) curl_easy_setopt(c,CURLOPT_##o,v)

Z size_t wr(S p,size_t s,size_t n,V*d){K*x=d,y;jv(x,y=kpn(p,s*n));r0(y);R s*n;}
K cpost(K x,K y){C e[CURL_ERROR_SIZE];K r,a;CURL*c;if(xt!=KC||y&&y->t!=KC)R krr("type");if(!(c=curl_easy_init()))R krr("curl");
r=ktn(KC,0),a=ktn(KC,xn+1);DO(xn,kC(a)[i]=kC(x)[i])kC(a)[xn]=0;
if(y)so(c,POST,1L),so(c,POSTFIELDS,kC(y)),so(c,POSTFIELDSIZE,y->n);
so(c,URL,kC(a));so(c,ERRORBUFFER,e);so(c,FOLLOWLOCATION,1L);so(c,SSL_VERIFYPEER,0L);so(c,SSL_VERIFYHOST,0L);so(c,WRITEFUNCTION,wr);so(c,WRITEDATA,&r);
if(CURLE_OK!=curl_easy_perform(c))r0(r),r=krr(e);r0(a);curl_easy_cleanup(c);R r;}
K cget(K x){R cpost(x,0);}

