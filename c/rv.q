upd:{[t;x]0N!(t;x)}
con:`rv 2:(`con;1)
sub:`rv 2:(`sub;2)
pub:`rv 2:(`pub;3)
req:`rv 2:(`req;3)
s:`asd
d:`a`b`g`h`i`j`e`f`s`z!("asdf";1b;0x23;23h;23;23j;2.3e;2.3;`qwe;2000.01.02T12:34:56.789)
c:con```
sub[c;s];
d:`a`b!("asdf";`u`i!(2 3;3.4))
pub[c;s;d];
\

n:10000
i:0
upd:{y;if[n=i+:1;0N!.z.z]}
k)d:(,`a)!,100#"asdf"
0N!.z.z;do[n;pub[c;t]d]
h:hopen 1
\t do[n;(neg h)d];h""
\
t:`NASDAQL1.AAPL / test

c:con(`7523;`$"eth0;239.5.5.135;239.5.5.136";`drumset:7500)
sub[c]t

t:`CMTE.DATA.TEST.SERVICE.GETALL  LISTALL
c:con(`8425;`$";239.191.84.25";`tcp:7500)
req[c;t;(enlist `SERVICE_NAME)!enlist"QTEST"]