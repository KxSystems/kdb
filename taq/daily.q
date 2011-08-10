/ 2011.08.10 build over multiple partitions
/book regNMS
/q taq/daily.q f:/taq 2000.10.02

if[$[2<>count .z.x;1b;0Nd="D"$.z.x 1];-1">q ",(string .z.f)," SRC DATE";exit 1]
system"l ",.z.x 0;d:.z.x 1

\t `:daily/ upsert 0!select open:first price,high:max price,low:min price,
    close:last price,size wsum price,sum size by date,sym from trade where date="D"$d

/ nbbo and total sizes from quotes
f:{j:(i:group e){where deltas x,y}'count e:x`ex;
    flip`bid`bsize`ask`asize!(
    t;sum((0,'x[i;`bsize])@'j)*b=\:t:max b:(0.0e,'x[i;`bid])@'j;
    t;sum((0,'x[i;`asize])@'j)*a=\:t:min a:(1e9e,'x[i;`ask])@'j)}

/ select from x where ex in"CNPT"
/ keep only new nbbo's(60%); set 0 asks to infinity(1e9e)
u:{((`sym`time#x),'r)where differ r:f update ask:?[not ask;1e9e;ask]from 
    update bid:?[not bsize;0e;bid],ask:?[not asize;0e;ask]from x} 

/ process 1000 syms at a time.  1,000,000 per second
p1:{q:delete mode from(0N!x)`quote;
    {.[y;`nbbo`;$[0N!x[0;0];,;:];raze{u y x}[;z]each x]}[;x;q]each 1000 cut value group q`sym;
    .[x;`nbbo`sym;`p#]; /set partition flag
    x}

\ts p1 each{sv[`]y,x}[`$d]each .Q.pd where .Q.pv="D"$d

\

/ processing one quote at a time
g:{first select max bid,(bid=max bid)wsum bsize,min ask,(ask=min ask)wsum asize from t,:x}
f:{t::select by ex from 0#x;g each x}
