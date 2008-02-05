/ no dayend except 0#, can connect to tick.k or chainedtick.k tickerplant
/ q chainedr.k :5110 -p 5111 </dev/null >foo 2>&1 & 

/ q tick/chainedr.k [host]:port[:usr:pwd] [-p 5111] 

if[~"w"=*$.z.o;."\\sleep 1"]

if[~."\\p";."\\p 5111"]

upd:insert

/ get the chained ticker plant port, default is 5110
.u.x:.z.x,(#.z.x)_,":5110"

/ end of day: clear ONLY
.u.end:{@[`.;.q.tables`.;@[;`sym;`g#]0#];}

/ init schema and sync up from log file
.u.rep:{(.[;();:;].)'x;if[^*y;:()];-11!y;}

/ connect to tickerplant or chained ticker plant for (schema;(logcount;log))
.u.rep .(<`$":",.u.x 0)"(.u.sub[`;`];$[`m in key`.u;(`.u `m)\"`.u `i`L\";`.u `i`L])"
