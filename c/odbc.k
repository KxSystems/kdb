\d .odbc / h:open{`userdsn[`usr`pwd]|`*.{dsn|mdb|mdf|syb}|""|"DRIVER=...;DBQ=..."}
h:();`open1`close1`eval1`fkeys1`keys`tables`views{.odbc[x]:`odbc 2:(`$(-"1"=*|$x)_$x;y)}'1 1 2 2 2 1 1;

d:`$":",$["Windows_NT"~getenv`OS;getenv[`commonprogramfiles],"/odbc/data sources";"/etc/ODBCDataSources"]
o:`mdb`mdf!("driver=Microsoft Access Driver (*.mdb);dbq="
            "driver=sql server;server=(local);trusted_connection=yes;database=")
open:{if[~r:@[open1;$[0<@x;x;1=#p:`\:x;x;`dsn~a:*|p;";"/:1_0:$[@!f:`$":",$x;f;`/:d,x];o[a],-4_$x];{e::x;0}];'e];*|h,:r}
close:{if[~x in h;'`invalid];h_:h?x;close1 x}
eval:{if[~x in h;'`invalid];$[@t:eval1[x]y;+@[t;f@&{&/x=_x}'t f@:&15h=@:'t f:!t:+t;_:];t]} / datetime->date
fkeys:{$[#y:fkeys1[x]y;y[;&~x in t@&=':t:x@<x:y 1];y]}	/ singleton fkeys

fkey:{[f;p;t](f;p)[;&(~t=p)&f in g@&~(_g:!+0!. t)in`id`name]}
xfkey:{.Q.ft[{@[y;*x;{@[y$;x;x]};x 1]}[x]]y}
skey:{$[@k:keys[x]y;k*(#+t)>k:#k;0+(x~?x:*+t)&0<#t]!t:.Q.id eval[x]"select * from ",q,t,q:(" "in t:$y)#"\""}
load:{$[#*f:fkeys[x]'t;f;fkey[k[i;0];u i:&1=#:'k:.q.keys'u]'u]xfkey'(u:.Q.id't).[;();:;]'skey[x]'t:tables x:open x;close x;}

\
\d .
\p 80
\t .odbc.load`northwind
\
.odbc.open"driver=kdb+"
.odbc.load`master.mdf
.odbc.load""
h:.odbc.open`tempdb.mdf
e:.odbc.eval
\
"exec proc"
"create proc .."

10MB per sec.
MSSQL(3MB/sec)

unixODBC ftp://kalamazoolinux.org/pub/pdf/dbaccess.pdf
need to be superuser

you will need at least version 2.2.10 but even this one doesn't support 
unnamed datasource (kdb+ file DSN)
[CC=gcc] ./configure --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib 
[--enable-gui=no]
make
make install

make an entry for each driver that you have in /etc/odbcinst.ini. if you 
have 64bit driver use also "Driver64"
mysql ex:
[MySQL]
Driver = /usr/lib/libmyodbc3.so
Driver64 =

make an entry for each datasource either in /etc/odbc.ini, either in 
~/.odbc.ini but for the driver use the symbolic name declared in 
/etc/odbcinst.ini.
mysql ex:
[assets]
Driver = MySQL
Description = assets
....
