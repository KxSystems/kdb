\d .j

/[]{} Cbg*xhijefcspmdznuvt
q:"\"";s:{q,x,q};t:{s@[x;&"."=8#x;:;"-"]}
J:(($`0`1)!$`false`true;s;{$[#x;x;"null"]};s;t;s)1 2 5 10 12 16h bin

/enclose
e:{(*x),(","/:y),*|x}
j:{$[10=t:@x;s x;99=t;e["{}"](j'!x),'":",'j'. x;-1<t;e["[]"].Q.fc[j']x;J[-t]@$x]}

/dsclose
v:=\~q=;d:{$[2<#x;1_'(0,&(v[x]&","=x)&1=+\1 -1 1 -1"{}[]"?x)_-1_x;()]}
c:{$["{"=*x;!/+{(`$c n#x;c(1+n:x?":")_x)}'d x;"["=*x;.Q.fc[c']d x;q=*x;1_-1_x;"a">*x;"F"$x;"n"=*x;0n;"t"=*x]}
k:{c x@&~v[x]&^x}

x:([]C:$`as`;b:01b;j:0N 2;z:0Nz,.z.z)
k j x

\
k" [\"as,d\"  ,2]"

