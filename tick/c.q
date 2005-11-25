/todo: recovery .u.rep
/ q tick/c.q {all|..} [host]:port[:usr:pwd]
/ realtime alerts and continuous queries

x:.z.x,count[.z.x]_("last";":5010")
h:hopen`$":",x 1;x@:0

t:`;s:`MSFT.O`IBM.N

/ all
if[x~"all";upd:insert]

/ last
if[x~"last";upd:{[t;x].[t;();,;r::select by sym from x]}]

/ last every 5 minute
if[x~"last5";upd:{[t;x].[t;();,;select by sym,5 xbar time.minute from x]}]

/ all trades with then current quote
if[x~"tq";
 upd:{[t;x]$[t~`trade;tq,:x lj .u.q;.u.q,:select by sym from x]}]

/ vwap for each sym
if[x~"vwap";t:`trade;
 upd:{[t;x]vwap+:select size wsum price,sum size by sym from x}]

/ vwap every minute
if[x~"vwap1";t:`trade;
 upd:{[t;x]vwap+:select size wsum price,sum size by sym,time.minute from x}]

/ moving vwaps(momentum etc.)  use nested structures
ind:{[t;i](key t)!flip(flip value t)@'\:i}
if[x~"move";t:`trade;
 upd:{[t;x].[`.u.t;();,'';select time,size*price,size by sym from x];
  move::((last each) each t)-ind[t:delete time from .u.t;exec time bin'-60000+"t"$.z.z from .u.t]}]

/ high low close volume
if[x~"hlcv";t:`trade;hlcv:([sym:()]high:();low:();price:();size:());
 upd:{[t;x]hlcv::select max high,min low,last price,sum size by sym 
    from(0!hlcv),select sym,high:price,low:price,price,size from x}]

/ lvl2 book for each sym
if[x~"lvl2";t:`quote;s:`;
 lvl2:()!();upd:{[t;x]{lvl2[x`sym]^:`mm xkey enlist x _`sym}each x}]
  
/ nest all data (for arbitrary trend analysis)
if[x~"nest";t:`trade;k:enlist`sym;
 upd:{[t;x]$[type key t;@[t;k#x;,';k _ x];.[t;();:;k xgroup x]]}]

/ vwap last 10 ticks
if[x~"vwap2";t:`trade;f:{[p;s](-10#s)wavg -10#p};
 upd:{[t;x].[`.u.t;();,'';select price,size by sym from x];
  vwap::`sym xkey select sym,vwap:f'[price;size]from .u.t}]

/ vwap last minute (60000 milliseconds)
if[x~"vwap3";t:`trade;f:{[t;p;s](n#s)wavg(n:(1+t bin("t"$.z.Z)-60000)-count t)#p};
 upd:{[t;x].[`.u.t;();,'';select time,price,size by sym from x];
  vwap::`sym xkey select sym,vwap:f'[time;price;size]from .u.t}]

/ subscribe and initialize
$[`~t;(upd .)each;(upd .)]h(".u.sub";t;s);

.u.end:{@[`.;tables`.;0#];}
\
the way to maintain exchange share(and have instantaneous queries) is
to have a client that does:

t:([sym;exch]size)

t,:select sum size by sym,exch from x

then

share:update share:size%sum size by exch from t

select sym,size wsum each ex=exch from trade   / symnest
select sum size by sym from trade where ex=exch / flat
