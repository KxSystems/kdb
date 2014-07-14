\d .j

/[]{} Cbg*xhijefcspmdznuvt
q:"\"";s:{q,x,q};t:{s@[x;&"."=8#x;:;"-"]}
J:(($`0`1)!$`false`true;s;{$[#x;x;"null"]};s;t;s)1 2 5 11 12 16h bin

/enclose
e:{(*x),(","/:y),*|x}
j:{$[10=abs t:@x;-3!$[1=#x;*x;x];99=t;e["{}"](j'!x),'":",'j'. x;-1<t;e["[]"].Q.fc[j']x;J[-t]@$x]}

/dsclose
v:{=\~("\\"=-1_q,x)<q=x};d:{$[2<#x;1_'(0,&(v[x]&","=x)&1=+\1 -1 1 -1"{}[]"?x)_-1_x;()]}
c:{$["{"=*x;(`$c'n#'x)!c'(1+n:x?'":")_'x:d x;"["=*x;.Q.fc[c']d x;q=*x;$[1<+/v x;'`err;"",. x];"a">*x;"F"$x;"n"=*x;0n;"t"=*x]}
k:{c x@&~v[x]&^x}

\

k j x:([]C:$`as`;b:01b;j:0N 2;z:0Nz,.z.z)
k j x:"\"a \\"

