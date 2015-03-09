/ generate trades and quotes for ~7000 syms with log normal counts

N:5600000 /trades

c:{x?"A"} /chars

S:?`QQQ,"n"$+c'3#9000 /syms

n@:>n:-_-n*N%+/n:exp 1.8*?-#S /counts

S@:i:<S;n@:i

T:{x@<x:09:30+x?06:30:00.000} /times

E:C:M:"ABCDEFGHIJKLMN"  /exch cond mode

f:{x 0:","/'(,$y),/:+$.+g z} /file write

/trades
g:{+`t`e`c`z`p!(T x;x?E;x?C;10+x?90;1000+x?9000)}
\t f/[,"t.csv"0:();S;n]

/quotes
g:{+`t`e`b`bz`a`az`m!(T x;x?E;1000+x?500;10+x?90;1000+x?900;10+x?90;x?C)}
\t f/[,"q.csv"0:();S;6*n]



