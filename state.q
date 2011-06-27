/ input p. entry 12. exit 6.
p:10 11 12 12 13 14 13 11 9 5 5 5 4 3 5 6 7 8 9 10 12
0+0b{$[x;y>6;y>11]}\p

/ state transition matrix for all possible inputs
m:0+11 6<\:til 20
0 m\p

/ or translate to inputs 0(exit) 1(no op) 2(entry)
0(0 0 1;0 1 1)\1+(p>11)-p<7

p:1000000#p
\t 0b{$[x;y>6;y>11]}\p
\t 0 m\p
\t 0(0 0 1;0 1 1)\1+(p>11)-p<7


