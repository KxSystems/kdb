/ guess a reasonable loadstring for a csv file (kdb+ 2.3 or greater)
/ 2007.03.02 fix invalid JUSTSYMHDRS in savescript when no sym fields
/ 2007.03.01 more bizarre Z possibilities
/ 2007.01.25 -tab
/ 2006.12.25 JUSTSYM
/ 2006.09.17 PRESAVE,POSTLOAD, add saveptn  
/ 2006.09.14 add incremental save option
/ 2006.08.30 add comment on how to save in generated script, allow short MM/DD/YY form rule 16 
/ 2006.08.01 fix saveinfo 
/ 2006.01.28 put back maybe flag 
/ 2006.01.26 add load stats if -bl is used
"kdb+csvguess 0.31 2007.03.02"
o:.Q.opt .z.x;if[1>count .Q.x;-2">q ",(string .z.f)," CSVFILE [-noheader|nh] [-discardempty|de] [-semicolon|sc] [-tab|tb] [-zaphdrs|zh] [-savescript|ss] [-saveinfo|si] [-exit]";exit 1]
/ -noheader|nh - the csv file doesn't have headers, so create some (c00..)
/ -discardempty|de - if a column is empty don't bother to load it 
/ -semicolon|sc - use semicolon as delimiter in place of the default comma
/ -tab|tb - use tab as delimiter in place of default comma
/ -zaphdrs|zh - by default junk characters are removed from column headers, so for example
/ "Profit & Loss_2005" will become "ProfitLoss_2005". Use the zaphdrs flag to force the name to lowercase 
/ and to remove the underscores ("profitloss2005")
/ -savescript|ss - save a standalone load script for the data. Do this manually (perhaps after adjusting 
/ <info>) by calling savescript[]
/ saveinfo|si - *append* the table information to a shared csv - potentially with information from other tables
/ -exit - exit on completion, only makes sense in conjunction with savescript or saveinfo 
/ example:
/ for %1 in (import\*.csv) do q csvguess.q %1 -zh -ss -si -exit

if[(any`semicolon`sc in key o)&any`tab`tb in key o;-2"delimiter: -tab OR -semicolon (default \",\")";exit 1]

FILE:LOADFILE:hsym`${x[where"\\"=x]:"/";x}first .Q.x
NOHEADER:any`noheader`nh in key o
DISCARDEMPTY:any`discardempty`de in key o
DELIM:$[any`semicolon`sc in key o;";";any`tab`tb in key o;"\t";","]
ZAPHDRS:any`zaphdrs`zh in key o
ZAPHDRS:ZAPHDRS and not NOHEADER
SAVESCRIPT:any`savescript`ss in key o
SAVEINFO:any`saveinfo`si in key o
EXIT:`exit in key o
SYMMAXWIDTH:30 / max symbol width before we just give up and keep as * string
SYMMAXGR:10 / max symbol granularity% before we give up and keep as a * string
WIDTHHDR:25000 / initial width read to look for header record
READLINES:2000 / approximate number of records to check
FORCECHARWIDTH:30 / width beyond which we just set a column to be text and finished 
CHUNKSIZE:25000000 / chunksize read when bulk load/save
SAVEDB:`:csvdb / database top level, where things like `:sym live
SAVEPTN:() / individual partition, 2006.12.25 frinstance; () => none
PRESAVE:{x} / function to be run before each incremental save (delete date field?) 
POSTLOAD:{x} / function to be run after each incremental load from file
@[.:;"\\l csvguess.custom.q";::]; / save your custom settings in csvguess.custom.q to override those set above

