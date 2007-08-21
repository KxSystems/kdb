QDBC  (don't use jdbc/odbc. qdbc is simpler and faster.)

e.g. http://www.eclipse.org/birt/phoenix/

load and query q servers with java and c# clients.
connect and execute.  (use q/c/c.jar or q/c/c.cs)

c c=new c("host",port);	 // connect
r=c.k("string");         // execute
r=c.k("func",x[,y[,z]]); // function calls
(also c.ks for asynch)

parameters(x,y,z) and results(r) are arbitrarily nested arrays.
(Integer, Double, int[], DateTime etc.)
to pass more than 3 args put them in list(s), e.g.
kdb+tick feedhandlers send one record at a time:

// (sym;price;size) record
Object[]x={"xx",new Double(93.5),new Integer(300)};
c.ks(".u.upd","trade",x);

or send many records at a time:

// (syms;prices;sizes) bulk
int n=100;Object[]x={new String[n],new double[n],new int[n]};
for(int i=0;i<n;i++){x[0][i]=..;..}
c.ks(".u.upd","trade",x);


clients can also read incoming messages: r=c.k();
for example, kdb+tick clients do:
String[]syms={"IBM","MSFT",..};
c.k(".u.sub","trade",syms);	// subscribe
while(1){Object r=c.k();..	// process incoming


q clients:
q)c:hopen`:host:port
q)c("string"[;x[;y[;z]]])

c clients are similar to java, c# and q clients. see http://kx.com/q/c/c
