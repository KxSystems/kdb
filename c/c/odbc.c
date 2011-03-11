//2011.03.11 64bit was not detecting SQL_NULL_DATA correctly
//2010.07.06 support mssql datetime (sql_type_date.. are 91 92 93 so map to 9 10 11
//2010.01.18 SQLInteger->SQLULEN for v64 build
//2008.03.24 load "" instead of () for null text
//2007.05.04 fix null charstrings;read bool and byte as smallint
//2007.03.28  KB null->0  KS(>8)->0
//cl -DWIN32  /LD /Oy odbc.c odbc.def q.lib odbc32.lib user32.lib
//cl -D_WIN64 /LD /Oy odbc.c odbc.def q.lib odbc32.lib user32.lib bufferoverflowU.lib
//gcc -shared ../c/odbc.c -o odbc.so -lodbc -fPIC
//usr/local/gcc-3.3.2/bin/gcc -G ../c/odbc.c -o odbc.so -lodbc   /-lodbcinst  [-m64 -fPIC]
#include"d.h" // http://www.unixodbc.org
extern V free(V*p);
ZS err(I f,D d){ZC e[1006];I i;H j;SQLError(0,f?0:d,f?d:0,e,(SQLINTEGER*)&i,e+6,1000,&j);R e[5]=' ',e;}
#define Q(x,s) P(x,krr(s))
#define Q0(x) {I r=(x);if(r){S s=err(0,d);if(r!=1)R       krr(s);if(*s)O("%s\n",s);}}
#define Q1(x) {I r=(x);if(r){S s=err(1,d);if(r!=1)R d0(d),krr(s);if(*s)O("%s\n",s);}}
K1(open){Z D d9;H j=xt==KS;D d,v=GetForegroundWindow();ZC b[1024];
 if(!d9)SQLAllocEnv(&d9);Q0(SQLAllocConnect(d9,&d))Q(!j&&xt!=-KS&&xt!=KC,"type")Q(j&&xn!=3,"length")
 Q0(xt==KC?SQLDriverConnect(d,v,xG,(H)xn,b,(H)1024,&j,v?SQL_DRIVER_COMPLETE:SQL_DRIVER_NOPROMPT):
  SQLConnect(d,j?*xS:xs,S0,j?xS[1]:0,S0,j?xS[2]:0,S0))R kj((J)(L)d);}
K1(close){D d=(D)(L)xj;R SQLDisconnect(d),SQLFreeConnect(d),knk(0);}ZV d0(D d){SQLFreeStmt(d,SQL_DROP);}
Z D d1(J j){D d=(D)(L)j;Q0(SQLAllocStmt(d,&d))R d;}
ZK rs(I a,D d,H j){C b[128];SQLULEN n=128;K x=ktn(a?0:KS,0);if(!a)for(SQLBindCol(d,j,SQL_C_CHAR,b,n,&n);!SQLFetch(d);)js(&x,ss(b));R d0(d),x;}
ZK fk(K x,S s,H j){D d=d1(xj);U(d)R rs(SQLForeignKeys(d,(S)0,0,(S)0,0,(S)0,0,(S)0,0,(S)0,0,s,S0),d,j);}
ZK tv(K x,S s){D d=d1(xj);U(d)R rs(SQLTables(d,(S)0,0,(S)0,0,(S)0,0,s,S0),d,3);}
K2(keys){D d=d1(xj);U(d)R rs(SQLPrimaryKeys(d,(S)0,0,(S)0,0,y->s,S0),d,4);}	K1(tables){R tv(x,"TABLE,SYNONYMS");}
K2(fkeys){K r=fk(x,y->s,8);R r&&r->t?knk(2,r,fk(x,y->s,3)):r;}			    K1(views){R tv(x,"VIEW");}
ZI ds(S s){DATE_STRUCT*d=(DATE_STRUCT*)s;R ymd(d->year,d->month,d->day);} ZS dtb(S s,I n){for(;n--&&s[n]==' ';);R sn(s,n+1);}
ZI vs(S s){TIME_STRUCT*t=(TIME_STRUCT*)s;R 3600*t->hour+60*t->minute+t->second;}
ZI ut[]={0,KS,KF,KF,KI,KH,KF,KE,KF,KD,KV,KZ,KS,0,0,0,0, KJ,KH,KH,KS,KS,0,0};//KG,KB  use KH for the nulls
ZI wt[]={0, 0, 8, 8, 4, 2, 8, 4, 8, 6, 6,16, 0,0,0,0,0,  8, 1, 1, 0, 0,0,0};
ZH ct[]={0, 1, 8, 8, 4, 5, 8, 7, 8, 9,10,11, 1,1,0,0,0,-25,-6,-7, 1, 1,1,0};// -5/-25(odbc 2/3)
ZS nu(I t){ZF f;ZE e;ZJ j=nj;ZI i=ni;ZH h=nh;ZC g;ZS ns;if(!ns)f/=f,e=f,ns=ss("");R t==KS?(S)&ns:t==KF||t==KZ?(S)&f:t==KE?(S)&e:t==KJ?(S)&j:t==KH?(S)&h:t==KG||t==KB?(S)&g:(S)&i;}
ZK gb(D d,H j,I t){K x=0;H c=ct[t],g=c?c:-2;SQLULEN n=0;I e=SQLGetData(d,j,g,kG(x),n,&n);
 if(t==22)n/=2;n+=c;if(x=ktn(c?KC:KG,e==1?n:0),xn)if(SQLGetData(d,j,g,kG(x),n,&n),c)--xn;R x;}
