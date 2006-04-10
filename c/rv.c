//2006.03.15  req[c;subject;dict]
//w32>cl /LD rv.def ..\c\rv.c q.lib ws2_32.lib tibrv.lib
//l32>gcc -shared ../c/rv.c -o rv.so -I/dat/tibrv/linux/7.2/include -L/dat/tibrv/linux/7.2/lib -ltibrv 
//l64>gcc -shared ../c/rv.c -o rv.so -I/dat/tibrv/linux/7.3/include -L/dat/tibrv/linux/7.3/lib -ltibrv64 -fPIC 
//s32>gcc -G ../c/rv.c -o rv.so -ltibrv
#include"k.h"
#include"tibrv/tibrv.h"  //missing KC KM KD KU KV KT  3,8,9 14..25  (22-none) 1msg 7opaque 26port 27addr 32encr 47xml
#define Q(x) P(s=x,krr((S)tibrvStatus_GetText(s)))
ZI tr(I t){R t==24?8:t/2-3;}
ZI rt[]={0,9,0,0,14,16,18,20,24,25,8,8,0,0,0, 3};Z tibrvMsgField f;Z tibrv_status s;ZJ j9=(J)1e9;
ZI nt[]={0,4,0,0, 1, 2, 4, 8, 4, 8,0,0,0,0,0,12};ZS sr(S s){C b[4];R ss(s&&*s?s:(sprintf(b,"%d",f.id),b));}

ZK qf(){K x;I t=f.type;R t==3?kz((j9*f.data.date.sec+f.data.date.nsec)/8.64e13-10957):
 t==8?kp((S)f.data.str):t==9?kb(f.data.boolean):t<14||t>25&&t<34||t>45||t==22?ktn(0,0):
 t<26?(x=ka(-tr(t)),xj=f.data.i64,x):(x=ktn(tr(t-20),f.count),memcpy(xG,f.data.array,xn*f.size),x);}
ZK qm(tibrvMsg m){K x,y;I n;tibrvMsg_GetNumFields(m,&n),x=ktn(KS,n),y=ktn(0,n);
 DO(n,tibrvMsg_GetFieldByIndex(m,&f,i);xS[i]=sr((S)f.name);kK(y)[i]=f.type==1?qm(f.data.msg):qf())R xD(x,y);}
ZI fq(K x){ZS s;I a=xt<0,t=a?-xt:xt;J j;U(t<=KZ)f.count=1,f.type=rt[t],f.size=nt[t];SW(xt){
 CS(KC,if(s)free(s);memcpy(f.data.str=s=(S)malloc(f.size=xn+1),xG,xn);s[xn]=0)CS(-KB,f.data.boolean=xg)
 CS(-KS,f.size=strlen(f.data.str=xs)+1)CS(-KZ,j=.5+8.64e13*(10957+xf);f.data.date.sec=j/j9;f.data.date.nsec=j%j9)
 CD:if(a)f.data.i64=xj;else f.count=xn,f.type+=20,f.data.array=xG;}R t;}
Z tibrvMsg mq(K x){K y=xK[1],z;tibrvMsg m,s;tibrvMsg_Create(&m),x=*xK;DO(xn,z=kK(y)[i];if(z->t==XD){
 tibrvMsg_AddMsg(m,xS[i],s=mq(z));tibrvMsg_Destroy(s);}else{f.name=xS[i];P(!fq(z),0)tibrvMsg_AddField(m,&f);})R m;}

ZV u(tibrvEvent e,tibrvMsg m,V*c){S s;tibrvMsg_GetSendSubject(m,(const char**)&s),r0(k(0,"upd",ks(ss(s)),qm(m),(K)0));}
K sub(K x,K y){tibrvEvent e;P(y->t!=-KS,krr("type"))Q(tibrvEvent_CreateListener(&e,TIBRV_DEFAULT_QUEUE,u,xi,y->s,NULL))R r1(y);}
K req(K x,K y,K z){tibrvMsg m,r;P(y->t!=-KS||z->t!=XD||kK(z)[1]->t||!(m=mq(z)),krr("type"))tibrvMsg_SetSendSubject(m,y->s);
 Q(xi<0?tibrvTransport_Send(-xi,m):tibrvTransport_SendRequest(xi,m,&r,-1))tibrvMsg_Destroy(m);P(xi<0,r1(y))R y=qm(r),tibrvMsg_Destroy(r),y;}
K pub(K x,K y,K z){R y=req(x=ki(-xi),y,z),r0(x),y;}
#ifdef WIN32 //pipe(I*p){R CreatePipe(p+0,p+1,0,0),O("%d\n",*p);}
ZV u0(tibrvQueue q,V*c){tibrvQueue_Dispatch(TIBRV_DEFAULT_QUEUE);}ZV u2(){}
#else
#include<unistd.h>
ZI p[2];ZC b;ZK u1(I i){R read(i,&b,1),tibrvQueue_Dispatch(TIBRV_DEFAULT_QUEUE),ktn(0,0);}
ZV u0(tibrvQueue q,V*c){write(p[1],&b,1);}ZV u2(){pipe(p),sd1(p[0],u1);}
#endif
// service/network/daemon
K con(K x){Z i;I c;if(!i){Q(tibrv_Open())Q(tibrvQueue_SetHook(TIBRV_DEFAULT_QUEUE,u0,0))i=1,u2();}
 Q(tibrvTransport_Create(&c,*xS,xS[1],xS[2]))R ki(c);}
K dis(K x){Q(tibrvTransport_Destroy(xi))R ktn(0,0);}
//  tibrvEvent_Destroy(response_id);
