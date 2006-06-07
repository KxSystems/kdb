#include "bbapi.h"   // cl /LD ..\c\bb.c bb.def q.lib bbapi.lib 
#include "../c/k.h"  // gcc -shared -DBB_PLATFORM_LINUX_INTEL ../c/bb.c -o bb.so -lbbapi
Z bb_connect_t*c;ZS tba[]={0,"trade","bid","ask"};
ZI qn(I n){R n==BB_VAL_MISSING?ni:n;}
ZV R0(K x){if(x)r0(x);}

ZV mon(bb_msg_monid_t*b){R0(k(0,"mon",ki(b->comm_header.request_id-1),ki(*b->mon_id),0));}
ZV stt(bb_msg_status_t*b){R0(k(0,"stt",ki(b->comm_header.return_code),0));}//984 alive
ZV upd(bb_msg_tick_t*b){K x;I t,m;bb_decode_tick_t*d=b->tick_data;
 DO(b->comm_header.num_items,t=d[i].type;m=d[i].mon_id;
  if(t<4)R0(k(0,"upd",ks(ss(tba[t])),knk(3,ki(m),kf(d[i].data.BID.price),ki(qn(d[i].data.BID.size))),0)))}

ZK d0(I d){C b[9999];I n;for(;n=bb_sizeof_nextmsg(c);)SW(bb_rcvdata(c,b,n)){
 CS(BB_SVC_TICKMONITOR,mon((bb_msg_monid_t*)b))
 CS(BB_SVC_TICKDATA,   upd((bb_msg_tick_t*)b)) 
 CS(BB_SVC_STATUS,     stt((bb_msg_status_t*)b))}R 0;}

ZK init(){R c?c:(c=bb_connect(8194))?sd1(bb_getsocket(c),d0):0;}
K1(sub){R!init()?krr("init"):xt!=-KS?krr("type"):ki(bb_tickmntr(c,1,xs)-1);} // could do 10*36bytes
