/ feed/tick/rdb solo(20k) time(50k) bulk(2million) 
/q tick.k sym .
/q tick/r.k

h:hopen 5010
/ sync all subscribers
s:{h"distinct[first flip raze .u.w]@\\:()"}

sym:-10?`3
/ 1000 trades and quotes
t:100?'(sym;1.0;10)
q:900?'(sym;1.0;1.0;10;10)

p:{neg[h](`.u.upd;x;y)} /push bulk
P:{p[x]each flip y}     /push solo

\t do[1000;p[`quote;q];p[`trade;t]];s[] /bulk
\t do[  10;P[`quote;q];P[`trade;t]];s[] /solo
