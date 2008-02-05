/ can have -u; no end-of-day, no logfile, connect to master tickerplant
/ q chainedtick.k :5010 -p 5110 -t 1000 </dev/null >foo 2>&1 & 

/ q chainedtick.k [host]:port[:usr:pwd] [-p 5110] [-t N]

if[~."\\p";."\\p 5110"]

\l tick/u.k

if[."\\t"
 .z.ts:{.u.t .u.pub'.:'.u.t;@[`.;.u.t;@[;`sym;`g#]0#];}
 upd:{[t;x] t insert x;}]

if[~."\\t"  
 upd:{[t;x] .u.pub[t;x];}]

/ get the ticker plant port, default is 5010
.u.x:.z.x,(#.z.x)_,":5010"

/ init schema 
.u.rep:{(.[;();:;].)'x;}

/ connect to ticker plant for schema
.u.init .u.rep(.u.m:<`$":",.u.x 0)".u.sub[`;`]"
