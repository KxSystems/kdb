/ sparse matrix multiply

dv:{i!x i:where not 0=x}
d:dv each m:(2 0 3.0;0 0 2.0;0 1 0.0)
dmm:{x{dv@[x#0.0;key each y;+;value each y:value[y]*z key y]}[1+max last each key each y]\:y}
dmm[d;d]

md:{{@[x;key y;:;value y]}[(1+max last each key each x)#0f]each x}
dmm2:{value[x]wsum y key x}\:
