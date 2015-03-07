\l ../taq
.Q.MAP[]
d:2003.09.10
S:100#first flip idesc select count i by sym from trade where date=d

\ts select last bid by sym from quote where date=d,sym in S
\ts select max price by sym,ex from trade where date=d,sym in S
\ts select sum size by sym,time.hh from trade where date=d,sym in S
\ts select from aj[`time;select time,price from trade where date=d,sym=`CSCO;select time,bid from quote where date=d,sym=`CSCO]where price<bid

\

/ETL
\t trade:`sym`time`ex`cond`size`price         !("STCCII"  ;",")0:`t.csv
\t quote:`sym`time`ex`bid`bsize`ask`asize`mode!("STCIIIIC";",")0:`q.csv
\t .Q.dpft[`:taq;2013.09.10;`sym]'`trade`quote

