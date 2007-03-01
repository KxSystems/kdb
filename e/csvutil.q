/ utilities to quickly load a csv file - for more exhaustive analysis of the csv contents see csvguess.q
/ .csv.colhdrs[file] - return a list of colhdrs from file
/ info:.csv.info[file] - return a table of information about the file
/ columns are: 
/	c - column name; ci - column index; t - load type; mw - max width; 
/	dchar - distinct characters in values; rule - rule that caught the type
/	maybe - needs checking, _could_ be say a date, but perhaps just a float?
/ .csv.info0[file;onlycols] - like .csv.info except that it only analyses <onlycols>
/ example:
/	info:.csv.info0[file;(.csv.colhdrs file)like"*price"]
/	info:.csv.infolike[file;"*price"]
/	show delete from info where t=" "
/ .csv.data[file;info] - use the info from .csv.info to read the data
/ .csv.data10[file;info] - like .csv.data but only returns the first 10 rows
/ bulkload[file;info] - bulk loads file into table DATA (which must be already defined :: DATA:() )
/ .csv.read[file]/read10[file] - for when you don't care about checking/tweaking the <info> before reading 

\d .csv
DELIM:","
ZAPHDRS:0b / lowercase and remove _ from colhdrs (junk characters are always removed)
WIDTHHDR:1000 / number of characters read to get the header
READLINES:100 / number of lines read and used to guess the types
SYMMAXWIDTH:11 / character columns narrower than this are stored as symbols
FORCECHARWIDTH:30 / every field (of any type) with values this wide or more is forced to character "*"
DISCARDEMPTY:0b / completely ignore empty columns if true else set them to "C"

