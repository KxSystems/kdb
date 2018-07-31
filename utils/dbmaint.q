/ kdb+ partitioned database maintenance
\d .os
WIN:.z.o in`w32`w64
pth:{p:$[10h=type x;x;string x];if[WIN;p[where"/"=p]:"\\"];(":"=first p)_ p}
cpy:{system$[WIN;"copy /v /z ";"cp "],pth[x]," ",pth y}
del:{system$[WIN;"del ";"rm "],pth x}
ren:{system$[WIN;"move ";"mv "],pth[x]," ",pth y}
here:{hsym`$system$[WIN;"cd";"pwd"]}
\d .

add1col:{[tabledir;colname;defaultvalue]
 if[not colname in ac:allcols tabledir;
  stdout"adding column ",(string colname)," (type ",(string type defaultvalue),") to `",string tabledir;
  num:count get(`)sv tabledir,first ac;
  .[(`)sv tabledir,colname;();:;num#defaultvalue];
  @[tabledir;`.d;,;colname]]}

allcols:{[tabledir]get tabledir,`.d}

allpaths:{[dbdir;table]
 files:key dbdir;
 if[any files like"par.txt";:raze allpaths[;table]each hsym each`$read0(`)sv dbdir,`par.txt];
 files@:where files like"[0-9]*";(`)sv'dbdir,'files,'table}

copy1col:{[tabledir;oldcol;newcol]
 if[(oldcol in ac)and not newcol in ac:allcols tabledir;
  stdout"copying ",(string oldcol)," to ",(string newcol)," in `",string tabledir;
  .os.cpy[(`)sv tabledir,oldcol;(`)sv tabledir,newcol];@[tabledir;`.d;,;newcol]]}

delete1col:{[tabledir;col]
 if[col in ac:allcols tabledir;
  stdout"deleting column ",(string col)," from `",string tabledir;
  .os.del[(`)sv tabledir,col];@[tabledir;`.d;:;ac except col]]}

/
enum:{[tabledir;val]
 if[not 11=abs type val;:val];
 .[p;();,;u@:iasc u@:where not(u:distinct enlist val)in v:$[type key p:(`)sv tabledir,`sym;get p;0#`]];`sym!(v,u)?val}
\

enum:{[tabledir;val]if[not 11=abs type val;:val];.Q.dd[tabledir;`sym]?val}


find1col:{[tabledir;col]
 $[col in allcols tabledir;
   stdout"column ",string[col]," (type ",(string first"i"$read1((`)sv tabledir,col;8;1)),") in `",string tabledir;
   stdout"column ",string[col]," *NOT*FOUND* in `",string tabledir]}

fix1table:{[tabledir;goodpartition;goodpartitioncols]
 if[count missing:goodpartitioncols except allcols tabledir;
  stdout"fixing table `",string tabledir;{add1col[x;z;0#get y,z]}[tabledir;goodpartition]each missing]}

fn1col:{[tabledir;col;fn]
 if[col in allcols tabledir;
  oldattr:-2!oldvalue:get p:tabledir,col;
  newattr:-2!newvalue:fn oldvalue;		
  if[$[not oldattr~newattr;1b;not oldvalue~newvalue];
   stdout"resaving column ",(string col)," (type ",(string type newvalue),") in `",string tabledir;
   oldvalue:0;.[(`)sv p;();:;newvalue]]]}

reordercols0:{[tabledir;neworder]
 if[not((count ac)=count neworder)or all neworder in ac:allcols tabledir;'`order];
 stdout"reordering columns in `",string tabledir;
 @[tabledir;`.d;:;neworder]}

rename1col:{[tabledir;oldname;newname]
 if[(oldname in ac)and not newname in ac:allcols tabledir;
  stdout"renaming ",(string oldname)," to ",(string newname)," in `",string tabledir;
  .os.ren[` sv tabledir,oldname;` sv tabledir,newname];@[tabledir;`.d;:;.[ac;where ac=oldname;:;newname]]]}

ren1table:{[old;new]stdout"renaming ",(string old)," to ",string new;.os.ren[old;new];}

add1table:{[dbdir;tablename;table]
 stdout"adding ",string tablename;
 @[tablename;`;:;.Q.en[dbdir]0#table];}

stdout:{-1 raze[" "sv string`date`second$.z.P]," ",x;}
validcolname:{(not x in `i,.Q.res,key`.q)and x = .Q.id x}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// * public

thisdb:`:. / if functions are to be run within the database instance then use <thisdb> (`:.) as dbdir

addcol:{[dbdir;table;colname;defaultvalue] / addcol[`:/data/taq;`trade;`noo;0h]
 if[not validcolname colname;'(`)sv colname,`invalid.colname];
  add1col[;colname;enum[dbdir;defaultvalue]]each allpaths[dbdir;table];}

castcol:{[dbdir;table;col;newtype] / castcol[thisdb;`trade;`size;`short]
 fncol[dbdir;table;col;newtype$]}

clearattrcol:{[dbdir;table;col] / clearattr[thisdb;`trade;`sym]
 setattrcol[dbdir;table;col;(`)]}

copycol:{[dbdir;table;oldcol;newcol] / copycol[`:/k4/data/taq;`trade;`size;`size2]
 if[not validcolname newcol;'(`)sv newcol,`invalid.newname];
 copy1col[;oldcol;newcol]each allpaths[dbdir;table];}

deletecol:{[dbdir;table;col] / deletecol[`:/k4/data/taq;`trade;`iz]
 delete1col[;col]each allpaths[dbdir;table];}

findcol:{[dbdir;table;col] / findcol[`:/k4/data/taq;`trade;`iz]
 find1col[;col]each allpaths[dbdir;table];}

/ adds missing columns, but DOESN'T delete extra columns - do that manually
fixtable:{[dbdir;table;goodpartition] / fixtable[`:/k4/data/taq;`trade;`:/data/taq/2005.02.19]
 fix1table[;goodpartition;allcols goodpartition]each allpaths[dbdir;table]except goodpartition;}

fncol:{[dbdir;table;col;fn] / fncol[thisdb;`trade;`price;2*]
 fn1col[;col;fn]each allpaths[dbdir;table];}

listcols:{[dbdir;table] / listcols[`:/k4/data/taq;`trade]
 allcols first allpaths[dbdir;table]}

renamecol:{[dbdir;table;oldname;newname] / renamecol[`:/k4/data/taq;`trade;`woz;`iz]
 if[not validcolname newname;'` sv newname,`invalid.newname];
 rename1col[;oldname;newname]each allpaths[dbdir;table];}

reordercols:{[dbdir;table;neworder] / reordercols[`:/k4/data/taq;`trade;reverse cols trade]
 reordercols0[;neworder]each allpaths[dbdir;table];}

setattrcol:{[dbdir;table;col;newattr] / setattr[thisdb;`trade;`sym;`g] / `s `p `u
 fncol[dbdir;table;col;newattr#]}

addtable:{[dbdir;tablename;table] / addtable[`:.;`trade;([]price...)]
 add1table[dbdir;;table]each allpaths[dbdir;tablename];}

rentable:{[dbdir;old;new] / rentable[`:.;`trade;`transactions]
 ren1table'[allpaths[dbdir;old];allpaths[dbdir;new]];}

\
test with https://github.com/KxSystems/kdb/blob/master/tq.q (sample taq database)

if making changes to current database you need to reload (\l .) to make modifications visible

if the database you've been modifying is a tick database don't forget to adjust the schema (tick/???.q) to reflect your changes to the data


addcol[`:.;`trade;`num;10]
addcol[`:.;`trade;`F;`test]
delete1col[`:./2000.10.02/trade;`F]
fixtable[`:.;`trade;`:./2000.10.03/trade]
reordercols[`:.;`quote;except[2 rotate cols quote;`date]]
clearattrcol[`:.;`trade;`sym]
setattrcol[`:.;`trade;`sym;`p]
castcol[`:.;`trade;`time;`second]
renamecol[`:.;`trade;`price;`PRICE]
pxcols:{(y,())renamecol[`:.;x]'z,()]
`PRICE`size renamecol[`:.;`trade]'`p`s
