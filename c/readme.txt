QDBC

easy way to load and query q servers with java and c# clients.
connect and execute.  (use q/c/c.java or q/c/c.cs)

c c=new c("host",port);	// connect
r=c.k("string"); // execute
r=c.k("func",x); // function calls
r=c.k("func",x,y);
r=c.k("func",x,y,z);

parameters(x,y,z) and results(r) are arbitrarily nested arrays.
(Integer, Double, int[], DateTime etc.)
to pass more than 3 args put them in list(s), e.g.

// build (time;sym;price;size) record
Object[]x={new Time(System.currentTimeMillis()%86400000),"xx",new Double(93.5),new Integer(300)};
c.k("insert","trade",x);	// insert[`trade;x]

BULK INSERT
Object[]x={new string[n],new double[n],new int[n]};
for(int i=0;i<n;i++){x[0][i]=..;..}

clients can also read incoming messages: r=c.k();
for example, kdb+tick clients do:
String[]syms={"IBM","MSFT",..};
c.k(".u.sub","trade",syms);	// subscribe
while(1){Object r=c.k();..	// process incoming

JDBC http://kx.com/q/c/jdbc.jar
ODBC http://kx.com/q/c/odbc.exe (kdb+2.3 and later)

vb r=new adodb.recordset;r.Open "q)t", "DRIVER=kdb+;DBQ=localhost:5001"
excel SQL.REQUEST("DRIVER=kdb+;DBQ=localhost:5001;",,,"q)t")

jdbc and odbc are deprecated. qdbc is 
simpler: 1 entry point instead of 1000
faster: qdbc is 10 times as fast
better: arbitrary args,  e.g.  k("{[x]select from t where sym in x}",sp500)

matlab:     http://www.skelton.de/slog/?p=25
excelrtd:   http://www.skelton.de/slog/?p=2
q clients:
q)c:hopen`:host:port
q)c("string"[;x[;y[;z]]])


c clients are similar to java and c# clients.

c/c++: (l32/c.o s32/c.o w32/c.dll(c.lib))
int c=khp("host",port);
r=k(c[,"string"[,x[,y[,z]]]],(K)0);


C clients, e.g.  http://kx.com/q/c/c.c (requires gcc 3.0 or later)

must call khp before generating k data.
link with l32/c.o, s32/c.o or w32/c.dll(c.lib)
send asynch messages with: k(-c,..)
read asynch messages with: r=k(c,(K)0);

int c=khp("host",port);
K x=knk(4,kt(1000*(time(0)%86400)),ks("xx"),kf(93.5),ki(300)); // time,sym,price,size
k(-c,"insert",ks("trade"),x,(K)0);

we use the K struct to hold data:

 K is atom(-19..-1) list(0 1..19) flip(98) dict(99)

atoms are type(t),value(ghijefs)      x->g     x->h     x->i     etc.
lists are type(t),count(n),values(G)  kG(x)[i] kH(x)[i] kI(x)[i] etc.

bool,char:	x->g	kG(x)[i]
datetime:	x->f	kF(x)[i]
other time:	x->i	kI(x)[i]

 r(ref) t(type) atom(ghijefs) list(u(supg) n(count) G(data)) flip(+k) dict(kK(x)[0]!kK(x)[1])
 atom(kb,kg,..kt) list(ktn(t,n) knk(1-7,..) kp(S) kpn(S,I))  xT(xD(keys,values)) T:ktd(D|T)

 time(t) is milliseconds. datetime(d/z) is days from 2000.01.01 e.g. 
 I x=time(0),t=1000*(x%86400),d;F z=x/8.64e4-10957;d=(I)z;

 r1(inc) r0(dec)
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

servers, e.g. http://kx.com/q/c/a.c

c shared objects (link with q.lib) can be dynamically loaded 
into q servers (q can call c and c can call q:  r=k(0,..))

 krr(return error) 
 sockets: sd1(d,callback) sd0(close)   

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
..=ktn(kS,0);..

while(..){ja(a,&sym);ja(b,&price);ja(c,&size);}
