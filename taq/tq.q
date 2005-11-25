/ build test trade/quote database

sym:asc`A`AA`AAPL`CITI`CSCO`IBM`MSFT,100?`4
ex:"NTA"
@[dst:`:tq;`sym;:;sym]

n:1000000
trade:([]sym:n?`sym;time:09:30:00.0+til n;price:n?2.3e;size:n?9;ex:n?ex)
quote:([]sym:n?`sym;time:09:30:00.0+til n;bid:n?2.3e;ask:n?2.3e;bsize:n?9;asize:n?9;ex:n?ex)

{@[;`sym;`p#]`sym xasc x}each`trade`quote;

d:2000.10.02 2000.10.03
dt:{[d;t].[dst;(`$string d;t;`);:;value t]}
d dt/:\:`trade`quote;
