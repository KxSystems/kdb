QDBC  (don't use jdbc/odbc. qdbc is simpler and faster.)

load and query q servers with java and c# clients.
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

q clients:
q)c:hopen`:host:port
q)c("string"[;x[;y[;z]]])

c clients are similar to java and c# clients. see http://kx.com/q/c/c

BULK INSERT
Object[]x={new string[n],new double[n],new int[n]};
for(int i=0;i<n;i++){x[0][i]=..;..}

clients can also read incoming messages: r=c.k();
for example, kdb+tick clients do:
String[]syms={"IBM","MSFT",..};
c.k(".u.sub","trade",syms);	// subscribe
while(1){Object r=c.k();..	// process incoming
