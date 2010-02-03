/ trees and graphs

/ q parse tree: nested expression (f;x;..). quote data with enlist, e.g.
e:{$[-11h=t:type x;value x;not t in 0 11h;x;1=count x;first x;value e each x]}
a:2
e(,;`a;enlist`b)

/ nested directory: use a parent vector, e.g.
/ a
/ b
/  c
/   d
/  e

p:0N 0N 1 2 1 / parent
n:`a`b`c`d`e  / name
c:group p     / children
n p scan 3    / full path

/ binary tree: can use a 2 column transition matrix(then 0 t\x). e.g. huffman encode

v:"abcde" / some values with weights 1 2 3 4 5
d:v!(0 1 0;0 1 1;0 0;1 0;1 1) / huffman write tree
t:(6 7;6 7;6 7;6 7;6 7;0 1;2 5;3 4;6 7) / huffman read matrix
bd:{raze d x} / bits from data
db:{v x where count[v]>x:0 t\x} / data from bits
db bd v


/ dags http://en.wikipedia.org/wiki/Adjacency_matrix
/ adjacency matrix. connect{any x&y} shortest{min x+y}

m:(1101b;0110b;0010b;0001b)
m{any x&y}\:m

/ adjacency list

v:(0 1 3;1 2;enlist 2;enlist 3)
{distinct raze v x}each v


