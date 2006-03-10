/q c.q a host:port /sub[table;syms]  subscription
a:`$.z.x 0
su:{update`u#sym from select by sym from x}
sg:{update`g#sym from x}

t:`trade;
if[a~`u;img:{trade::su y};upd:upsert]
if[a~`U;img:{trade::sg y};upd:upsert]

eu:{select sym,size,ex:size*"N"=ex from x}   / nyse share
vu:{select sym,size,price:size*price from x} / vwap
if[a~`e;img:{e::su eu y};upd:{e+:eu y}]	/ select ex%size
if[a~`v;img:{v::su vu y};upd:{v+:vu y}]	/ select price%size			
if[a~`V;img:{v::su vu trade::sg y};upd:{v+:vu y;trade,:y,v y`sym}]

nu:{nbbo,:exec last sym,last time,max bid,min ask from(quote,:y)where sym=y`sym}
ni:{[f;t;x]quote::sg select by sym,ex from x;nbbo::f delete ex from x}
if[a~`n;t:`quote;img:ni[su];upd:nu]
if[a~`N;t:`quote;img:ni[sg];upd:nu]

if[a~`h;t:`trade;img:{y;hlc::([sym:`u#0#`]high:0#0.;low:0#0.;close:0#0.)};
 upd:{@[`hlc;y`sym;{[r;p]exec high|p,p^low&p,close:p from r};y`price]}]

if[a~`j;t:`quote`trade;
 img:`quote`trade!(ni[su;`];{trade::su x lj nbbo});
 upd:`quote`trade!(nu[`];{trade,:x lj delete time from nbbo})]

/ test harness
\d .u
S:`$read0`:tick/sp500.txt
n:100000;
w:{09:30:00.0+floor 23400000%x%til x}
trade:([]time:w n;sym:`g#n?S;ex:n?"ASDN";size:n?10;price:n?100.0)
quote:([]time:w n;sym:`g#n?S;ex:n?"ASDN";bid:n?100.0;ask:n?100.0)
quote:`sym`ex`time`bid`ask#quote
sub:{[t;s](t;0#`.u t)}
\d .
h:0;s:`
tt:{img . h(`.u.sub;x;s);x};et:{(x;)each`.u x}
k)x:$[0>@t;et tt t;,/+et'tt't]
\t (upd .)each x

\
regnms?
lava?
n:100000
vwap:{[s;a;b](%/)(-/)trade asof([]sym:s;time:(b;a))};
\t do[n;vwap[`IBM;11:00:00.0;12:00:00.0]]

 upd:{[t;x]trade,:x:pj[update sums size*price,sums size by sym from x]v;v,:delete time from x}]

 
s:.u.S;n:count`.u t;j:floor n%m:1000
init[t;s;c];i:0
\t do[j;upd[t;`.u[t]i+til m];i+:m]	/ 1000 at a time


·	Real time NBBO
·	Prevailing quote as of trade
·	Real time VWAP
·	Real time P&L (recalc/delta tradeoff at 100)
·	High, Low, Close, Running Volume
·	Real time pairs correlations 
·	Query all trades and quotes for a given asset
