/ generate trades and quotes for ~7000 syms with log normal counts

N:5600000 /small day

c:{"c"$-32+"i"$x?" "} /chars

S:distinct`QQQ,`$flip c each 3#9000 /syms

\l stat.q
n:desc 1+floor n*N%sum n:exp 1.8*nor count S /counts

S@:i:iasc S;n@:i

T:{asc 09:30+x?06:30:00.000} /times

E:C:M:"ABCDEFGHIJKLMN"  /exch cond mode

f:{x` sv","sv'(enlist string y),/:flip string value flip g z} /file write

/trades
g:{([]t:T x;e:x?E;c:x?C;z:10+x?90;p:1000+x?9000)}
\t S f[hopen`:t.csv 0:()]'n

/quotes
g:{([]t:T x;e:x?E;b:1000+x?500;bz:10+x?90;a:1000+x?900;az:10+x?90;c:x?C)}
\t S f[hopen`:q.csv 0:()]'6*n


