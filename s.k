/
k:..|{[d|t|ts]'..'}|[date|time|timestamp]'..'
a:[+|-][*|/][-]{k|count([distinct i]|i|*)|[{sum|min|max|avg}](a) 
c:[or][and][not]a{<|=|>|>=|<>|<=|like|in|between a and}a
CREATE table i({i{int|..}[primary key][references i]}'s)
INSERT into i[(i's)]values(a's);UPDATE i set{i=a}'s where c;DELETE from i where c
SELECT[distinct]{*|{a[i]}'s}from{[t]i}'s[where c][group by i's][order by{i[asc|desc]}'s]
joins(one non-key linked with the rest single-key)
\

\d .s SQL w(word) w0(class) w1(transition) v(value)
w0:@[127#1;w;:;!#w:"i"$(" \t\r\n";",(){}*/+";34 95,/65 97+/:!26;".0123456789:";"<=>"),"e-'"]
w1:w[;0]?1_'w:("  +a0<a+'";"+ +a0<a+'";"a +bb<b+'";"0 +*1<e+'";"< +a0>a+'"
   "'tttttttu";"b +bb<b+'";"1 +*1<e+'";"> +a0<a+'";"e +*1<*1'";"ttttttttu";"u +a0<a+t")
w:{(i_x)@&0<s i:&6>s:0 w1\w0 x};g:`create`insert`update`delete`select;k:`from`where`group`order;.q.between:within
q:$`or`and`not`like`in`between`sum`min`max`avg`count`distinct;h:$`values`references`primary,k,g,d:`date`time`timestamp
v:{$["'"=t:*x;,`$-1_1_x;t in"{}(),";t;t="/";%;t in".0123456789+-*<>=";. x;(f:_x)in q;. f;f in h;`$f;`$x@&~x="\""]}
e:{$[~#r::v'r@:&~(_r::w x)in$`as`asc;;5>si[g]r 0;`.s[`$_3#$*r][];-6!c r j::0]}

/parse: n(next) i(idem) p(paren) p1(prefix) p2(infix) l(list) b(cond)
n:{r j+:1};i:{j+:1;x};p:{i x n[]};p1:{$[x~z;((x;-:)x~(-);y n[]);y z]};si:{x?$[-11=@y;y;`]};m:{"DTZ"[x]$$*i r j}
p2:{{y;|/r[j]~/:x}[x]{|(x n[];y;r j)}[y]/y z};l:{{","~r j}{x n y}[x]\x y};b:{$[x~r j;y r j+:1+`by~r j+1;()]}
a:p2[(+;-)]p2[(*;%)]p1[-]{$["("~x;p a;"{"~x;i m`d`t?r -1+j+:2;~"("~n[]
 $[(3>t:si[d]x)&11=@r j;m t;x];(#:)~x;i(#:;$[(?:)~x:n[];(x;i n[]);i$[(*)~x;`i;x]]);(x;p a)]}
c:p2[|]p2[&]p1[~:]{$["("~x;p c;|(,$[(in)~f;.q.plist,l[a]n n[];(within)~f;|(a n[];a n[]);a n[]]),|(f:r j;a x)]};

wh:{$[#x:b[`where]c;{$[@x;x;(&)~*x;,/.z.s'1_x;,x]}x;x]};f:{$[~t:@x;f'x;-11=t;*|`\:x;x]}
nm:{(!).+l[{($[|/(x:r j)~/:(`;","),k;{$[1<#x;.z.s x 1;-11=@x;*|`\:x;`x]}y;i x];y:x y)}x]y}
jn:{if[~1=#r:x@&~b:1={$[98=@x:. x;0;#+!x]}'x;'`join];r:*r;x@:&b;e:1_'y@&b:{$[~(=)~*x;0b;11=@x:1_x]}'y
 y@:&~b;a:e@'b:e[;0]in c:{`/:x,*!+!. x}'x;b:e@'~b;(+(r,x)!(,r!!#. r),x$.:'a b?c;y,(=),'e@&~b in c)}
sel:{j::1;s:$[(*)~x:r j+:d:(?:)~x:r j;i();nm[a]x];e:1=#x:nm[i]n[];w:wh[];if[e;s:f's;w:f'w];g:#b[`group]l i;
 v:.`.;x:(?).$[e;(.*x;w);[.[`.;();,;.:'x];jn[!x]w]],($[g;g#s;d];g_s);.[`.;();:;v]
 if[`order~r j;if[~o~(g&#o:{$[2=#x;::;,:]@*|`\:x 1}'(&","~'o)_o:",",(j+2)_r)#!s;x:0!x;x:g!x{x y z x}/[::;(<:;>:)0<@:'o;x@*:'o:|o]]];x}

t:(`char`varchar`tinyint`smallint`bigint`timestamp!`symbol`symbol`byte`short`long`datetime),t!t:`boolean`int`real`float`date`time
cre:{j::3;c:+p l{(p;x;$[`references~r j+:2*p:`primary~r j+:3*`symbol=a:t@_i n[];i n[];a])};.[r[2];();:;(+/*c)!+c[1]!c[2]$\:()];}
ins:{j::3;t:r 2;f:$["("~r j;l[i]n[];!+0!. t];t insert f!(@:'(0!. t)f)$-6!'l[a]r j::2+r?`values;}
upd:{j::3;![r[1];wh[];0b;(!).+l[{|(a n[];i x)}]r j];};del:{j::3;![r[2];wh[];0b;0#`];}
\

\d .
s)create table s(s varchar(5)primary key,name varchar(20),status int,city varchar(15))
/s:([s:`symbol$()]name:`symbol$();status:`int$();city:`symbol$())
s)create table p(p varchar(6)primary Key,name varchar(20),color varchar(6),weight int,city varchar(15))
s)create table sp(s varchar(5)references s,p varchar(6)references p,qty int)
s)insert into s values('s1','smith',20,'london')
/s,:(`s1;`smith;20;`london)
s)insert into p values('p1','nut','red',12,'london')
s)insert into sp(s,p,qty)values('s1','p1',300)
s)select s from sp
s)select a.city from s a,sp b where a.s=b.s
s)update s set status=21 where city='london'

/use q instead of sql. q is simpler, faster and more expressive, e.g.
s)select distinct sp.p,s.city from sp,s where sp.s=s.s
q)select distinct p,s.city from sp

s)select p.color,sum(sp.qty) from sp,p where sp.p=p.p group by p.color order by color
q)select sum qty by p.color from sp

s)select sp.s,sp.p,sp.qty from s,p,sp where sp.s=s.s and sp.p=p.p and p.city=s.city
q)select from sp where s.city=p.city

\
2007.06.29 insert for keyed tables
2007.03.07 insert type$
2007.02.05 a between b and c;{[d|t|ts]'..'}

a;b; (insert with result?)
view;having c
t:[union|except][intersect](select|t)|i
case[a]{when c then a}'s[else a]end}
[,primary key(i's)]