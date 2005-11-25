// 2005.01.10 ssub 2005.01.28(dll)
// 2004.09.27 EC_DATA(for level2 image)
// cl /LD ..\c\ssl.c ssl.def q.lib \ssl\ssl4w32.lib
// /usr/local/gcc-3.3.2/bin/gcc -shared ../c/ssl.c -o ssl.so libssl.a
// /usr/local/gcc-3.3.2/bin/gcc -G      ../c/ssl.c -o ssl.so libssl.so
#include "k.h"
#include "ssl.h"
#define Q(x,s) if((x)<0){O("sslerror: %s\n",s);R s;}
ZI c=-1,d;ZK x;ZK d0(I d){R x=ktn(0,0),sslDispatchEvent(SSL_ALL_CHANNEL,SSL_EXHAUST_READ),xn?k(0,"f",x,0):x;}
ZS con(){Q(sslGetProperty(c,SSL_OPT_CHANNEL_FD,&d),"getfd")sd1(d,d0);R 0;}ZV R0(K x){if(x)r0(x);}
#define SSL(f,x) Z SSL_EVENT_RETCODE f(I c,SSL_EVENT_TYPE t,SSL_EVENT_INFO*e,void*v){x;R SSL_ER_EVENT_HANDLE_OK;}
SSL(upd,{S p=e->ItemImage.Data;I n=e->ItemImage.DataLength;DO(n,if(p[i]==30)p[i]='\n')p[n-1]='\n';jk(&x,kpn(p,n));})
SSL(stt,R0(k(0,"stt",ks(ss(e->ItemStatus.ItemName)),ki(t),0))) //7close 8recover 9info 10ok 11stale
SSL(dis,sd0(d);R0(k(0,"dis[]",0)))
SSL(rec,con();R0(k(0,"rec[]",0)))

ZS init(){P(c!=-1,0)Q(sslInit(SSL_VERSION_NO),"sslinit")Q(c=sslSnkMount("",0),"snkmount")
 sslRegisterClassCallBack(c,SSL_EC_ITEM_STATUS,stt,0);sslRegisterCallBack(c,SSL_ET_SESSION_DISCONNECTED,dis,0);
 sslRegisterClassCallBack(c,SSL_EC_DATA,upd,0);sslRegisterCallBack(c,SSL_ET_SESSION_RECONNECTED,rec,0);R con();}
K2(ssub){I v=y->t==KS;P(xt!=-KS||!v&&y->t!=-KS,krr("type"))P(init(),krr("init"))
 DO(v?y->n:1,P(sslSnkOpen(c,xs,v?kS(y)[i]:y->s,0,0)<0,krr("snkopen")))R r1(y);}
K sub(K y){K x=ks(ss("IDN_SELECTFEED"));R y=ssub(x,y),r0(x),y;}

/*
340/state 316/update
Q(sslRegisterCallBack(c,SSL_ET_ITEM_STATUS_CLOSED,cls,0),"cls") rejected
Q(sslRegisterCallBack(c,SSL_ET_ITEM_UPDATE SSL_ET_ITEM_IMAGE
Q(sslErrorLog("/tmp/ssl.log",100000),"errorlog")
int t=SSL_ON;Q(sslSetProperty(SSL_ALL_CHANNEL,SSL_OPT_LOG_FUNCTION_ERROR,&t),"...")

#include <sys/types.h>#include<sys/socket.h>
main(I c,S*v){for(init();1;){fd_set readfds;FD_ZERO(&readfds);FD_SET(d,&readfds);select(FD_SETSIZE,&readfds,0,0,0);d0(d);}}

if(e->ItemImage.ItemType.DataFormat!=SSL_DF_MARKETFEED_RECORD)O("page? %s\n",e->ItemImage.ItemName);else 
*/