k)nameltrim:{$[~@x;.z.s'x;~(*x)in aA:.Q.a,.Q.A;(+/&\~x in aA)_x;x]}
cleanhdrs:{{$[ZAPHDRS;lower x except"_";x]}x where x in DELIM,.Q.an}
cancast:{nl:x$"";$[not nl in x$(11&count y)#y;$[11<count y;not nl in x$y;1b];0b]}

read:{[file]data[file;info[file]]}  
read10:{[file]data10[file;info[file]]}  

colhdrs:{[file]
	`$nameltrim DELIM vs cleanhdrs first read0(file;0;1+first where"\n"=read1(file;0;WIDTHHDR))}
data:{[file;info]
	(exec c from info where not t=" ")xcol(exec t from info;enlist DELIM)0:file}
data10:{[file;info]
	data[;info](file;0;1+last 11#where"\n"=read1(file;0;15*WIDTHHDR))}
info0:{[file;onlycols]
	colhdrs:`$nameltrim DELIM vs cleanhdrs first head:read0(file;0;1+last where"\n"=read1(file;0;WIDTHHDR));
	loadfmts:(count colhdrs)#"S";if[count onlycols;loadfmts[where not colhdrs in onlycols]:"C"];
	breaks:where"\n"=read1(file;0;floor(10+READLINES)*WIDTHHDR%count head);
	as:colhdrs xcol(loadfmts;enlist DELIM)0:(file;0;1+last((1+READLINES)&count breaks)#breaks);
	info:([]c:key flip as;v:value flip as);as:();
	info:update ci:i,t:"?",mdot:0,mw:0,rule:0,ipa:0b,maybe:0b from info;
	info:update ci:`s#ci from info;
	if[count onlycols;info:update t:" ",rule:1 from info where not c in onlycols];
	info:update sdv:{string(distinct x)except`}peach v from info where t="?"; 
	info:update mw:{max count each x}peach sdv from info where t="?",0<count each sdv;
	info:update t:"*",rule:2 from info where t="?",mw>.csv.FORCECHARWIDTH; / long values
	info:update t:"C "[.csv.DISCARDEMPTY],rule:3 from info where t="?",mw=0; / empty columns
	info:update dchar:{asc distinct raze x}peach sdv from info where t="?";
	info:update mdot:{max sum each"."=x}peach sdv from info where t="?",{"."in x}each dchar;
	info:update t:"n",rule:4 from info where t="?",{$[any x in"0123456789";all x in".:/-+eTE0123456789 ";0b]}each dchar; / vaguely numeric..
	info:update t:"I",rule:5,ipa:1b from info where t="n",mw within 7 15,mdot=3,{all x in".0123456789"}each dchar; / ip-address
	info:update t:"J",rule:6 from info where t="n",mdot=0,{all x in"+-0123456789"}each dchar,.csv.cancast["J"]peach sdv;
	info:update t:"I",rule:7 from info where t="J",mw<10;
    info:update t:"H",rule:8 from info where t="I",mw<5;
	info:update t:"M",rule:9,maybe:1b from info where t="I",mw=6,.csv.cancast["M"]peach sdv; / 200506, YYYYMM is less likely than [H]HMMSS so do that first 
	info:update t:"V",rule:10,maybe:1b from info where t="I",mw in 5 6,7<count each dchar,{all x like"*[0-9][0-5][0-9][0-5][0-9]"}peach sdv; / 235959 12345 
	info:update t:"U",rule:11,maybe:1b from info where t="H",mw in 3 4,7<count each dchar,{all x like"*[0-9][0-5][0-9]"}peach sdv; /2359                
	info:update t:"F",rule:12,maybe:0b from info where t="n",mdot<2,mw>1,{all x in".+-eE0123456789"}each dchar,.csv.cancast["F"]peach sdv;
	info:update t:"E",rule:13,maybe:0b from info where t="F",mw<8,.csv.cancast["E"]peach sdv; / need to check for "1e40" etc
	info:update t:"M",rule:14,maybe:1b from info where t="E",mw=7,.csv.cancast["M"]peach sdv; / 2005.06 
	info:update t:"M",rule:15,maybe:0b from info where t="n",mw=7,mdot=0,.csv.cancast["M"]peach sdv; / 2005/06 2005-06
	info:update t:"D",rule:16,maybe:0b from info where t="n",mw in 6 7 8 10,mdot in 0 2,.csv.cancast["D"]peach sdv; / 2005.06.07 2005/06/07 2005-06-07
	info:update t:"D",rule:17,maybe:1b from info where t="I",mw=8,.csv.cancast["D"]peach sdv; / 20050607  
	info:update t:"D",rule:18,maybe:0b from info where t="?",mw in 7 9 11,mdot in 0 2,.csv.cancast["D"]peach sdv; / 29oct2005 29oct05 etc
	info:update t:"U",rule:19,maybe:0b from info where t="n",mw in 4 5,mdot=0,{all x like"*[0-9]:[0-5][0-9]"}peach sdv;
	info:update t:"T",rule:20,maybe:0b from info where t="n",mw within 7 12,mdot<2,{all x like"*[0-9]:[0-5][0-9]:[0-5][0-9]*"}peach sdv;
	info:update t:"V",rule:21,maybe:0b from info where t="T",mw in 7 8,mdot=0;
	info:update t:"Z",rule:22,maybe:0b from info where t="n",mw within 19 23,mdot<4,{$[all x in"0123456789.:T- ";2<sum".:T -"in x;0b]}each dchar,.csv.cancast["Z"]peach sdv;
	info:update t:"?",rule:23,maybe:0b from info where t="n"; / reset remaining maybe numeric
	info:update t:"C",rule:24,maybe:0b from info where t="?",mw=1; / char
	info:update t:"B",rule:25,maybe:0b from info where t in"?IHC",mw=1,mdot=0,{$[all x in" 01tTfFyYnN";(any" 0fFnN"in x)and any"1tTyY"in x;0b]}each dchar; / boolean
	info:update t:"X",rule:26,maybe:0b from info where t="?",mw=2,{$[all x in"0123456789ABCDEF";(any .Q.n in x)and any"ABCDEF"in x;0b]}each dchar; /hex
	info:update t:"S",rule:27,maybe:1b from info where t="?",mw<.csv.SYMMAXWIDTH,mw>1; / symbols (max width permitting)
	info:update t:"*",rule:28,maybe:0b from info where t="?"; / the rest as strings
	info:update maybe:1b from info where mw>4,not t="D",(lower c)like"*date*";
	info:update maybe:1b from info where mw>1,not t in"TUV",(lower c)like"*time*";
	select c,ci,t,maybe,ipa,mw,rule,dchar from info}
info:info0[;()] / by default don't restrict columns
infolike:{[file;pattern] info0[file;{x where x like y}[colhdrs[file];pattern]]} / .csv.infolike[file;"*time"]

\d .
/ DATA:()
bulkload:{[file;info]
	if[not`DATA in system"v";'`DATA.not.defined];
	if[count DATA;'`DATA.not.empty];
	loadhdrs:exec c from info where not t=" ";loadfmts:exec t from info;
	.Q.fs[{[file;loadhdrs;loadfmts] `DATA insert $[count DATA;flip loadhdrs!(loadfmts;.csv.DELIM)0:file;loadhdrs xcol(loadfmts;enlist .csv.DELIM)0:file]}[file;loadhdrs;loadfmts]];
	count DATA}
@[.:;"\\l csvutil.custom.q";::]; / save your custom settings in csvutil.custom.q to override those set at the beginning of the file 
l(loadfmts;enlist .csv.DELIM)0:file]}[file;loadhdrs;loadfmts]];
	count DATA}
@[.:;"\\l csvutil.custom.q";::]; / save your custom settings in csvutil.custom.q to override those set at the beginning of the file 
