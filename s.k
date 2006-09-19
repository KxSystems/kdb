/
 a:[+|-][*|/][-]{k|count([distinct i]|i|*)|[{sum|min|max|avg}](a) 
 c:[or][and][not]a{<|=|>|>=|<>|<=|like|in}a
SELECT[distinct]{*|{a[i]}'s}from{[t]i}'s[where c][group by i's][order by{i[desc]}'s]
CREATE table i({i{int|..}[primary key][references i]}'s)
INSERT into i[(i's)]select|t|values(a's)
UPDATE i set{i=a}'s where c
joins(one non-key linked with the rest single-key)
\

\d .s SQL w(word) w0(class) w1(transition) v(value)
w0:@[127#0N;w;:;!#w:"i"$(" \t\r\n";",()*/+";95,/65 97+/:!26;".0123456789:";"<=>"),"e-'"]
w1:w[;0]?1_'w:("  +a0<a+'";"+ +a0<a+'";"a +bb<b+'";"0 +*1<e+'";"< +a0>a+'"
   "'tttttttu";"b +bb<b+'";"1 +*1<e+'";"> +a0<a+'";"e +*1<*1'";"ttttttttu";"u +a0<a+t")
w:{(i_x)@&0<s i:&6>s:0 w1\w0 x};q:$`or`and`not`like`in`sum`min`max`avg`count`distinct;k:`from`where`group`order
v:{$["'"=t:*x;,`$1_-1_x;t in"(),";t;t="/";%;(t in".0123456789+-*<>=")|(f:_x)in q;. f;`$$[f in$`references`primary,k;f;x]]}
e:{$[#r::v'r@:&~(_r::w x)in$`as`asc;(`.s `$_3#$*r)j::3;]}

/parse: n(next) i(idem) p(paren) p1(prefix) p2(infix) l(list) b(cond)
n:{r j+:1};i:{j+:1;x};p:{i x n[]};p1:{$[x~z;((x;-:)x~(-);y n[]);y z]}
p2:{{y;r[j]in x}[x]{|(x n[];y;r j)}[y]/y z};l:{{","~r j}{x n y}[x]\x y};b:{$[x~r j;y r j+:1+`by~r j+1;()]}
a:p2[(+;-)]p2[(*;%)]p1[-]{$["("~x;p a;~"("~n[];x;(#:)~x;i(#:;$[(?:)~x:n[];(x;i n[]);i x]);(x;p a)]}
c:p2[|]p2[&]p1[~:]{$["("~x;p c;|(,a n[]),|(r j;a x)]};wh:{$[#x:b[`where]c;{$[@x;x;(&)~*x;,/.z.s'1_x;,x]}x;x]}
nm:{(!).+l[{($[(x:r j)in(`;","),k;{$[1<#x;.z.s x 1;-11=@x;*|`\:x;`x]}y;i x];y:x y)}x]y}
/ one non-key table. the rest have single key.
jn:{if[~1=#r:$[1=#x;x;x@&~b:1={$[98=@x:. x;0;#+!x]}'x];'`join];r:*r;x@:&b;e:1_'y@&b:{$[~(=)~*x;0b;11=@x:1_x]}'y
 y@:&~b;a:e@'b:e[;0]in c:{`/:x,*!+!. x}'x;b:e@'~b;(+(r,x)!(,r!!#. r),x$.:'a b?c;y,(=),'e@&~b in c)}
sel:{x:r j::1;s:$[(*)~x:r j+:d:(?:)~x;i();nm[a]x];e:j;v:.`.;@[`.;x:!x;:;.:'. x:nm[i]n[]];e=:j-2;w:wh[];g:#b[`group]l i;
 x:(?).$[e;(.*x;w);jn[x]w],(g:$[g;g#s;d];g_s);.[`.;();:;v];$[(o~!g)|~#o:b[`order]l i;x;.q.xasc[o]x]}

tt:(`char`varchar`tinyint`smallint`bigint!`symbol`symbol`byte`short`long),t!t:`int`real`float`date`time`datetime
cre:{c:+p l{(p;x;$[`references~r j+:2*p:`primary~r j+:3*`symbol=t:tt@_i n[];i n[];t])};.[r[2];();:;(+/*c)!+c[1]!c[2]$\:()];}
ins:{r[2]insert*:'*+0N 2#5_r;};upd:{![r[1];wh[];0b;(!).+l[{|(a n[];i x)}]r j]};del:{'`nyi}

\

\d .
s)create table s(s varchar(5)primary key,name varchar(20),status int,city varchar(15))
s)create table sp(s varchar(5)references s,p varchar(6),qty int)
s)insert into s values('s1','smith',20,'london')
s)insert into sp values('s1','p1',300)
s)select s from sp
s)select a.city from s a,sp b where a.s=b.s
s)update s set status=21 where city='london'

/use q instead of sql. q is simpler, faster and more expressive, e.g.

s)create table s(s varchar(5)primary key,name varchar(20),status int,city varchar(15))
q)s:([s:`symbol$()]name:`symbol$();status:`int$();city:`symbol$())

s)insert into s values('s1','smith',20,'london')
q)s,:(`s1;`smith;20;`london)

s)select distinct sp.p,s.city from sp,s where sp.s=s.s
q)select distinct p,s.city from sp

s)select p.color,sum(sp.qty) from sp,p where sp.p=p.p group by p.color order by color
q)select sum qty by p.color from sp

/s)select from sp where s.city=p.city
/q)select sp.s,sp.p,sp.qty from s,p,sp where sp.s=s.s and sp.p=p.p and p.city=s.city

\

2006.06.14 enable mixed case identifiers
select s as b from s
view
order by p.p
having c
t:[union|except][intersect](select|t)|i
between a and a
case[a]{when c then a}'s[else a]end}
delete from i where c
[,primary key(i's)]