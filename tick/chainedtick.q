/ can have -u; no end-of-day, no logfile, connect to master tickerplant
/ q chainedtick.q :5010 -p 5110 -t 1000 </dev/null >foo 2>&1 & 

/ q chainedtick.q [host]:port[:usr:pwd] [-p 5110] [-t N]

if[not system"p";system"p 5110"]

\l tick/u.q

if[system"t";
	 .z.ts:{.u.pub'[.u.t;value each .u.t];@[`.;.u.t;@[;`sym;`g#]0#]}; 
	  upd:{[t;x] t insert x;}]

if[not system"t";  
	   upd:{[t;x] .u.pub[t;x];}]

/ get the ticker plant port, default is 5010
.u.x:.z.x,(count .z.x)_enlist":5010"

/ init schema 
.u.rep:{(.[;();:;].)each x;}

/ connect to ticker plant for schema
.u.init .u.rep(.u.m:hopen`$":",.u.x 0)".u.sub[`;`]"

\
/test
>q tick.k
>q tick/ssl.q
>q chainedtick.k 

/run
>q tick.k sym  .   -p 5010       /tick
>q tick/r.k ::5010 -p 5011       /rdb
>q sym             -p 5012       /hdb
>q tick/ssl.q sym :5010          /feed
>q chainedtick.k   -p 5110     /chained tick 
