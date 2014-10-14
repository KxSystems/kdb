/$k a.k frag  # reassemble

f:{$[x$y;#y;*|&(n#\:y)~'(-n:!(#x)&#y)#\:x]} / overlap

g:{(x^a),,{x,f[x;y]_y}/a@:*>f/'a:x -2?-#x}  / merge max

*(1<#:)g/1_'"}"\-1_1:*x                     / run

\

x:"{hat end}{all is well}{ell that en}{t ends well}{ends}"

