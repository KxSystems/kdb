/ can have -u, no client end-of-day
/ q chainedtick.k :5010 -p 5110 </dev/null >foo 2>&1 & 

/ 2008.02.02 first

/q chainedtick.k MASTER [-p 5110]

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
.u.init .u.rep (<`$":",.u.x 0)".u.sub[`;`]"

\
/test
>q tick.k
>q tick/ssl.q
>q chainedtick.k 

/run
>q tick.k sym  .   -p 5010       /tick
>q tick/r.k :5010 -p 5011       /rdb
>q sym             -p 5012       /hdb
>q tick/ssl.q sym :5010          /feed
>q chainedtick.k :5010 -p 5110     /chained tick 
