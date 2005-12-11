/q c.q a host:port /sub[table;syms]  subscription
a:`$.z.x 0
sg:{update`g#sym from x}
su:{update`u#sym from select by sym from x}

t:`trade;
if[a~`u;img:{trade::su y};upd:upsert]
if[a~`U;img:{trade::sg y};upd:upsert]

ex:{select sym,size,ex:size*"N"=ex from x}   / nyse share
vx:{select sym,size,price:size*price from x} / vwap
if[a~`e;img:{e::su ex y};upd:{e+:ex y}]	/ select ex%size
if[a~`v;img:{v::su vx y};upd:{v+:vx y}]	/ select price%size			
if[a~`V;img:{v::su vx trade::sg y};upd:{trade,:y,(v+:vx y)y`sym}]

nx:{nbbo,:y,exec max bid,min ask from(quote,:y)where sym=y`sym} / nbbo
if[a~`n;t:`quote;img:{quote::sg select by sym,ex from y;nbbo::su y};upd:nx]
if[a~`N;t:`quote;img:{quote::sg select by sym,ex from y;nbbo::sg y};upd:nx]

/ test harness
\d .u
S:`$read0`:tick/sp500.txt
n:100000;w:{09:30:00.0+floor 23400000%x%til x}
trade:([]time:w n;sym:`g#n?S;ex:n?"ASDN";size:n?10;price:n?100.0)
quote:([]time:w n;sym:`g#n?S;ex:n?"ASDN";bid:n?100.0;ask:n?100.0)
quote:`sym`ex`time`bid`ask#quote
sub:{[t;s](t;0#`.u t)}
\d .
h:0;s:`
img . h(`.u.sub;t;s);
\t upd[t]each`.u t
\
regnms?
lava?

n:100000
vwap:{[s;a;b](%/)(-/)trade asof([]sym:s;time:(b;a))};
\t do[n;vwap[`IBM;11:00:00.0;12:00:00.0]]

 upd:{[t;x]trade,:x:pj[update sums size*price,sums size by sym from x]v;v,:delete time from x}]

 
/s:.u.S;n:count`.u t;j:floor n%m:1000
/init[t;s;c];i:0
/\t do[j;upd[t;`.u[t]i+til m];i+:m]	/ 1000 at a time