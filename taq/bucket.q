/ cached buckets
\l f:/taq

/ get fiveminbars data for date&sym: takes a few milliseconds per date&sym
g:{[d;s]select low:min price,open:first price,close:last price,high:max price,
  volume:sum size,vwap:size wavg price by 5 xbar time.minute from trade where date=d,sym=s} 
 
/ cache for every date/sym combination
c:([]date:"d"$();sym:"s"$())!()
 
/ check for cached otherwise cache and return
f:{[d;s]$[type r:c x:(d;s);r;c[x]:g[d;s]]}


d:2000.10.02
s:`GE
f[d;s]