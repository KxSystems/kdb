//2008.02.05 dispatch
//cl /LD ..\c\feed\ssl.c ssl.def q.lib \ssl\ssl4w32.lib
//gcc -m32 -shared -fPIC ../c/feed/ssl.c -o ssl.so libssl.a
//usr/local/gcc-3.3.2/bin/gcc -G -fPIC ../c/ssl.c -o ssl.so libssl.so
//gcc -G -fPIC ../c/feed/ssl.c -o ssl.so /apps/reuters/ssl/lib/sun4_5.5/libssl.so.4
#include"ssl.h"
#include"../c/k.h"
#define Q(x,s) if((x)<0){O("sslerror: %s\n",s);R s;}
ZI c=-1,d,f;ZK x,y;       K1(dispatch){sslDispatchEvent(SSL_ALL_CHANNEL,SSL_EXHAUST_READ);R 0;}
ZK d0(I d){if(f)x=ktn(KS,0),y=ktn(0,0);else x=ktn(0,0);dispatch(0);P(xn,k(0,"f",x,y,(K)0))if(y)r0(y);R x;}
ZS con(){Q(sslGetProperty(c,SSL_OPT_CHANNEL_FD,&d),"getfd")sd1(d,d0);R 0;}
#define SSL(f,x) Z SSL_EVENT_RETCODE f(I c,SSL_EVENT_TYPE t,SSL_EVENT_INFO*e,void*v){x;R SSL_ER_EVENT_HANDLE_OK;}
SSL(upd,{S p=e->ItemImage.Data;I n=e->ItemImage.DataLength;
 if(f){js(&x,ss(e->ItemImage.ItemName));jk(&y,kpn(p+1,n-2));}  //"I\037\036"0:
 else{DO(n,if(p[i]==30)p[i]='\n')p[n-1]='\n';jk(&x,kpn(p,n));}})
SSL(stt,r0(k(0,"stt",ks(ss(e->ItemStatus.ItemName)),ks(ss(e->ItemStatus.Text)),ki(t),(K)0)))
SSL(dis,r0(k(0,"dis[]",(K)0));sd0(d))SSL(rec,con();r0(k(0,"rec[]",(K)0)))
ZS ini(S s){P(c!=-1,0)Q(sslInit(SSL_VERSION_NO),"sslinit")Q(c=sslSnkMount(s,0),"snkmount")
 sslRegisterClassCallBack(c,SSL_EC_ITEM_STATUS,stt,0);sslRegisterCallBack(c,SSL_ET_SESSION_DISCONNECTED,dis,0);
 sslRegisterClassCallBack(c,SSL_EC_DATA,upd,0);sslRegisterCallBack(c,SSL_ET_SESSION_RECONNECTED,rec,0);R con();}
#define Q1(x,s) P(x,krr(s))
K1(init){f=xt==KC;Q1(!f&&xt!=-KS,"type")Q1(ini(f?sn(xC,xn):xs),"init")R 0;}
K2( ssub){I v=y->t==KS;S s;Q1(xt!=-KS||!v&&y->t!=-KS,"type")Q1(ini(""),"init")DO(v?y->n:1,Q1(sslSnkOpen(c,xs,s=v?kS(y)[i]:y->s,0,0),s))R r1(y);}
K2(ussub){I v=y->t==KS;S s;Q1(xt!=-KS||!v&&y->t!=-KS,"type")Q1(ini(""),"init")DO(v?y->n:1,Q1(sslSnkClose(c,xs,s=v?kS(y)[i]:y->s),s))   R r1(y);}
K  sub(K y){K x=ks(ss("IDN_SELECTFEED"));R y= ssub(x,y),r0(x),y;}
K usub(K y){K x=ks(ss("IDN_SELECTFEED"));R y=ussub(x,y),r0(x),y;}

// vt100 escape codes for page records updates: <esc>[n` - move to n (counting from 0); c<esc>[nb - repeat c n-times
K2(esc){K r;I i=0,j=0,n,m;C c;S e;if(10!=xt||10!=y->t)R krr("type");r=ktn(KC,xn);memcpy(kG(r),kG(x),xn);
 while(i<y->n){if(kG(y)[i]!=0x1B)kG(r)[j++]=c=kG(y)[i++];else{++i;n=0;while(10>(m=kG(y)[++i]-48)&&m>=0)n=m+n*10;
  SW(kG(y)[i++]){CS('`',j=n)CS('b',DO(n-1,kG(r)[j++]=c))}}}R r;}

/*
2007.10.01 dis then sd0();dispatch[]
2007.06.26 k(0,..,(K)0)
2006.06.27 new stt
2006.05.19 s32/stt[x;y;z]
2006.03.01 init""->f[s;x]
2006.01.09 init
2005.01.10 ssub 2005.01.28(dll)
2004.09.27 EC_DATA(for level2 image)

340/image 316/update
Q(sslRegisterCallBack(c,SSL_ET_ITEM_STATUS_CLOSED,cls,0),"cls") rejected
Q(sslRegisterCallBack(c,SSL_ET_ITEM_UPDATE SSL_ET_ITEM_IMAGE
Q(sslErrorLog("/tmp/ssl.log",100000),"errorlog")
SSL(stt,R0(k(0,"stt",ks(ss(e->ItemStatus.ItemName)),ki(t),(K)0))) //7close 8recover 9info 10ok 11stale
int t=SSL_ON;Q(sslSetProperty(SSL_ALL_CHANNEL,SSL_OPT_LOG_FUNCTION_ERROR,&t),"...")
#include <sys/types.h>#include<sys/socket.h>
main(I c,S*v){for(init();1;){fd_set readfds;FD_ZERO(&readfds);FD_SET(d,&readfds);select(FD_SETSIZE,&readfds,0,0,0);d0(d);}}
if(e->ItemImage.ItemType.DataFormat!=SSL_DF_MARKETFEED_RECORD)O("page? %s\n",e->ItemImage.ItemName);else 
*/
