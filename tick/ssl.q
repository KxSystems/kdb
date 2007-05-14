/ 2005.05.12  x@&"6"=x[;3] /updates (image is 340)
/ q tick/ssl.q {sym|taq|fx|dj30|sp500} [host]:port[:usr:pwd]
/ modify this file for your feeds and schemas
/ 100,000 triarch/ssl records per second

x:.z.x,count[.z.x]_("sym";":5010")
d:x 0;if[not h:neg@[hopen;`$":",x 1;0];trade:3#();quote:5#();.u.upd:{@[x;::;,;y]}]
sub:`ssl 2:(`sub;1)
ssub:`ssl 2:(`ssub;2)
if[not count@[sub each;sym:`$read0`$"tick/",d,".txt";()];sub:{x};
 x:{@[x;(where 0x1e=x),-1+count x;:;"\n"]}each read0`:/ssl/ssl.dat`:/ssl/l2.txt d~"lvl2"]

/ callbacks
close:0#`;stt:{[r;e;s]if[s in 7 8;close,:r];-1 e;};dis:{-1"disconnect"};rec:{-1"reconnect"}

g:(!).("I*";0x1f)0:  / (fids!values) from string   note: ask 0(means 0w)
/ fid funcs: price bid ask size bsize asize ttime qtime price buysell
fi:6 22 25 178 30 31 379 1025 1067 393 270!("F"$;"F"$;"F"$;"I"$;"I"$;"I"$;"V"$;"V"$;"V"$;"F"$;31="I"$)
/ default trade and quote fields (and sym function)
ti:6 178;qj:2#qi:22 25 30 31;  sf:{3_first x}

/ update callback
t:q:();f:{k each x where"6"=x[;3];
 if[count t;h(".u.upd";`trade;flip t)];
 if[count q;h(".u.upd";`quote;flip q)];
 t::q::()}

/ default parse
k:{s:`$sf x:g x;
 if[    tj in key x;t,:enlist s,tf@'x ti];
 if[any qj in key x;q,:enlist s,qf@'x qi]}

/ sample overrides
if[d~"fx";ti:393 270;qi:22 25]

if[d~"taq";
 cond:"BCDJKL STWZ"16 3 4 23 24 1 -1 138 61 171 139?"I"$;  /40 (.O uses 131)
 mode:" AB  FHILNO R  XZY"15 14 62 27 17 16 36 61 35 63 28 60 57 58 188 29 96?"I"$;
 k:{if[o:"O"=e:last s:sf x:g x;e:"T"];s:`$-2_s;
  if[    tj in key x;t,:enlist s,(tf@'x ti),(0b;cond x 40 131 o;e)];
  if[any qj in key x;q,:enlist s,(qf@'x qi),(mode x 118;e)];}]

if[d~"lvl2";
 f:{i each x where not u:"6"=x[;3];k each x where u;if[count q;h(".u.upd";`quote;flip q)];q::()};
 k:{if[any qj in key x:g x;q,:enlist(`$-4_s;`$-4#s:-2_sf x),qf@'x qi]};
 i:{m,:sub each`$u where 9<count each u:(x:g x)800+til 14;if[count u:x 815;sub`$u]}]

tj:first ti;tf:fi ti;qf:fi qi
\

/ maintain previous bid/ask state and fill if necessary
bid:ask:()!`float$()
as:{[s;x]$[null x;ask s;ask[s]:x]}
bs:{[s;x]$[null x;bid s;bid[s]:x]}
k:{s:`$sf x:g x;
 if[    tj in key x;t,:enlist s,tf@'x ti];
 if[any qj in key x;q,:enlist s,(as[s];bs[s];::;::)@'qf@'x qi];}

\

MSFT.O GE.N
VOD.L RTR.L
CAD=D2 EUR=EBS

London - (cond1)1068,(cond2)1069
euro:`AS`AT`BR`CO`DE`HE`I`IN`J`L`LN`MC`MI`OL`PA`ST`VI`VX
sym!:(count sym)#`;stt:{[r;s]if[not s=9;sym[r]:`ok`stale`close 10 11?s]}