K2(eval){K*k;S*b,s;SQLULEN w;SQLLEN*nb;SQLINTEGER*wb;H*tb,u,t,j,p,m;F f;C c[128];I n=xj<0;D d=d1(n?-xj:xj);U(d)x=y;Q(xt!=-KS&&xt!=KC,"type")
 Q1(xt==-KS?SQLColumns(d,(S)0,0,(S)0,0,xs,S0,(S)0,0):SQLExecDirect(d,xG,xn))SQLNumResultCols(d,&j);P(!j,(d0(d),knk(0)))
 b=malloc(j*SZ),tb=malloc(j*2),wb=malloc(j*SZ),nb=malloc(j*SZ),x=ktn(KS,j),y=ktn(0,j);// sqlserver: no bind past nonbind
 DO(j,Q1(SQLDescribeCol(d,(H)(i+1),c,128,&u,&t,&w,&p,&m))xS[i]=sn(c,u);
if(t>90)t-=82;
Q(t<-11||t>12,xS[i])wb[i]=ut[tb[i]=t=t>0?t:12-t]==KS?w+1:wt[t];if(ut[t]==KS&&(n||wb[i]>9))tb[i]=13)
 DO(j,kK(y)[i]=ktn(ut[t=tb[i]],0);if(w=wb[i])Q1(SQLBindCol(d,(H)(i+1),ct[t],b[i]=malloc(w),w,nb+i)))
 for(;!SQLFetch(d);)DO(j,k=kK(y)+i;u=ut[t=tb[i]];s=b[i];n=SQL_NULL_DATA==(int)nb[i];
if(!u)jk(k,n?ktn(ct[t]?KC:KG,0):wb[i]?kp(s):gb(d,(H)(i+1),t));
else ja(k,n?nu(u):u==KH&&wb[i]==1?(t=(H)*s,(S)&t):u==KS?(s=dtb(s,nb[i]),(S)&s):u<KD?s:u==KZ?(f=ds(s)+(vs(s+6)+*(I*)(s+12)/1e9)/8.64e4,(S)&f):(w=u==KD?ds(s):vs(s),(S)&w))) 
 if(!SQLMoreResults(d))O("more\n");DO(j,if(wb[i])free(b[i]))R free(b),free(tb),free(wb),free(nb),d0(d),xT(xD(x,y));}
/*
#define SQL_CHAR            1
#define SQL_NUMERIC         2
#define SQL_DECIMAL         3
#define SQL_INTEGER         4
#define SQL_SMALLINT        5
#define SQL_FLOAT           6
#define SQL_REAL            7
#define SQL_DOUBLE          8
#define SQL_DATE            9
#define SQL_TIME           10
#define SQL_TIMESTAMP      11
#define SQL_VARCHAR        12
#define SQL_LONGVARCHAR     (-1)
#define SQL_BINARY          (-2)
#define SQL_VARBINARY       (-3)
#define SQL_LONGVARBINARY   (-4)
#define SQL_BIGINT          (-5) -25
#define SQL_TINYINT         (-6)
#define SQL_BIT             (-7)
#define SQL_WCHAR		 	(-8)
#define SQL_WVARCHAR	 	(-9)
#define SQL_WLONGVARCHAR 	(-10)
guid                         -11
ZI un(D d,H j){I u;SQLColAttribute(d,j,SQL_DESC_UNSIGNED,0,0,0,&u);R u;}
*/

