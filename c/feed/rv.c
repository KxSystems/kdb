//2007.04.19 req(inbox) tables and lists
//w32>cl /LD rv.def ..\c\feed\rv.c q.lib ws2_32.lib tibrv.lib
//l32>gcc -shared ../c/feed/rv.c -o rv.so -I/dat/tibrv/linux/7.2/include -L/dat/tibrv/linux/7.2/lib -ltibrv 
//l64>gcc -shared ../c/feed/rv.c -o rv.so -I/dat/tibrv/linux/7.3/include -L/dat/tibrv/linux/7.3/lib -ltibrv64 -fPIC 
//s32>/usr/local/gcc-3.3.2/bin/gcc -G ../c/feed/rv.c -o rv.so -I/dat/tibrv/7.5.2/include -L/dat/tibrv/7.5.2/lib -ltibrv
//s64>/usr/local/gcc-3.3.2/bin/gcc -G -m64 ../c/feed/rv.c -o rv.so -I/dat/tibrv/7.5.2/include -L/dat/tibrv/7.5.2/lib -ltibrv64
#include"../c/k.h"
#include"tibrv/tibrv.h"  //missing KC KM KD KU KV KT  3z,8s,9b 14..25  (22-none) 1msg 7opaque 26port 27addr 32encr 47xml
extern V*malloc(),free();extern I memcpy(),strlen();
ZI tr(I t){R t==24?8:t/2-3;}ZJ o=10957*86400,j9=(J)1e9;Z tibrvMsgField f;Z tibrv_status s;
ZI rt[]={0,9,0,0,14,16,18,20,24,25,8,8,0,0,0, 3};typedef tibrvMsg M;ZC inbox[99];
ZI nt[]={0,4,0,0, 1, 2, 4, 8, 4, 8,0,0,0,0,0,12};ZV md(M m){tibrvMsg_Destroy(m);}
ZK qf(){K x;I t=f.type;R t==3?kz((j9*(f.data.date.sec-o)+f.data.date.nsec)/8.64e13):
 t==8?kp((S)f.data.str):t==9?kb(f.data.boolean):t<14||(t>25&&t<34)||t>45||t==22?(x=ka(101),xi=0,x):
 t<26?(x=ka(-tr(t)),xj=f.data.i64,x):(x=ktn(tr(t-20),f.count),memcpy(xG,f.data.array,xn*f.size),x);}
ZV fq(K x){ZS s;I a=xt<0,t=a?-xt:xt;J j;f.count=1,f.size=nt[t],f.type=rt[t];SW(xt){CS(-KB,f.data.boolean=xg)
 CS(-KZ,j=8.64e13*xf;f.data.date.sec=j/j9+o;f.data.date.nsec=j%j9)CS(-KS,f.size=strlen(f.data.str=xs)+1)
 CS(KC,if(s)free(s);f.data.str=s=(S)malloc(f.size=xn+1);memcpy(s,xG,xn);s[xn]=0)
 CD:if(a)f.data.i64=xj;else f.count=xn,f.type+=20,f.data.array=xG;}}
Z K qm(M m){S s;K x,y;I n;tibrvMsg_GetNumFields(m,&n),x=ktn(KS,n),y=ktn(0,n);
 DO(n,tibrvMsg_GetFieldByIndex(m,&f,i);s=(S)f.name;xS[i]=s?ss(s):0;kK(y)[i]=f.type==1?qm(f.data.msg):qf(f))
 R y=k(0,"k)::'",y,(K)0),xn&&*xS?xD(x,y):(r0(x),y);}
Z M mq(K x){S s;K y,z;I j;M m,t;tibrvMsg_Create(&m);if(y=xt==XD?*xK:0)x=xK[1];if(r1(x),j=0<xt)x=k(0,"k)*:'(::),(;0)'",x,(K)0);if(!xt)
 DO(xn-j,z=xK[i+j];s=y?kS(y)[i]:0;if(z->t==XD){tibrvMsg_AddMsg(m,s,t=mq(z));md(t);}else{f.name=s;fq(z);tibrvMsg_AddField(m,&f);})R r0(x),m;}
ZK snd(I i,S s,K x){M m=mq(x),r;tibrvMsg_SetSendSubject(m,s);P(i<0,(tibrvTransport_Send(-i,m),md(m),(K)0))
 R tibrvMsg_SetReplySubject(m,inbox),tibrvTransport_SendRequest(i,m,&r,-1),md(m),x=qm(r),md(r),x;}
ZV u(tibrvEvent e,M m,V*c){S s,r;K x;tibrvMsg_GetSendSubject(m,(const char**)&s),tibrvMsg_GetReplySubject(m,(const char**)&r);
 x=k(0,r?"rep":"upd",ks(ss(s)),qm(m),(K)0);if(xt==-128)O("error: %s\n",xs);if(r)snd(-(I)c,r,x);r0(x);}
#define Q(x) P((s=x),krr((S)tibrvStatus_GetText(s)))
ZK ch(K x,K y){R xt!=-KI||y->t!=-KS?krr("type"):y;}
K sub(K x,K y){tibrvEvent e;U(ch(x,y))Q(tibrvEvent_CreateListener(&e,TIBRV_DEFAULT_QUEUE,u,xi,y->s,(V*)xi))R r1(y);}
K req(K x,K y,K z){U(ch(x,y))R snd(xi,y->s,z);}
#ifdef WIN32 //pipe(I*p){R CreatePipe(p+0,p+1,0,0),O("%d\n",*p);}
ZV u0(tibrvQueue q,V*c){tibrvQueue_Dispatch(TIBRV_DEFAULT_QUEUE);}ZV u2(){}
#else
#include<unistd.h>
ZI p[2];ZC b;ZK u1(I i){read(i,&b,1),tibrvQueue_Dispatch(TIBRV_DEFAULT_QUEUE);R 0;}
ZV u0(tibrvQueue q,V*c){write(p[1],&b,1);}ZV u2(){pipe(p),sd1(p[0],u1);}
#endif // service/network/daemon
K con(K x){ZI i;I c;if(!i){Q(tibrv_Open())Q(tibrvQueue_SetHook(TIBRV_DEFAULT_QUEUE,u0,0))i=1,u2();}
 Q(tibrvTransport_Create(&c,*xS,xS[1],xS[2]))tibrvTransport_CreateInbox(c,inbox,99);R ki(c);}
K dis(K x){Q(tibrvTransport_Destroy(xi))R 0;}
