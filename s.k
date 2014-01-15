/
[date|time|timestamp]'..'|{{d|t|ts}'..'}   if(c,t,f) ifnull(x,y) addmonths(x,y)
a:[+|-][*|/][-]{(c)|count([distinct i]|i|*)|[{sum|min|max|avg}](a)|case[a]{when c then a}'s[else a]end
c:[or][and][not]{a[{<|=|>|>=|<>|<=|like|in|between a and}a]};t:i{{left|right}outer|inner}join on c
select[distinct]{*|{a[i]}'s}from{[t]i}'s[where c][group by a's][having c][order by{a[asc|desc]}'s][limit i]
create table i({i{int|..}[primary key][references i]}'s);drop table i
insert into i[(i's)]values(a's);update i set{i=a}'s where c;delete from i where c
(joins must be one non-key linked with the rest single-key)
\

\d .q
ifnull:{y^x};between:within;addmonths:.Q.addmonths
\d .s SQL w(word) w0(class) w1(transition) v(value)
q:$`ifnull`addmonths`between`or`and`not`like`in`sum`min`max`avg`count`distinct`log`exp`abs;ls:$[.z.K>3.1;enlist;.q.enlist]

w0:@[127#1;w;:;!#w:"i"$(" \t\r\n";",(){}*/+";34 95,/65 97+/:!26;".0123456789:";"<=>"),"e-'\""];si:{x?$[-11=@y;y;`]}
w1:w[;0]?1_'w:("  +a0<a+'\"";"+ +a0<a+'\"";"a +bb<b+'\"";"0 +*1<e+'\"";"< +a0>a+'\"";"'tttttttut";"\"vvvvvvvvw"
 "b +bb<b+'\"";"1 +*1<e+'\"";"> +a0<a+'\"";"e +*1<*1'\"";"ttttttttut" ;"u +a0<a+t\"";"vvvvvvvvvw";"w +aw<a+'v")
w:{(i_x)@&0<s i:&7>s:0 w1\w0 x};g:`create`insert`update`delete`select`drop;k:`from`where`group`having`order
h:$`case`when`then`else`end`references`primary`left`right`inner,k,g,d:`date`time`timestamp
v:{$["'"=t:*x;,`$x@&1b|':~t=x:-1_1_x;t in"{}(),";t;t="/";%;t in".0123456789+-*<>=";. x;"if"~f:_x;?;f in q;. f;f in h;`$f;`$x@&~x="\""]}
e:{$[~#r::v'r@:&~(_r::w x)in$`as`by`asc`temporary`outer`join`on;;6>si[g]r j::0;`.s[`$_3#$*r]j;-6!c r j]}

wt:{x:|+1_{`when~r j}{(a n[];c n[])}\x;ls,'$[`else~r j;@[x;1;,;,a n[]];x]}
cs:{$[@y;y x;(x'). y]};c1:{$[`when~x:r j;{cs[(+x)?'1b;y]},wt[];{cs[y?x;z]},|(|wt[]),,a x]}
/parse: n(next) i(idem) p(paren) p1(prefix) p2(infix) l(list) b(cond)
n:{r j+:1};i:{j+:1;x};p:{i x n[]};p1:{$[x~z;((x;-:)x~(-);y n[]);y z]};dt:{"DTZ"[x]$$*i r j}
p2:{{y;|/r[j]~/:x}[x]{|(x n y;y;r j)}[y]/y z};l:{{","~r j}{x n y}[x]\x y};b:{$[x~r j;y n[];()]}
a:p2[(+;-)]p2[(*;%)]p1[-]{$["("~x;p c;"{"~x;p{dt`d`t?i r j};`case~x;p c1;~"("~n[];$[(3>t:si[d]x)&11=@r j;dt t;x];(#:)~x;i(#:;$[(?:)~x:n[];(x;i n[]);i$[(*)~x;`i;x]]);x,p l c]}
c:p2[|]p2[&]p1[~:]{x:a x;$[9=c:((in;within;like;<;=;>;~>;~=;~<)~\:f:r j)?1b;x;(f;x;$[~i c;ls,p l a;c=1;|(a n[];a r j);c=2;({x^"*?""%_"?x:$x};a r j);a r j])]}

