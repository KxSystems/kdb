/ bcp -c   for import/export e.g.

\l c/odbc.k
e:.odbc.eval1 .odbc.open`mqis

/get 4MB/sec \t t:e"select*from t" /8MB/sec
g:{d:flip e"select*from ",(s:string x)," where 0=1";
 system"bcp model..",s," out t.bcp -c -T";
 x set flip key[d]!("*"^.Q.ty each value d;"\t")0:`t.bcp}

/set 2MB/sec t:list`s`b`h`i`j`e`f`z`C!(`$t;1b;23h;12341234;23j;23e;23f;2001.02.03T12:34:56;t:"asasdfafs")
s:{c:{string[x]," ",string[.o.T t],$[11=t:type y;"(",string[1|max(count string@)each y],")";""]};
 @[e;"drop table ",s:string x;::];e"create table ",s,"(",(","sv key[d]c'x:value d:flip value x),")";
 `t.bcp 0:"\t"0:x;system"bcp model..",s," in t.bcp -c -T";}