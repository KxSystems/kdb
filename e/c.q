/q c.q a host:port /sub[table;syms]  subscription
a:`T^`$.z.x 0

su:{update`u#sym from select by sym from x}
sg:{update`g#sym from x}

t:`trade;

if[a~`u;img.trade:{trade::su x};upd:upsert]
if[a~`U;img.trade:{trade::sg x};upd:upsert]

eu:{select sym,ex:size*"N"=ex,size from x}	/ then ex%size
if[a~`e;img.trade:{e::su eu x};upd.trade:{e+:eu x}]	

/vwap
vu:{select sym,price*size,size from x} 	/ then price%size
if[a~`v;img.trade:{v::su vu x};      upd.trade:{v+:vu x}]
if[a~`V;img.trade:{t::sg`sym`time`price`size#x};
 upd.trade:{r:t exec last i from t where sym=x`sym;
  t,:select sym,time,price:0.0^r[`price]+price*size,size:0^r[`size]+size from x}]
vwap:{[s;a;b]exec price%size from(-/)t asof([]sym:s;time:(b;a))}
/\t do[n;vwap[`IBM;11:00:00.0;12:00:00.0]]


/twap
if[a~`T;img.trade:{t::select`g#sym,time,price,wprice:price from x};
 upd.trade:{r:t exec last i from t where sym=x`sym;
  t,:select sym,time,price,wprice:0.0^r[`wprice]+r[`price]*time-r[`time]from x}]
twp:{[s;u]exec wprice+price*u-time from t(`sym`time#t)bin(s;u)}
twap:{[s;a;b](twp[s;b]-twp[s;a])%b-a}
/\t do[n;twap[`IBM;11:00:00.0;12:00:00.0]]

nu:{n,:exec last sym,last time,max bid,min ask from(quote,:x)where sym=x`sym}
ni:{[f;x]quote::sg select by sym,ex from x;n::f delete ex from x}
if[a~`n;t:`quote;img.quote:ni[su];upd.quote:nu]
if[a~`N;t:`quote;img.quote:ni[sg];upd.quote:nu]

if[a~`h;t:`trade;
 img.trade:{h::([sym:`u#0#`]high:0#0.;low:0#0.;close:0#0.)};
 upd.trade:{@[`h;x`sym;{[r;p]exec high|p,p^low&p,close:p from r};x`price]}]

if[a~`j;t:`quote`trade;
 img:t!(ni[su];{j::su x lj n});
 upd:t!(nu;{j,:x,n x`sym})]

/ test harness
\d .u
S:`$read0`:tick/sp500.txt
n:100000
w:{09:30:00.0+floor 23400000%x%til x}
trade:([]sym:`g#n?S;ex:n?"ASDN";time:w n;price:1+n?100.0;size:1+n?10)
quote:([]sym:`g#n?S;ex:n?"ASDN";time:w n;bid:1+n?100.0;ask:1+n?100.0)
sub:{(x;0#`.u x)}
\d .
et:{img . .u.sub x;(x;)each `.u x}
x:$[0<type t;raze flip et each t;et t]
\t (upd .)each x
\
/ size vwap between t and u with size>v
vv:{[s;a;v]u:`sym`time#t;
 j:(u bin(s;16:05:00.0))&1+(`sym`size#t)bin(s;t[i:u bin(s;a);`size]+v-1);
 (-/)t[j,i;`price`size]}
/vv[`IBM;11:00:00.0;100]

\
regnms
lava
·	Real time NBBO
·	Prevailing quote as of trade
·	Real time VWAP
·	Real time P&L (recalc/delta tradeoff at 100)
·	High, Low, Close, Running Volume
·	Real time pairs correlations 
·	Query all trades and quotes for a given asset

v+:select sym,price*size,size from x
select size wsum price,sum size from x where sym=s

size
* the last minute
* the last twenty minutes
* all day up until now
for each security.