wh:{$[#x:b[`where]c;{$[@x;x;(&)~*x;,/.z.s'1_x;,x]}x;x]};f:{$[(1<#x)&(11=t)|~t:@x;f'x;-11=t;*|`\:x;x]}
nm:{(!).+l[{($[|/(x:r j)~/:(`;","),k;{$[1<#x;.z.s x 1;-11=@x;*|`\:x;`x]}y;i x];y:x y)}x]y}
lj:{+({x!!#. x}'x),y$(0!.*x)(*!x){y[1](*y:+`\:'y)?x}'1_'z} ;lr:{a!:a:,y;b!:b:,r j+2;lj[$[x;b;a];$[x;a;b];,c r j+:3]}
jn:{if[~1=#f:&~1={$[98=@x:. x;0;#+!x]}'x;'`join];a:f#x;b:y{$[(11=@y:1_y)&(=)~*y;x=*`\:y 1-y?z;0b]}[t:*!a]\:/:(!x){`/:x,*!+!. y}'. x:f_x;(lj[a;x;y b?'1b];y@&~|/b)}
st:{[t;w;g;s;h;o;m]if[#h;s[`]:h];t:0!(?).$[98=@t;(t;w;g;s);1=#t;(.*t;f'w;f'g;f's);jn[t;w],(g;s)];if[#h;t@:&t`];if[#o;t@:?[t;::;o]];$[#m;(m&#t)#t;t]}
sel:{j+:d:(?:)~r j::x+1;s:$[(*)~x:r j;i();nm[a]x];if[~`from~r j;'`from];x:$[3>k:si[`left`right`inner]r j+1;lr k;nm i]n[];w:wh[];g:b[`group]l a;h:b[`having]c
 if[#o:$[m:#g;+/g~'m#o;0]_o:b[`order]l{[s;x]x:a x;if[-6=@x;x:s x-1];$[`desc~r j;i(>:;x);x]}[. s];if[1<#o;'`nyio];o:f$[(>:)~*o:*o;o;(<:;o)]];m:b[`limit]i
 v:$[#s;(!s)#;];if[#k:(f'*:'g)^(*&s~\:)'g;g:k#s;$[#s:k_s;s[u]:(*:;)'s u:&0>@:'s;[s:g;g:1b]]];v st[x;w;$[#g;g;d];s;h;o;m]}

t:(`char`varchar`tinyint`smallint`bigint`timestamp!`symbol`symbol`byte`short`long`timestamp),t!t:`boolean`int`real`float`date`time
cre:{j::3;if[`select~r j;:.[r 2;();:;sel j]];c:+p l{(p;x;$[`references~r j+:2*p:`primary~r j+:3*`symbol=a:t@_i n[];i n[];a])};.[r 2;();:;(+/*c)!+c[1]!c[2]$\:()]}
ins:{j::3;t:r 2;f:$["("~r j;l[i]n[];!+0!. t];t insert f!(@:'(0!. t)f)$-6!'l[a]r j::2+r?`values;}
upd:{j::3;![r 1;wh[];0b;(!).+l[{|(a n[];i x)}]r j];};del:{j::3;![r 2;wh[];0b;0#`];};dro:{.[`.;();_;r 2];}
\

\d .
/use q instead of sql. q is simpler, faster and more expressive, e.g.
s)create table s(s varchar(5)primary key,name varchar(20),status int,city varchar(15))
/s:([s:`symbol$()]name:`symbol$();status:`int$();city:`symbol$())
s)insert into s values('s1','smith',20,'london')
/s,:(`s1;`smith;20;`london)
s)create table p(p varchar(6)primary key,name varchar(20),color varchar(6),weight int,city varchar(15))
s)create table sp(s varchar(5)references s,p varchar(6)references p,qty int)

s)insert into p values('p1','nut','red',12,'london')
s)insert into sp(s,p,qty)values('s1','p1',300)
s)select s from sp
s)select a.city from s a,sp b where a.s=b.s
s)update s set status=21 where city='london'

s)select distinct sp.p,s.city from sp,s where sp.s=s.s
q)select distinct p,s.city from sp

s)select p.color,sum(sp.qty) from sp,p where sp.p=p.p group by p.color order by color
q)select sum qty by p.color from sp

s)select sp.s,sp.p,sp.qty from s,p,sp where sp.s=s.s and sp.p=p.p and p.city=s.city
q)select from sp where s.city=p.city


\
2012.11.26 map sql timestamp to kdb+ timestamp
2010.04.06 revert e to not allow reserved words as column names
2009.12.01 f='x.y' (fix)
2009.04.21 like'a%'
2009.04.17 like'a*'
2009.04.16 order by 1 etc.
2009.04.02 fix sum((a+b)/c)
2007.10.24 left|right|inner

t:[union|except][intersect](select|t)|i
a;b; (insert with result?)
view
[,primary key(i's)]
order by 1 etc
