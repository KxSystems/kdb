/ put this file in taq/
/ corporate actions: symbol, split and dividend adjustments
smd:select first sym by cusip,date from mas where not wi
smd:select from smd where differ sym,(cusip=prev cusip)|cusip=next cusip
smd:delete cusip from update mas:last sym by cusip from smd
dxy:{[d;x;y]first$[0>type x;d(x;y);flip d flip(keys d)!(x;y)]} / util

/ taq master data should be overridden.
msd:`s#select by sym,date from smd;MSD:{x^dxy[msd;x;y]} / mas from sym
smd:`s#select by mas,date from smd;SMD:{x^dxy[smd;x;y]} / sym from mas

/ taq split/dividend data must be overridden. sample data from 2000.10
amd:([]sym:`HWP`CUZ`HWP;date:1996.06.30 2000.10.03 2000.10.30;adj:2 1.5 2)

amd:update prds adj by mas from delete sym from update mas:sym^mas from amd lj msd
amd:update adj%last adj by mas from([]date:0Nd;adj:1.0;distinct amd.mas),amd
amd:`s#select by mas,date from amd;AMD:{1^dxy[amd;x;y]}  / adjustment

s:100#`$read0`:tick/sp500.txt
\t a:select sum size by sym,date,6 xbar time.minute from trade
 where sym in s,time within 09:00 10:00
\t b:select sum size%AMD[mas;date]by mas,minute from update mas:MSD[sym;date]from a

\t mdaily:select mas,date,adj*high,adj*low,adj*price,size%adj from
 update adj:AMD[mas;date]from`mas xasc
 update mas:MSD[sym;date]from select from daily

/ return timeseries for daterange and symbols
ret:{[d;s]
 update AMD[mas;date]*price,size%AMD[mas;date]from
  select date,time,mas:MSD[sym;date],price,size from 
   trade where date within d,sym in SMD[s;first date]}

/ examples
.Q.view 2000.10.02 2003.09.10
smd(`HPQ;2000.10.02)
msd(`HWP;2000.10.02)
amd(`HPQ;2000.10.02)

r:ret[2000.01.01 2004.01.01;`HPQ]

\
customers choose between nightly calculation of adjustments
or apply on the fly. (millions per second.) we recommend the latter.
 
all we need is a small table of events loaded into the database.
([sym;date]adjustment)
queries can be wrapped in stored procedures to make this easier.

taq ftp's and dvd's come with simple cusip master tables.
this information is incomplete and can be added to in this script.
dividend and split information needs to be supplied from elsewhere.
since this data can change every day we store the raw sym and price
and apply daily adjustments on the fly. (millions per second)
intraday calculations, e.g. returns, do not require adjustment.

we could store adjustments for every day and sym but 
mas,date,sym,adj for 30000 syms over 3000 days is 2GB.
we just need the changes and mark them 'asof'(`s#..)

mergers can be handled as a surviving company. e.g. XOM 19991201 XON (MOB stops)
master can be anything. e.g. here it is last known sym.

note we should do:

.. where sym in SMD[M;date]

not

.. where MSD[sym;date]in M

because the table is indexed by sym

splits(and dividends)

typical source data is:

([sym;date]split)
e.g.(made up)
HWP 1996.06.30 1.5
HPQ 2000.10.30 2

we need to turn that into:

([mas;date]runningadjustment)

HPQ 0N         .333..
HPQ 1996.06.30 .5
HPQ 2000.10.30 1


so that master asof today is HPQ
adjustment
asof 2000.10.30 is 1
asof 1996.06.30 is .5
before that is .333
 
splits&dividends: `RY`RY;2000.10.06 2000.10.23;2 1.00733 (p%p-x)
cusip changes: `PE`EXC
