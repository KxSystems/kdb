bd:{raze d x}
db:{v x where count[v]>x:0 t\x}

v:"abcde"
n:count w:1 2 3 4 5
t:last[t]^/:t:last(n-1){(@[x,sum x i;i;:;0W];y,enlist i:2#iasc x)}//(w;w&\:2#0N)
d:(!). flip{$[x<n;enlist(v x;y);raze t[x].z.s'y,/:0 1]}[2*n-1;()]

x:1000000?v where w
\t b:bd x
\t db b
x~db bd x