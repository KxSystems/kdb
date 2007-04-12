.Q.view 2#distinct date

d:first D:2#distinct date
s:first S:`A`AA

/
/select distinct date by sym from trade
/select distinct date by sym from ungroup select distinct sym by date from trade
t:select from trade where date=d
r:([]second:10:00:00+til 3600) /rack
f:{[t;c;s]?[t;enlist(=;`sym;enlist s);(enlist`second)!enlist`time.second;(enlist c)!enlist(last;c)]}
\t a:fills r#f[t;`price;`IBM]
\

select avg size from trade
select avg size by date from trade
select avg size by ex from trade

/ join trades with prevailing nyse quotes
t:select time,price,size from trade where date=d,sym=s
q:select time,bid,bsize,ask,asize from quote where date=d,sym=s,ex="N"
aj[`time;t;q]

/ what fraction trades>nysequote midpoint? (single sym)
select avg price>.5*bid+ask from aj[`time;
 select time,price from trade where date=d,sym=s,time>09:35;
 select time,bid,ask from quote where date=d,sym=s,ex="N"]

/ trade execution: what fraction within the prevailing nysequote? (multisym)
select avg price within(bid;ask) from aj[`sym`time;
 select sym,time,price,size from trade where date=d,sym in S,time>09:35;
 select `p#sym,time,bid,ask from quote where date=d,sym in S,ex="N"]

/select trades where price>avg price[by sym]
t:select from trade where date=d
\t select from(update a:avg price by sym from t)where price>a
\t select from t where price>(avg;price)fby sym

/ select primary exchange trades only
es:exec last ex by sym from mas where date<=d
count select from trade where date=d,ex=es sym

/ aggregate and select by baskets
bs:`AA`IBM`A`MSFT`INTC!`a`b`b`b`a	/ basket from sym
sb:group bs	/ syms from basket
select avg price by bs sym from trade where sym in sb`b

/ rollup and interleave 5 minute intervals. size fraction within nysequote
t0:09:30;t1:10:00
q:select last bid,last ask by sym,5 xbar time.minute from quote where date=d,sym in S,time>=t0,time<t1,ex="N"
t:select size,price        by sym,5 xbar time.minute from trade where date=d,sym in S,time>=t0,time<t1

select r:size wavg'price within(bid;ask)from t,'update prev bid,prev ask from q

select count distinct sym from trade
select count distinct sym by date from trade
select count distinct sym by ex from trade

/\l taq/adj.q
/\t d:select high:max price,low:min price,last price,sum size by ms sym from trade where sym in sm S

/ trade rollup and fill into one minute bars
tbar:{[d;S]a:09:30;b:16:15;     b:09:33;  / small example
 r:select size wavg price,sum size by sym,time.minute from trade where date=d,sym in S,time>=a,time<b;
 update fills price,0^size by sym from(([]sym:S)cross([]minute:a+til b-a))#r}

/tbar[d;S]

/ what is the trailing vwap encompassing 4 times the volume of the current
f4:{[size;price]
 s:sums size;p:sums size*price;	/ running totals
 i:1+s bin -1+s+3*size;	/ indices of total>=4*current size
 (p[i]- -1_0.0,p)%s[i]- -1_0,s}	/ vwap
  
select vwap4:f4[size;price] from trade where date=d,sym=s

/
/ select trades with certain condition codes
ce:"NT"!(" ZTE89";" ZT") / N(nyse) T(nasdaq)
\t count select from trade where date=d,cond in'ce ex
\

n:100
\t select count i by date from trade
\t select count distinct sym by date from trade
\t do[n;select count i from trade]
\t do[n;select last price,sum size by sym from trade where sym in S]
\t do[n;select last price,sum size by date from trade where sym=s]
\t do[n;select last price by date,sym from trade where sym in S]
\t select sum size from trade
\t select sum size by sym from trade
\t select sum size by date,sym from trade
\

n:100
\t do[n;select distinct date from trade where sym=s]
\t do[n;select count i by date from trade where sym=s]
\t do[n;select count distinct sym by date from trade]

select size wavg price by sym from trade where sym in S / vwaps
select count i by signum deltas price from trade where sym=s / up, down and noticks
2#desc ratios select last price by date,time.hh from trade where sym=s	/ best hours
select last price,sum size by date,time.hh from trade where sym=s	/ hour bars
select last price,sum size by date,10 xbar time.minute from trade where sym=s	/ 10 minute bars
select from trade where sym=s,price<.991*5 mavg price / moving signal
select max price - mins price from trade where sym=s / best single buy then sell

select mid:.5*avg bid+ask by time.minute,sym from quote where date=d,sym=s,ex="N"

\




f:{[a;b;c] / start end constraints
 d:`date$a;a:((=;`date;d);(>=;`time;`time$a));
 e:`date$b;b:((=;`date;e);( <;`time;`time$b));
 raze ?[trade;;0b;()]each(a;enlist(within;`date;(d+1;e-1));b),\:c}
f[2000.10.02T12:00:00;2000.10.03T10:00:00;enlist(=;`sym;enlist`A)]
\

continous queries? e.g. pairs trading, questions about moving averages and so on.
1. Which queries need to go up to the last tick? Which ones can work up to say yesterday?
2. Does past data need to be stored/queried in the same granularity (ticks) as fresh data?
3. with infinite capacity: which queries would you be asking that you can't ask today?

/ select `AA.N etc.
f:{[d;s]x:string s;update sym:s from select from trade where date=d,sym=`$-2_x,ex=last x}
F:{[d;S]raze f[d]each S}
r:`time xasc F[d;`A.N`AA.N],
update value sym from select from trade where date=d,sym in`A`AA