if[0=hcount LOADFILE;-2"empty file: ",first .Q.x;exit 1]
sample:last head:read0(LOADFILE;0;1+last where"\n"=read1(LOADFILE;0;WIDTHHDR))
readwidth:floor(10+READLINES)*WIDTHHDR%count head 
nas:count as:((1+sum DELIM=first head)#"S";enlist DELIM)0:(LOADFILE;0;1+last where"\n"=read1(LOADFILE;0;readwidth))
if[0=nas;-2"empty file: ",first .Q.x;exit 1]

cancast:{nl:x$"";$[not nl in x$(11&count y)#y;$[11<count y;not nl in x$y;1b];0b]}
k)nameltrim:{$[~@x;.z.s'x;~(*x)in aA:.Q.a,.Q.A;(+/&\~x in aA)_x;x]}

info:([]c:key flip as;v:value flip as);as:()
if[NOHEADER;info:update c:{`$"c",string 1000+x}each i from info]
zh0:{$[(count distinct r)=count r:`$"}"vs 1_x[where(x:raze"}",'nameltrim string x)in"}",.Q.an];r;'`hdrs.not.distinct]} / remove junk chars, leading underscores and spaces, preserve case 
info:update c:zh0 c from info
zh1:{$[(count distinct r)=count r:`$"}"vs 1_x[where(x:raze"}",'string lower x)in"}",.Q.an except"_"];r;'`zaphdrs.not.distinct]} / lowercase and remove underscores
if[ZAPHDRS;info:update c:zh1 c from info]
/ check for reserved words used as colnames
info:update res:c in key`.q from info
/if[.z.K>2.3;info:update res:1b from info where c in .Q.res]
info:update ci:i,t:"?",ipa:0b,mdot:0,mw:0,rule:0,gr:0,ndv:0,maybe:0b from info
info:update ci:`s#ci from info
info:update sdv:{string(distinct x)except`}peach v from info where t="?"
info:update ndv:count each sdv from info where t="?"
info:update gr:floor 0.5+100*ndv%nas,mw:{max count each x}peach sdv from info where t="?",0<ndv
/ rule:1 only in csvutil.q 
info:update t:"*",rule:2 from info where t="?",mw>FORCECHARWIDTH / long values
info:update t:"C "[DISCARDEMPTY],rule:3 from info where t="?",mw=0 / empty columns
info:update dchar:{asc distinct raze x}peach sdv from info where t="?"
info:update mdot:{max sum each"."=x}peach sdv from info where t="?",{"."in x}each dchar
info:update t:"n",rule:4 from info where t="?",{$[any x in"0123456789";all x in".:/-+eE0123456789";0b]}each dchar / vaguely numeric..
info:update t:"I",rule:5,ipa:1b from info where t="n",mw within 7 15,mdot=3,{all x in".0123456789"}each dchar / ip-address
info:update t:"J",rule:6 from info where t="n",mdot=0,{all x in"+-0123456789"}each dchar,cancast["J"]peach sdv
info:update t:"I",rule:7 from info where t="J",mw<10
info:update t:"H",rule:8 from info where t="I",mw<5
info:update t:"M",rule:9,maybe:1b from info where t="I",mw=6,cancast["M"]peach sdv / 200506, YYYYMM is less likely than [H]HMMSS so do that first 
info:update t:"V",rule:10,maybe:1b from info where t="I",mw in 5 6,7<count each dchar,{all x like"*[0-9][0-5][0-9][0-5][0-9]"}peach sdv / 235959 12345        
info:update t:"U",rule:11,maybe:1b from info where t="H",mw in 3 4,7<count each dchar,{all x like"*[0-9][0-5][0-9]"}peach sdv /2359
info:update t:"F",rule:12,maybe:0b from info where t="n",mdot<2,mw>1,{all x in".+-eE0123456789"}each dchar,cancast["F"]peach sdv
info:update t:"E",rule:13,maybe:0b from info where t="F",mw<8,cancast["E"]peach sdv / need to check for "1e40" etc
info:update t:"M",rule:14,maybe:1b from info where t="E",mw=7,cancast["M"]peach sdv / 2005.06 
info:update t:"M",rule:15,maybe:0b from info where t="n",mw=7,mdot=0,cancast["M"]peach sdv / 2005/06 2005-06
info:update t:"D",rule:16,maybe:0b from info where t="n",mw in 6 7 8 10,mdot in 0 2,cancast["D"]peach sdv / 2005.06.07 2005/06/07 2005-06-07
info:update t:"D",rule:17,maybe:1b from info where t="I",mw=8,cancast["D"]peach sdv / 20050607
info:update t:"D",rule:18,maybe:0b from info where t="?",mw in 7 9 11,mdot in 0 2,cancast["D"]peach sdv / 29oct2005 29oct05 etc
info:update t:"U",rule:19,maybe:0b from info where t="n",mw in 4 5,mdot=0,{all x like"*[0-9]:[0-5][0-9]"}peach sdv
info:update t:"T",rule:20,maybe:0b from info where t="n",mw within 7 12,mdot<2,{all x like"*[0-9]:[0-5][0-9]:[0-5][0-9]*"}peach sdv
info:update t:"V",rule:21,maybe:0b from info where t="T",mw in 7 8,mdot=0
/ info:update t:"Z",rule:22,maybe:0b from info where t="n",mw within 19 23,mdot<4,{$[all x in"0123456789.:T- ";2<sum".:T -"in x;0b]}each dchar,cancast["Z"]peach sdv
info:update t:"Z",rule:22,maybe:0b from info where t in"n?",mw within 11 24,mdot<4,{$[all x in"0123456789.:ABCDEFGJLMNOPRSTUVYabcdefgjlmnoprstuvy/- ";1<sum".:/ T-"in x;0b]}each dchar,cancast["Z"]peach sdv
info:update t:"?",rule:23,maybe:0b from info where t="n" / reset remaining maybe numeric
info:update t:"C",rule:24,maybe:0b from info where t="?",mw=1 / char
info:update t:"B",rule:25,maybe:0b from info where t in"?IHC",mw=1,mdot=0,{$[all x in" 01tTfFyYnN";(any" 0fFnN"in x)and any"1tTyY"in x;0b]}each dchar / boolean
info:update t:"X",rule:26,maybe:0b from info where t="?",mw=2,{$[all x in"0123456789ABCDEF";(any .Q.n in x)and any"ABCDEF"in x;0b]}each dchar /hex
info:update t:"S",rule:27,maybe:1b from info where t="?",mw<SYMMAXWIDTH,mw>1,gr<SYMMAXGR / symbols (max width permitting)
info:update t:"*",rule:28,maybe:0b from info where t="?" / the rest as strings
info:update maybe:1b from info where mw>4,not t="D",(lower c)like"*date*"
info:update maybe:1b from info where mw>1,not t in"TUV",(lower c)like"*time*"
/ flag those S/* columns which could be encoded to integers (.Q.j10/x10/j12/x12) to avoid symbols
info:update j10:0b,j12:0b from info
info:update j12:1b from info where t in"S*",mw<13,{all x in .Q.nA}each dchar
info:update j10:1b from info where t in"S*",mw<11,{all x in .Q.b6}each dchar 
if["?"in exec t from info;'`unknown.field]; / check all done

info:select c,ci,t,maybe,res,j10,j12,ipa,mw,mdot,rule,gr,ndv,dchar from info
/ make changes to <info> and they'll be picked up correctly, test with: show LOAD10 LOADFILE, or sba[]
/ update t:" " from`info where not t="S" / only load symbols
/ update t:"*" from`info where t="S" / load all char as strings, no need to enumerate before save
/ run savescript[] when results are correct

LOADNAME:`${x where((first x)in .Q.a),1_ x in .Q.an}lower first"."vs last"/"vs 1_string LOADFILE
LOADFMTS:raze exec t from`ci xasc select ci,t from info
JUSTSYMFMTS:{x[where not x="S"]:" ";x}LOADFMTS
LOADHDRS:exec c from`ci xasc select ci,c from info where not t=" "
JUSTSYMHDRS:LOADHDRS where LOADFMTS="S"
LOADDEFN:{(LOADFMTS;$[NOHEADER;DELIM;enlist DELIM])}
JUSTSYMDEFN:{(JUSTSYMFMTS;$[NOHEADER;DELIM;enlist DELIM])}
/DATA:LOAD LOADFILE / for files loadable in one go
LOAD:{[file] POSTLOAD$[NOHEADER;flip LOADHDRS!LOADDEFN[]0:;LOADHDRS xcol LOADDEFN[]0:]file}
/(10#DATA):LOAD10 LOADFILE / load just the first 10 rows, convenient when debugging column types
LOAD10:{[file] LOAD(file;0;1+last(11-NOHEADER)#where"\n"=read1(file;0;20000))}
SAVE:{(` sv SAVEDB,SAVEPTN,LOADNAME,`)set PRESAVE .Q.en[SAVEDB] x}
DATA:() / delete from`DATA
k)fs2:{[f;s]((-7!s)>){[f;s;x]i:1+last@&"\n"=r:1:(s;x;CHUNKSIZE);f@`\:i#r;x+i}[f;s]/0j} / .Q.fs with bigger chunks
BULKLOAD:{[file] fs2[{`DATA insert POSTLOAD$[NOHEADER or count DATA;flip LOADHDRS!(LOADFMTS;DELIM)0:x;LOADHDRS xcol LOADDEFN[]0: x]}file];count DATA}
BULKSAVE:{[file] .tmp.bsc:0;fs2[{.[` sv SAVEDB,SAVEPTN,LOADNAME,`;();,;]PRESAVE t:.Q.en[SAVEDB]POSTLOAD$[NOHEADER or .tmp.bsc;flip LOADHDRS!(LOADFMTS;DELIM)0:x;LOADHDRS xcol LOADDEFN[]0: x];.tmp.bsc+:count t}]file;.tmp.bsc}
JUSTSYM:{[file] .tmp.jsc:0;fs2[{.tmp.jsc+:count .Q.en[SAVEDB]POSTLOAD$[NOHEADER or .tmp.jsc;flip JUSTSYMHDRS!(JUSTSYMFMTS;DELIM)0:x;JUSTSYMHDRS xcol JUSTSYMDEFN[]0: x]}]file;.tmp.jsc}

/ create a standalone load script - savescript[]
/ call it with:
/ q xxx.q / to define all the necessary functions and variables 
/ q xxx.q FILENAME  / to define the global FILE as <FILENAME>
/ q xxx.q FILENAME -bl / to bulkload FILENAME to DATA
/ q xxx.q -bl / to bulkload original filename (LOADFILE) to DATA
/ q xxx.q -bs / to bulksave original filename to directory SAVEDB
/ q xxx.q -bs -savedb foo / to bulksave original filename to directory foo
/ q xxx.q FILENAME -bs -savedb foo / to bulksave FILENAME to directory foo
/ q xxx.q FILENAME -js -savedb foo / to just save the symbols from FILENAME to directory foo (allow parallel load+save thereafter)
/ q xxx.q FILENAME -bs -savedb foo -saveptn 2006.12.25 / to bulksave FILENAME to directory foo in the 2006.12.25 date partition
/ q xxx.q ... -exit / exit on completion of commands (only makes sense with -bs and -js)
savescript:{f:`$":",(string LOADNAME),".load.q";f 1:"";hs:neg hopen f;
	hs"/ ",(string .z.z)," ",(string .z.h)," ",(string .z.u);
	hs"/ q ",(string LOADNAME),".load.q FILE [-bl|bulkload] [-bs|bulksave] [-js|justsym] [-exit] [-savedb SAVEDB] [-saveptn SAVEPTN] ";
	hs"/ q ",(string LOADNAME),".load.q FILE";
	hs"/ q ",(string LOADNAME),".load.q";
	hs"FILE:LOADFILE:`$\"",(string LOADFILE),"\"";
	hs"o:.Q.opt .z.x;if[count .Q.x;FILE:hsym`${x[where\"\\\\\"=x]:\"/\";x}first .Q.x]";
	hs"SAVEDB:",-3!SAVEDB;hs"SAVEPTN:",-3!SAVEPTN;
	hs"if[`savedb in key o;if[count first o[`savedb];SAVEDB:hsym`$first o[`savedb]]]";
	hs"if[`saveptn in key o;if[count first o[`saveptn];SAVEPTN:`$first o[`saveptn]]]";
	hs"NOHEADER:",-3!NOHEADER;hs"DELIM:",-3!DELIM;
	hs"\\z ",(string system"z")," / D date format 0 => mm/dd/yyyy or 1 => dd/mm/yyyy (yyyy.mm.dd is always ok)";
	hs"LOADNAME:",-3!LOADNAME;hs"LOADFMTS:\"",LOADFMTS,"\"";hs"LOADHDRS:",raze"`",'string LOADHDRS;
	hs"LOADDEFN:",-3!LOADDEFN;hs"POSTLOAD:",-3!POSTLOAD;hs"LOAD:",-3!LOAD;hs"LOAD10:",(-3!LOAD10)," / just load first 10 records";
	hs"JUSTSYMFMTS:\"",JUSTSYMFMTS,"\"";hs"JUSTSYMHDRS:",$[0=count JUSTSYMHDRS;"0#`";raze"`",'string JUSTSYMHDRS];
	hs"JUSTSYMDEFN:",-3!JUSTSYMDEFN;
	hs"CHUNKSIZE:",string CHUNKSIZE;hs"DATA:()";
	hs"k)fs2:",2_ last value fs2;
	hs"BULKLOAD:",-3!BULKLOAD;hs"PRESAVE:",-3!PRESAVE;hs"SAVE:",-3!SAVE;hs"BULKSAVE:",-3!BULKSAVE;hs"JUSTSYM:",-3!JUSTSYM;
	hs"if[any`js`justsym in key o;-1(string`second$.z.z),\" saving `sym for \",(1_string FILE),\" to directory \",1_string SAVEDB;.tmp.st:`time$.z.z;.tmp.rc:JUSTSYM FILE;.tmp.et:`time$.z.z;.tmp.fs:hcount FILE;-1(string`second$.z.z),\" done (\",(string .tmp.rc),\" records; \",(string floor .tmp.rc%1e-3*.tmp.et-.tmp.st),\" records/sec; \",(string floor 0.5+.tmp.fs%1e3*.tmp.et-.tmp.st),\" MB/sec)\"]";
	hs"if[any`bs`bulksave in key o;-1(string`second$.z.z),\" saving \",(1_string FILE),\" to directory \",1_string` sv SAVEDB,SAVEPTN,LOADNAME;.tmp.st:`time$.z.z;.tmp.rc:BULKSAVE FILE;.tmp.et:`time$.z.z;.tmp.fs:hcount FILE;-1(string`second$.z.z),\" done (\",(string .tmp.rc),\" records; \",(string floor .tmp.rc%1e-3*.tmp.et-.tmp.st),\" records/sec; \",(string floor 0.5+.tmp.fs%1e3*.tmp.et-.tmp.st),\" MB/sec)\"]";
	hs"if[any`bl`bulkload in key o;-1(string`second$.z.z),\" loading \",(1_string FILE),\" to variable DATA\";.tmp.st:`time$.z.z;BULKLOAD FILE;.tmp.et:`time$.z.z;.tmp.rc:count DATA;.tmp.fs:hcount FILE;-1(string`second$.z.z),\" done (\",(string .tmp.rc),\" records; \",(string floor .tmp.rc%1e-3*.tmp.et-.tmp.st),\" records/sec; \",(string floor 0.5+.tmp.fs%1e3*.tmp.et-.tmp.st),\" MB/sec)\"]";
	hs"if[`exit in key o;exit 0]";
	hs"/ DATA:(); BULKLOAD LOADFILE / incremental load all to DATA";
	hs"/ BULKSAVE LOADFILE / incremental save all to SAVEDB[/SAVEPTN]";
	hs"/ DATA:LOAD10 LOADFILE / only load the first 10 rows";
	hs"/ DATA:LOAD LOADFILE / load all in one go";
	hs"/ SAVE LOAD LOADFILE / save all in one go to SAVEDB[/SAVEPTN]";
	hclose neg hs;f}
if[SAVESCRIPT;-1"* savescript file ",(1_string savescript[])," written"]

/ save (append) info about the csv columns to INFOFILE - saveinfo[]
/ tbl -tablename; c - column name; ci - column index in csv; t - load type
/ maybe - set if type is a guess based on name+content (M/D/V/U) or could-be symbol
/ mw - maxwidth; j10,j12 - could be encoded using .Q.j10/j12; ipa - ip-address
/ gr - granularity% of unique values; dchar - distinct characters
/ info:getinfo[]; update multi:c in exec c from(select count i by c from info)where x>1 from`info
INFOFILE:`$":",(lower first"."vs last"/"vs string .z.f),".info.csv"
INFOFMTS:"SSICBBIBBBIS"
readinfo:{(INFOFMTS;enlist",")0:INFOFILE}
saveinfo:{savedinfo:$[@[hcount;INFOFILE;0j];(INFOFMTS;enlist",")0:INFOFILE;()];
	if[count savedinfo;savedinfo:delete from savedinfo where tbl=LOADNAME];
	savedinfo,:select tbl:LOADNAME,c,ci,t,maybe,res,mw,j10,j12,ipa,gr,`$dchar from info;
	(`$(string INFOFILE),".load.q")1:"info:(",(-3!INFOFMTS),";enlist\",\")0:`$\"",(string INFOFILE),"\"\n";
	INFOFILE 0:.h.cd`tbl`c xasc savedinfo;INFOFILE}
if[SAVEINFO;-1"* saveinfo file ",(1_string saveinfo[])," updated"]
if[EXIT;exit 0]

sba:{show update before:(({x[where not x=" "]:"*";x}LOADFMTS;DELIM)0:sample),after:(LOADFMTS;DELIM)0:sample from select c,t from info} / show before+after
\
show delete dv from info
show first LOAD10 FILE
show select from (delete dv from info) where maybe
_string saveinfo[])," updated"]
if[EXIT;exit 0]

sba:{show update before:(({x[where not x=" "]:"*";x}LOADFMTS;DELIM)0:sample),after:(LOADFMTS;DELIM)0:sample from select c,t from info} / show before+after
\
show delete dv from info
show first LOAD10 FILE
show select from (delete dv from info) where maybe
