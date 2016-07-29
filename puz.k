/ smallest to the right that is >=
/ 9 3 5 3 7 3 7 7 9 0W
x:8 2 4 1 6 0 5 3 7 9

x?:-x:-10000

/ O(n*n)
f1:{{&/x@&x>*x}':(!#x)_\:x}
f2:{{&/y@&y>*y_:x}[x]':!#x}

g:{y i x@<i:<y} / transform problem to perm

/ O(n*log n)
f10:{b::(#x)#0b;{b[x]:1b;b(1+)/1+x}'x}
f11:{{while[y>x z+:1];z}[i,#i]'[i;!#i:<x]x}
f12:{{(y>x@)(1+)/1+z}[i,#i]'[i;!#i:<x]x}
f0:{x@{(y>)x/x y}[x?1+x]':!#x}
f:{x@{y x&y}[!#x]/x?1+x}  / thank you pierre

a:`f1`f2`f12`f11`f10`f0`f
1 .Q.s a!{."\\ts ",x," x"}'$a;

