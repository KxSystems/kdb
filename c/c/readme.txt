there are 3 cases:

1. c dynamic load called by q, e.g. analytics
2. c dynamic load callbacks into q, e.g. feedhandlers
3. c clients talking to q servers. e.g. feedhandlers and clients(link with c.o)

/c/c/k.h
q data are c structs: {I r;H t,u;..}
r - ref count
t - type (atom<0;list>=0;flip==98;dict==99)
u - `s`u`p`g flag

type: KB   KG   KH    KI  KJ   KE   KF    KC   KS     KD   KT   KZ
      bool byte short int long real float char symbol date time datetime

list has x->n (also xn) for count.

generate  
atom(xt< 0): kb(I) kg(I) kh(I) ki(I) kj(J) ke(F) kf(F) kc(I) ks(S) kd(I) kt(I) kz(F)  
list(xt>=0): ktn(xt,xn) also K knk(n,...),kp(S),kpn(S,I);
dict(XD): xD(KS,KK)
flip(XT): xT(XD)
S ss(S),sn(S,I); //intern string as symbol

type: KBGHIJEFSCDTZ
base: KGGHIJEFSCIIF
size: *1124848*1448

access
atom: x->g  x->h  x->i  x->j  x->e  x->f  x->s        (also xg xh xi xj xe xf xs)
list: kG(x) kH(x) kI(x) kJ(x) kE(x) kF(x) kS(x) kK(x) (also xG xH xI xJ xE xF xS xK)
dict: kK(x)[0]!kK(x)[1] (also xx!xy)
flip: x->k              (also xk)

datetime conversion
v(unixtime) is seconds since 1970.01.01T00:00:00
z(datetime) is 64bit float days since 2000.01.01
I o=10957*86400;
I tz(F z){R .5+86400*z+o;}  // unix from kdb+
F zt(I t){R (t-o)/8.64e4;}  // kdb+ from unix time(0)
F zu(timeval u){R(1e6*(u.tv_sec-o)+u.tv_usec)/8.64e10;} //gettimeofday

examples:
K r=ktn(KI,5);  //integer list of 5
K r=knk(2,kf(2.3),ktn(KC,3)); // nested list
K r=kp("asdf"); // char list
S s=ss("asdf"); // interned sym from string

dict=xD(K,K); e.g. x=ktn(KS,2);kS(x)[0]=ss("a");kS(x)[1]=ss("b");y=ktn(KI,2);kI(y)[0]=2;kI(y)[1]=3;r=xD(x,y);
flip=xT(K);  // table from dictionary
flip=ktd(K); // simple table from keyed-table.

r1(x) increment ref count
r0(x) decrement ref count
I ymd(year,month,day) e.g. 0==ymd(2000,1,1)

SERVER (link c code with q.lib)
servers, e.g. /c/a.c

1. dynamic load, e.g. /c/c/a.c K f(K x,K y){return ki(x->i+y->i);}
2. callbacks,    e.g. /c/feed/ssl.c
 sd1(d,f); // put K f(I d){..} on q mainloop given socket d (-d for nonblock)
 sd0(d);   // remove it
 krr(S);   // k   error, e.g. if(xt!=KI)return krr("type");
 orr(S);   // o/s error, e.g. if(-1==..)return orr("file");

CLIENT (link l32/c.o s32/c.o w32/c.dll(c.lib))
e.g. /c/c/c.c (requires gcc 3.0 or later)
 int c=khp("host",port); // connect
 k(-c,"func|exp",..,(K)0); //asynch
 r=k(c,"func|exp",..,(K)0); //synch
 r=k(c,(S)0); // read incoming asynch
e.g. tickerplant c client does:

K x;
 k(-c,".u.sub",ks("table"),ks(""),(K)0);
 for(;x=k(c,(K)0);r0(x))process(x);

must call khp before generating k data.
args(up to 8) are decremented. must eventually do r0(r).
for more args use lists.
 
e.g.
K x=knk(4,kt(1000*(time(0)%86400)),ks("xx"),kf(93.5),ki(300)); // time,sym,price,size
k(-c,"insert",ks("trade"),x,(K)0);

r=k(c,s,x,y,z,(K)0); decrements(r0) x,y,z. eventually program must do r0(r);
if one of the parameters is reused you must increment, e.g.

K x=ks("trade");
k(-c,s,r1(x),..,(K)0);
k(-c,s,r1(x),..,(K)0);
 ..
r0(x);
 
r=k(c,..) error is r->t==-128 and r->s is the error string
k(-c,..) just returns non-zero on success.
if k(..) returns 0 the connection is broken(user closesocket)

BULK INSERTS FROM C
at some point the records need to be assigned to different tables(types).
for one table(easiest case):

either grow (using ja) or set(better) if you know how many messages.
(remember the data is all by column)
suppose n columns and m rows then:

send all available data at once.(bulk)
if you know there are m records and n columns:

x=ktn(0,n); // n columns

e.g. (sym;price;size)

a=kK(x)[0]=ktn(KS,m); // symbol vector
b=kK(x)[1]=ktn(KF,m); // float(64bit) vector
c=kK(x)[2]=ktn(KI,m); // integer vector

for(i=0;i<m;++i){ // populate all the cells
 kS(a)[i]=..; // set row i of column a
 kF(b)[i]=..; // set row i of column b
 ..}

k(c,".u.upd",ks("trade"),x,(K)0); // insert
 
GROW
a=ktn(KS,0);b=ktn(KF,0);c=ktn(KI,0);

while(..){ja(&a,&sym);ja(&b,&price);ja(&c,&size);}

ja(K*,V*); js(K*,S); jk(K*,K);  join atom/string/k e.g. K r=ktn(KI,0);int i=2;ja(&r,&i);


other:
K r=dot(K x,K y); // does not decrement
