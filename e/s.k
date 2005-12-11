\d .s SQL w(word) w0(class) w1(transition) v(value)
w0:@[127#0N;w;:;!#w:"i"$(" \t\r\n";",()*/+";95,/65 97+/:!26;".0123456789:";"<=>"),"e-'"]
w1:w[;0]?1_'w:("  +a0<a+'";"+ +a0<a+'";"a +bb<b+'";"0 +*1<e+'";"< +a0>a+'"
   "'tttttttu";"b +bb<b+'";"1 +*1<e+'";"> +a0<a+'";"e +*1<*1'";"ttttttttu";"u +a0<a+t")
w:{(i_x)@&0<s i:&6>s:0 w1\w0 x};q:$`or`and`not`like`in`sum`min`max`avg`count`distinct
v:{$["'"=t:*x;,`$1_-1_x;t in"(),";t;t="/";%;(t in".0123456789+-*<>=")|(x:_x)in q;. x;`$x]}

/ parse utilities: n(next) i(idem) p(paren) p1(prefix) p2(infix) l(list) b(cond)
n:{r j+:1};i:{j+:1;x};p:{(j+:1;x n[])1};p1:{$[x~z;((x;-:)x~(-);y n[]);y z]}
p2:{{y;r[j]in x}[x]{|(x n[];y;r j)}[y]/y z};l:{{","~r j}{x n y}[x]\x y};b:{$[x~r j;y n[];()]}

/ a(arith) c(cond)
a:p2[(+;-)]p2[(*;%)]p1[-]{$["("~x;p a;~"("~n[];x;(#:)~x;(j+:1;(#:;$[(?:)~x:n[];(x;i n[]);i x]))1;(x;p a)]}
c:p2[|]p2[&]p1[~:]{$["("~x;p c;|(,a n[]),|(r j;a x)]};ca:{$[@x;x;(&)~*x;,/ca'1_x;,x]};wh:{$[#x:b[`where]c;ca x;x]}
tt:(`char`varchar`tinyint`smallint`bigint,t)!`symbol`symbol`byte`short`long,t:`int`real`float`date`time`datetime
col:{(p;x;$[`references~r j+:p:`primary~r j+:3*`symbol=t:tt i n[];i n[];t])};ins:{x insert*:'*+0N 2#3_r;}
cre:{n[];c:+p l col;.[x;();:;(+/*c)!+c[1]!c[2]$\:()];};upd:{![x;wh[];0b;(!).+l[{|(a n[];i x)}]n[]]};del:{'`nyi}
jn:{if[~1=#r:$[1=#x;x;x@&~b:1={$[98=@x:. x;0;#+!x]}'x];'`join];r:*r;x@:&b;e:1_'y@&b:{$[~(=)~*x;0b;11=@x:1_x]}'y
 y@:&~b;a:e@'b:e[;0]in c:{`/:x,*!+!. x}'x;b:e@'~b;(+(r,x)!(,r!!#. r),x$.:'a b?c;y,(=),'e@&~b in c)}
nm:{$[1<#x;nm x 1;-11=@x;*|`\:x;`x]};m:{(!).+l[{($[(x:r j)in(::;","),``from`where`group`order;nm y;i x];y:x y)}x]y}
sel:{s:$[(*)~x:r j+:d:(?:)~x;i();m[a]x];e:j;@[`.;x:!x;:;.:'. x:m[i]n[]];e=:j-2;w:wh[];g:#b[`group]l i;
 x:(?).$[e;(.*x;w);jn[x]w],(g:$[g;g#s;d];g_s);$[(o~!g)|~#o:b[`order]l i;x;.q.xasc[o]x]}

e:{$[#r::v'r@:&~(r::w x)in$`table`into`values`set`key`asc`by`as;(`.s `$3#$*r)r j::1;]}
\

\d .
s)create table s(s varchar(5)primary key,name varchar(20),status int,city varchar(15))
s)insert into s values('s1','smith',20,'london')
s)update s set status=21 where city='london'
s)create table sp(s varchar(5),p varchar(6),qty int)
s)insert into sp values('s1','p1',300)
s)select s from sp
s)select s.city from s,sp where s.s=sp.s

\
create {table|view} i({i{int|..}[primary key][references i]}'s[,primary key(i's)])
insert into i[(i's)]select|t|values(a's); delete from i where c; update i set{i=a}'s where c
select[distinct]{*|{a[i]}'s}from{[t]i}'s[where c][group i's][having c][order{i[desc]}'s]
a:[+|-][*|/][-]{k|count([distinct i]|i|*)|[{sum|min|max|avg}](a)|case[a]{when c then a}'s[else a]end}
c:[or][and][not]a{<|=|>|>=|<>|<=|like|in|between a and}a
t:[union|except][intersect](select|t)|i

todo: view between having
union except intersect
case when then else end