/ help.q 2006.08.27T20:13:20.813
\d .help
DIR:TXT:()!()
display:{if[not 10h=abs type x;x:string x];$[1=count i:where(key DIR)like x,"*";-1 each TXT[(key DIR)[i]];show DIR];}
fetch:{if[not 10h=abs type x;x:string x];$[1=count i:where(key DIR)like x,"*";1_raze"\n",'TXT[(key DIR)[first i]];DIR]}
TXT,:(enlist`adverb)!enlist(
 "'    eachboth    each";
 "/    [x]over     over(:+*&|,)   [x]do/while";
 "\\    [x]scan     scan(:+*&|,)   [x]do\\while";
 "':   [x]prior    prior(:-%)";
 "/:   eachright   sv(i:i/:I s:`/:S C:c/:L) j:0x40/:X i:0x0/:X";
 "\\:   eachleft    vs(I:i\\:i S:`\\:s L:c\\:C) X:0x40\\:j X:0x0\\:i"
 )
DIR,:(enlist`adverb)!enlist`$"adverbs/operators"
TXT,:(enlist`attributes)!enlist(
 "example           overhead ";
 "`s#2 2 3 sorted   0 ";
 "`u#2 4 5 unique   16*u ";
 "`p#2 2 1 parted   (4*u;16*u;4*u+1) ";
 "`g#2 1 2 grouped  (4*u;16*u;4*u+1;4*n)";
 "";
 "The byte overheads use n(number of elements) and u(number of uniques)";
 "`u is for unique lists.";
 "`p and `g are for lists with a lot of repetition.";
 "";
 "`s#, `u# and `g# are preserved on append in memory (if possible)";
 "only `s# is preserved on append to disk"
 )
DIR,:(enlist`attributes)!enlist`$"data attributes"
TXT,:(enlist`cmdline)!enlist(
 "q [f] [-c h w] [-C h w] [-l|L] [-o N] [-p N] [-P N] [-r|R :H:P] [-s N] [-t N]";
 "      [-T N] [-u|U F] [-w N] [-W N] [-z 0|1]";
 "";
 "f load script (*.q, *.k, *.s), file or directory";
 "";
 "-c height width  console x and y, default 23 79";
 "-C height width  webbrowser x and y, default 36 2000";
 "-l               log updates to filesystem ";
 "-L               as -l, but sync";
 "-o N             offset hours (from GMT: affects .z.Z)";
 "-p N             port kdbc(/jdbc/odbc) http(html xml txt csv)";
 "-P N             printdigits, default 7, 0=>all";
 "-r :H:P          replicate from :host:port ";
 "-R :H:P          as -r, but sync";
 "-s N             slaves for parallel execution";
 "-t N             timer milliseconds";
 "-T N             timeout seconds(applies to all client queries)";
 "-u F             usr:pwd file, no access above start directory";
 "-U F             as -u, but no file restrictions";
 "-w N             workspace MB limit (default: 2*RAM)";
 "-W N             week offset, default 2, 0=>saturday";
 "-z B             \"D\" uses 0:mm/dd/yyyy or 1:dd/mm/yyyy, default 0"
 )
DIR,:(enlist`cmdline)!enlist`$"command line parameters"
TXT,:(enlist`data)!enlist(
 "char-size--type-literal-------q---------sql--------java-------.net---  ";
 "b    1     1    0b            boolean              Boolean    boolean   ";
 "x    1     4    0x0           byte                 Byte       byte      ";
 "h    2     5    0h            short     smallint   Short      int16     ";
 "i    4     6    0             int       int        Integer    int32     ";
 "j    8     7    0j            long      bigint     Long       int64     ";
 "e    4     8    0e            real      real       Float      single    ";
 "f    8     9    0.0           float     float      Double     double    ";
 "c    1     10   \" \"           char                 Character  char";
 "s    .     11   `             symbol    varchar    String     string    ";
 "m    4     13   2000.01m      month";
 "d    4     14   2000.01.01    date      date       Date                 ";
 "z    8     15   dateTtime     datetime  timestamp  Timestamp  DateTime  ";
 "u    4     17   00:00         minute";
 "v    4     18   00:00:00      second";
 "t    4     19   00:00:00.000  time      time       Time       TimeSpan ";
 "*    4     20.. `s$`          enum";
 "           98                 table";
 "           99                 dict";
 "           100                lambda";
 "           101                unary prim";
 "           102                binary prim";
 "           103                ternary(operator)";
 "           104                projection";
 "           105                composition";
 "           106                f'";
 "           107                f/";
 "           108                f\\";
 "           109                f':";
 "           110                f/:";
 "           111                f\\:";
 "           112                dynamic load";
 "";
 "`char$data `CHAR$string";
 "";
 "The int, float, char and symbol literal nulls are: 0N 0n \" \" `.";
 "The rest use type extensions, e.g. 0Nd. No null for boolean or byte.";
 "0Wd 0Wz 0Wt  placeholder infinite dates/times/datetimes (no math)";
 "";
 "date.(year month week mm dd)";
 "dict:`a`b!.. table:([]x:..;y:..) or +`x`y!..";
 "time.(minute second mm ss) milliseconds=time mod 1000"
 )
DIR,:(enlist`data)!enlist`$"data types"
TXT,:(enlist`define)!enlist(
 "Dyad------------D-Amend---------Monad-----------M-amend------";
 "v:y             .[`v;();:;y]";
 "v+:y            .[`v;();+;y]    v-:             .[`v;();-:]";
 "v[i]+:y         .[`v;,i;+;y]    v[i]-:          .[`v;,i;-:]";
 "v[i;j]+:y       .[`v;(i;j);+;y] v[i;j]-:        .[`v;(i;j);-:]";
 "";
 "@[v;i;d;y] is .[v;,i;d;y]       @[v;i;m] is .[v;,i;m]";
 "";
 "{[a;b;c] ...}   function definition";
 " x y z          default parameters";
 " d:...          local variable";
 " d::..          global variable ";
 "";
 "control(debug: ctrl-c stop)";
 " $[c;t;f]       conditional";
 " ?[c;t;f]       boolean conditional";
 " if[c; ... ]";
 " do[n; ... ]";
 " while[c; ...]";
 " / ...          comment";
 " : ...          return(resume)";
 " ' ...          signal";
 "";
 "trap signals with .[f;(x;y;z);v] and @[f;x;v]";
 "or                .[f;(x;y;z);g] and @[f;x;g] ";
 "where v is the value to be returned on error ";
 "or g is a monadic function called with error text"
 )
DIR,:(enlist`define)!enlist`$"assign, define, control and debug"
TXT,:(enlist`dotz)!enlist(
 ".z.a       ip-address ";
 ".z.b       dependencies (more information than \\b)";
 ".z.f       startup file";
 ".z.h       hostname";
 ".z.k       kdb+ releasedate ";
 ".z.K       kdb+ major version";
 ".z.l       license information (;expirydate;updatedate;;;)";
 ".z.o       OS ";
 ".z.pc[h]   close, h handle (already closed)";
 ".z.pg[x]   get";
 ".z.ph[x]   http get";
 ".z.pi[x]   input (qcon)";
 ".z.po[h]   open, h handle ";
 ".z.pp[x]   http post";
 ".z.ps[x]   set";
 ".z.pw[u;p] validate user and password";
 ".z.s       self, current function definition";
 ".z.ts[x]   timer expression (called every \\t)";
 ".z.u       userid ";
 ".z.vs[v;i] value set";
 ".z.w       handle (0 for console, handle to remote for KIPC)";
 ".z.x       command line parameters (argc..)";
 ".z.z       gmt timestamp";
 ".z.Z       local timestamp"
 )
DIR,:(enlist`dotz)!enlist`$".z locale contents "
TXT,:(enlist`errors)!enlist(
 "runtime errors";
 "error--------example-----explanation";
 "access                   attempt to read files above directory, run system commands or failed usr/pwd";
 "assign       cos:12      attempt to reuse a reserved word";
 "conn                     too many incoming connections (1022 max)";
 "domain       !-1         out of domain";
 "length       ()+!1       incompatible lengths";
 "limit        0W#2        tried to generate a list longer than 2,000,000,000           ";
 "loop         a::a        dependency loop";
 "mismatch                 columns that can't be aligned for R,R or K,K ";
 "Mlim                     more than 999 nested columns in splayed tables";
 "nyi                      not yet implemented";
 "os                       operating system error";
 "pl                       peach can't handle parallel lambda's (2.3 only)";
 "Q7                       nyi op on file nested array";
 "rank         +[2;3;4]    invalid rank or valence";
 "splay                    nyi op on splayed table";
 "stack        {.z.s[]}[]  ran out of stack space";
 "stop        \t         user interrupt(ctrl-c) or time limit (-T)";
 "stype        '42         invalid type used to signal";
 "type         til 2.2     wrong type";
 "value                    no value";
 "vd1                      attempted multithread update";
 "wsfull                   malloc failed. ran out of swap (or addressability on 32bit). or hit -w limit.";
 "XXX                      value error (XXX undefined) ";
 "";
 "system (file and ipc) errors";
 "XXX:YYY                  XXX is from kdb+, YYY from the OS";
 "XXX from addr, close, conn, snd, rcv or (invalid) filename (read0`:invalidname.txt)";
 "";
 "parse errors (execute or load)";
 "[/(/{/]/)/}/\"            open ([{ or \"";
 "branch                   a branch(if;do;while;$[.;.;.]) more than 255 byte codes away";
 "char                     invalid character";
 "constants                too many constants (max 96)";
 "globals                  too many global variables (32 max)";
 "locals                   too many local variables (24 max)";
 "params                   too many parameters (8 max)";
 "";
 "license errors";
 "cpu                      too many cpus ";
 "exp                      expiry date passed";
 "host                     unlicensed host";
 "k4.lic                   k4.lic file not found, check QHOME/QLIC";
 "os                       unlicensed OS";
 "srv                      attempt to use client-only license in server mode ";
 "upd                      attempt to use version of kdb+ more recent than update date";
 "user                     unlicensed user";
 "wha                      invalid system date"
 )
DIR,:(enlist`errors)!enlist`$"error messages"
TXT,:(enlist`save)!enlist(
 "tables can be written as a single file or spread across a directory, e.g.";
 "`:trade set x      / write as single file ";
 "`:trade/ set x     / write across a directory ";
 "trade:get`:trade   / read ";
 "trade:get`:trade/  / map columns on demand";
 "";
 "tables splayed across a directory must be fully enumerated(no varchar) and not keyed."
 )
DIR,:(enlist`save)!enlist`$"save/load tables"
TXT,:(enlist`syscmd)!enlist(
 "\\a           tables";
 "\\b           views (see also .z.b)";
 "\\B           invalid dependencies";
 "\\c [23 79]   console height,width";
 "\\C [36 2000] browser height,width";
 "\\d [d]       q directory [go to]";
 "\\e [0|1]     error trap clients";
 "\\f [d]       functions [directory]";
 "\\l [f]       load script (or dir:files splays parts scripts)";
 "\\o [0N]      offset from gmt";
 "\\p [i]       port (0 turns off)";
 "\\P [7]       print digits(0-all)";
 "\\s [i]       number of slaves ";
 "\\S [-314159] seed";
 "\\t [i]       timer [x] milliseconds (1st fire after delay)";
 "\\t expr      time expression ";
 "\\T [i]       timeout [x] seconds ";
 "\\v [d]       variables [directory]";
 "\\w           workspace(used allocated max mapped)";
 "             (max set by -w, 0 => unlimited)";
 "\\W [2]       week offset(sat..fri)";
 "\\z [0]       \"D\"$ uses mm/dd/yyyy or dd/mm/yyyy";
 "\\cd [d]      O/S directory [go to]";
 "\\[other]     O/S execute";
 "\\\\           exit";
 "\\            (escape suspension, or switch language mode)";
 "ctrl-c       (stop)"
 )
DIR,:(enlist`syscmd)!enlist`$"system commands"
TXT,:(enlist`verbs)!enlist(
 "verb-infix-------prefix";
 "s:x  gets     :x idem";
 "i+i  plus     +l flip";
 "i-i  minus    -i neg";
 "i*i  times    *l first";
 "f%f  divide   %f reciprocal";
 "a&a  and      &B where";
 "a|a  or       |l reverse";
 "a^a  fill     ^a null";
 "a=a  equal    =l group";
 "a<a  less     <l iasc     <s(hopen)";
 "a>a  more     >l idesc    >i(hclose)";
 "c$a  cast s$  $a string   h$a \"C\"$C `$C";
 "l,l  cat      ,x enlist";
 "i#l  take     #l count";
 "i_l  drop     _a floor    sc(lower)";
 "x~x  match    ~a not      ~s(hdelete)";
 "l!l  xkey     !d key      !i (s;();S):!s";
 "A?a  find     ?l distinct rand([n]?bxhijefcs)";
 "x@i  at   s@  @x type          trap amend(:+-*%&|,)";
 "x.l  dot  s.  .d value    .sCL trap dmend(:+-*%&|,)";
 "A bin a;a in A;a within(a;a);sC like C;sC ss sC";
 "{sqrt log exp sin cos tan asin acos atan}f";
 "last sum prd min max avg wsum wavg xbar";
 "exit getenv";
 "";
 "dependency::expression (when not in function definition)"
 )
DIR,:(enlist`verbs)!enlist`$"verbs/functions"
.q.help:.help.display
