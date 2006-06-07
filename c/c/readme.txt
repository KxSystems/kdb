there are 3 cases:

1. c dynamic load called by q, e.g. analytics
2. c dynamic load callbacks into q, e.g. feedhandlers
3. c clients talking to q servers. e.g. feedhandlers and clients(link with c.o)

q data are simple c structs.  see http://kx.com/q/c/c/k.h
requires gcc 3.0 or later for anonymous unions and structs.

K r(ref) t(type) atom(ghijefs) list(u(supg) n(count) G(data)) flip(+k) dict(kK(x)[0]!kK(x)[1])
B(bool8) G(byte8) H(short16) I(int32) J(long64) E(real32) F(float64) C(char8) S(symbol32) D(date32) T(time32) Z(datetime64)

type: KB KG KH KI KJ KE KF KC KS KD KT KZ 0(nested list)
atom: kb(I) kg(I) kh(I) ki(I) kj(J) ke(F) kf(F) kc(I) ks(S) kc(I) kt(I) kz(I)  
list: x=ktn(type,length);x=knk(n,x,y,z);  e.g. x=knk(2,kf(2.3),ktn(KI,10));
also: K kp(string);K kpn(string,length);S ss(string); //intern string

base types are: GHIJEFS (G handles BC) (I handles DT) (F handles Z)
atom access: x->g  x->h  x->i  x->j  x->e  x->f  x->s
list access: kG(x) kH(x) kI(x) kJ(x) kE(x) kF(x) kS(x) kK(x)
list append: ja(K*,V*); js(K*,S); jk(K*,K);  join atom/string/k e.g. K r=ktn(KI,0);int i=2;ja(&r,&i);

datetime conversion:
u(unixtime) is seconds since 1970.01.01T00:00:00
z(datetime) is 64bit float days since 2000.01.01
double zu(int u){return u/8.64e4-10957;}   // kdb+ from unix
int uz(double z){return 86400*(z+10957);}  // unix from kdb+

examples:
K r=ktn(KI,5);  //integer list of 5
K r=knk(2,kf(2.3),ktn(KC,3)); // nested list
K r=kp("asdf"); // char list
S s=ss("asdf"); // internedstring from string

dict=xD(K,K); e.g. x=ktn(KS,2);kS(x)[0]=ss("a");kS(x)[1]=ss("b");y=ktn(KI,2);kI(y)[0]=2;kI(y)[1]=3;r=xD(x,y);
table=xT(K);  // table from dictionary
table=ktd(K); // simple table from keyed-table.

r1(x) increment ref count
r0(x) decrement ref count
I ymd(year,month,day) e.g. 0==ymd(2000,1,1)

SERVER (link c code with q.lib)
servers, e.g. http://kx.com/q/c/a.c

1. dynamic load, e.g. q/c/a.c K f(K x,K y){return ki(x->i+y->i);}
2. callbacks,  e.g. q/c/ssl.c
 sd1(d,f); // put V f(I d){..} on q mainloop given socket d
 sd0(d);   // remove it
 krr(S); signal error

CLIENT (link l32/c.o s32/c.o w32/c.dll(c.lib))
e.g. http://kx.com/q/c/c/c.c (requires gcc 3.0 or later)
 int c=khp("host",port); // connect
 k(-c,"func|exp",..,(K)0); //asynch
 r=k(c,"func|exp",..,(K)0); //synch
 r=k(c,(K)0); // read incoming asynch
e.g. tickerplant c client does:

K x;
 r0(k(c,".u.sub",ks("table"),ks(""),(K)0));
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

