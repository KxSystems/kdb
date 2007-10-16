/ publish dict(or list) of "bghijefzCGHIJEF" or dict

con:`rv 2:(`con;1)
sub:`rv 2:(`sub;2)
req:`rv 2:(`req;3)
pub:{req[neg x;y;z]}

c:con```;s:`asd

/server
upd:{0N!(x;y)};rep:{y};sub[c;s]
pub[c;s]2 3
\


/client
d:`b`g`h`i`j`e`f`z`C!(1b;0x23;23h;23;23j;2.3e;2.3;2000.01.02T12:34:56.789;"qwe")
t:1000#enlist d


/ solo: 1000 per sec  bulk: 10000 
\t do[1000;pub[c;s;d]];req[c;s;()]
\t do[1000;req[c;s;d]]
\t req[c;s;t]

