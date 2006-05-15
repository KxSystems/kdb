/ e.g.  q mserve.q -p 5001 2 tq

/ start slaves
{value"\\q ",.z.x[1]," -p ",string x}each p:(value"\\p")+1+til"I"$.z.x 0;

/ unix (comment out for windows)
\sleep 1

/ connect to slaves
h:neg hopen each p;h@\:".z.pc:{exit 0}";h!:()

/ fields queries. assign query to least busy slave
.z.ps:{$[(w:neg .z.w)in key h;[h[w;0]x;h[w]:1_h w];                    /response
 [h[a?:min a:count each h],:w;a("{(neg .z.w)@[value;x;`error]}";x)]]}  /request


\

client(h:hopen 5001):  (neg h)x;h[]

l64: 50us overhead(20us base)

