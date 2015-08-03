\d .j

/[]{} Cbg*xhijefcspmdznuvt
q:"\"";s:{q,x,q};J:(($`0`1)!$`false`true;s;{$[#x;x;"null"]};s;{s@[x;&"."=8#x;:;"-"]};s)1 2 5 11 12 16h bin
j:{$[10=abs t:@x;s@,/{$[x in r:"\t\n\r\"\\";"\\","tnr\"\\"r?x;x]}'x;99=t;"{",(","/:(j'!x),'":",'j'. x),"}";-1<t;"[",($[98=t;",\n ";","]/:.Q.fc[j']x),"]";J[-t]@$x]}

/enclose
e:{(*x),(","/:y),*|x};a:"\t\n\r\"\\";f:{$[x in a;"\\","tnr\"\\"a?x;x]}
j:{$[10=abs t:@x;s$[|/x in a;,/f'x;x];99=t;e["{}"](j'!x),'":",'j'. x;-1<t;e["[]"].Q.fc[j']x;J[-t]@$x]}

/disclose
v:{=\~("\\"=-1_q,x)<q=x};d:{$[1<n:(s:+\v[x]*1 -1 1 -1"{}[]"?x)?0;1_'(0,&(v[x]&","=x)&1=n#s)_x:n#x;()]}
c:{$["{"=*x;(`$c'n#'x)!c'(1+n:x?'":")_'x:d x;"["=*x;.Q.fc[c']d x;q=*x;$[1<+/v x;'`err;"",. x];"a">*x;"F"$x;"n"=*x;0n;"t"=*x]}
k:{c x@&~v[x]&x in" \t\n\r"};

\

k j x:([]C:$`as`;b:01b;j:0N 2;z:0Nz,.z.z)
k j x:"\"a \\"
k"{},2]"


