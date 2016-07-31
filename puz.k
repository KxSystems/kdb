/ smallest to the right that is >=
/ 9 3 5 3 7 3 7 7 9 0W
x:8 2 4 1 6 0 5 3 7 9

x?:-x:-10000

/ O(n*n)
f1:{{&/x@&x>*x}':(!#x)_\:x}
f2:{{&/y@&y>*y_:x}[x]':!#x}

/ O(n*log n) atom
f10:{b::(#x)#0b;{b[x]:1b;b(1+)/1+x}'x}
f11:{{while[y>x z+:1];z}[i,#i]'[i;!#i:<x]x}
f12:{{(y>x@)(1+)/1+z}[i,#i]'[i;!#i:<x]x}
f0:{x@{(y>)x/x y}[x?1+x]':!#x}

/ O(n*log n) vector
g0:{x@{y x&y}[!#x]/x?1+x}
g1:{x@{@[y;i;:;y y i:&x>y]}[!#x]/x?1+x}
g2:{x last(*:){(#i;@[y;i;:;y y i:&x>y@:1])}[!#x]/(1;x?1+x)}
g3:{n::x?1+x;{n[x]:n n x@:&x>n x;x}/!#x;x n}

a:`g0`g1`g2`g3
1 .Q.s a!{."\\ts:100 ",x," x"}'$a;

\

g:{y i x@<i:<y} / transform problem to perm

