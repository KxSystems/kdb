//cl /LD  d.c d.def \z\c___Win3\script1.res /o\winnt\system32\qodbc.dll c.obj advapi32.lib user32.lib wsock32.lib odbc32.lib odbccp32.lib 
//gcc -shared ../c/d.c -o qodbc.so -lodbc -fPIC -w
//http://www.easysoft.com/developer/interfaces/odbc/linux.html#driver_install_unixodbc
//2007.02.05 SAS -4/4096 remove "\"" 2007.01.21 colattribute 2007.01.16 sns/getconnectattr R S1; 2007.01.07(primary/foreign requires 2007.01.07+) 2006.12.26(sqlprepare ex) 2006.11.01 DSN=(allow access/vb?) 2006.08.25 typename N0 2006.08.15 prompt for DBQ UID PWD
//http://msdn.microsoft.com/library/default.asp?url=/library/en-us/odbc/htm/odbc_test_overview.asp
//http://msdn.microsoft.com/library/default.asp?url=/library/en-us/odbc/htm/dasdkodbcoverview_64bit.asp
//#define ODBCVER 0x0250 //access:  http://msdn.microsoft.com/archive/default.asp?url=/archive/en-us/dnaraccess/html/msdn_odk.asp
#include"d.h" 
ZC b[99],q[99],u[99],p[99];
#ifdef WIN32 //ZS mb(S s){R MessageBox(0,s,"kdb+",MB_OK|MB_TASKMODAL),s;}
Z HINSTANCE hi;BOOL APIENTRY DllMain(HANDLE h,DWORD i,LPVOID l){if(i==DLL_PROCESS_ATTACH)hi=h;R 1;}
BOOL CALLBACK cb(HWND h,UINT m,WPARAM w,LPARAM l){if(m==WM_COMMAND)SW(w){
 case IDOK:GetDlgItemText(h,1000,b,99),b[m=strlen(b)]=':',++m,GetDlgItemText(h,1001,b+m,99-m);
 case IDCANCEL:EndDialog(h,w);R 1;}R 0;}
ZS dlg(I i){R*b=0,IDOK==DialogBox(hi,MAKEINTRESOURCE(i),0,(DLGPROC)cb)?b:0;}
#else
ZS dlg(I i){R 0;}
#endif
ZI g2(){S s;U(dlg(111))if(strcpy(q,b),*u=0,dlg(110))s=strchr(b,':'),*s++=0,strcpy(u,b),strcpy(p,s);R 1;}
ZV g0(S s,S a,S v){v[SQLGetPrivateProfileString(s,a,"",v,99,"odbc.ini")]=0;}
ZV g1(S s,S a,S v){L n;if(s=strstr(s,a))s+=4,strncpy(v,s,n=(S)strchr(s,';')-s),v+=n;*v=0;}
ZV g3(S a,S v){SQLWritePrivateProfileString(q,a,v,"odbc.ini");}
BOOL INSTAPI ConfigDSN(HWND h,WORD j,LPCSTR d,LPCSTR s){SW(j){CS(ODBC_REMOVE_DSN,R SQLRemoveDSNFromIni(s+4))
 CS(ODBC_ADD_DSN,U(g2())U(SQLWriteDSNToIni(q,d))if(g3("DBQ",q),*u){g3("UID",u);g3("PWD",p);})}R 0;}
ZV av(S s,S a,S v){s+=strlen(strcat(s,a)),*s++='=',s+=strlen(strcpy(s,v)),*s++=';',*s=0;}
ZS si(I i){ZC b[9];R sprintf(b,"%d",i),b;}ZS ssi(S s,I i){ZC b[9];R sprintf(b,"%s %d",s,i),b;}
ZI sns(S b,I n,S s){I i=strlen(s);if(b)memcpy(b,s,i=i<n?i:n-1),b[i]=0;R i;}ZI sj(S s,I j){R j==S0?strlen(s):j;}
Z struct{C e[100];S s;I i;}err={"[q][ODBC]"};ZA QS(S s,S e,I r){R strcpy(err.e+9,e),err.s=s,err.i=1,r;}
A SQLError(D h,D h1,D h2,S s,SQLINTEGER*i,S s1,H j1,H*j2){P(!err.i,S1)R strcpy(s,err.s),*i=err.i,*j2=sns(s1,j1,err.e),err.i=0,0;}
#define Q1(e)  P(1,QS("HYC00",e,-1))
#define Q(x,e) P(x,QS("HY000",e,-1)) //0-noprompt 1-complete 2-prompt 3-required
ZI n,c,c0,c1,c4,c101,c102=SQL_AUTOCOMMIT_ON,c103,c108=SQL_TXN_SERIALIZABLE;
A SQLDisconnect(D h){if(!--n)closesocket(c),c=0;R 0;}
A SQLConnect(D d,S s,H j,S u,H uj,S p,H pj){if(j=sj(s,j),c>0){Q(strncmp(q,s,j),q)R++n,0;}strncpy(q,s,j)[j]=0,s=strchr(q,':');Q(!s,"host:port")
 *s=0,c=khpu(q,atoi(s+1),u&&*u?(strncpy(b,u,j=sj(u,uj)),u=b+j,*u++=':',j=sj(p,pj),strncpy(u,p,j)[j]=0,b):(S)""),*s=':';Q(c<0,q)Q(!c,"access")
R n=1,0;}
A SQLDriverConnect(D d,HWND w,S s,H j0,S r,H j,H*j2,UH f){
 if(!strncmp(s,"DSN=",4))*strchr(s+=4,';')=0,g0(s,"DBQ",q),g0(s,"UID",u),g0(s,"PWD",p);
 else if(strstr(s,"DBQ="))g1(s,"DBQ",q),g1(s,"UID",u),g1(s,"PWD",p);else Q(!g2(),"DBQ")
 if(r){if(strcpy(r,"DRIVER=kdb+;"),av(r,"DBQ",q),*u)av(r,"UID",u),av(r,"PWD",p);av(r,"DSN","default"),*j2=strlen(r);}
R SQLConnect(d,q,S0,u,S0,p,S0);}
//104 SQL_OPT_TRACE SQL_OPT_TRACEFILE SQL_TRANSLATE_DLL SQL_TRANSLATE_OPTION 109 SQL_CURRENT_QUALIFIER SQL_ODBC_CURSORS SQL_QUIET_MODE SQL_PACKET_SIZE
A SQLSetConnectAttr(D h,SQLINTEGER i,V*s,SQLINTEGER n){I v=(I)(L)s;SW(i){CD:Q1("set")//if(i!=30002)B("setconnectattr",i); access 30002
 CS(SQL_QUERY_TIMEOUT,c0=v)CS(SQL_MAX_ROWS,Q(v!=c1,"maxrows"))CS(SQL_ASYNC_ENABLE,c4=v)CS(SQL_ATTR_ACCESS_MODE,c101=v)
 CS(SQL_ATTR_AUTOCOMMIT,c102=v)CS(SQL_ATTR_LOGIN_TIMEOUT,c103=v)CS(SQL_ATTR_TXN_ISOLATION,c108=v)}R 0;}
A SQLGetConnectAttr(D h,SQLINTEGER i,V*s,SQLINTEGER n,SQLINTEGER*i1){I v;
SW(i){CD:R S1;//Q1("get")if(i!=30002)B("getconnectattr",i);
CS(SQL_CURRENT_QUALIFIER,*i1=v=0)
CS(SQL_QUERY_TIMEOUT,v=c0)CS(SQL_MAX_ROWS,v=c1)CS(SQL_ASYNC_ENABLE,v=c4)CS(SQL_ATTR_ACCESS_MODE,v=c101)
CS(SQL_ATTR_AUTOCOMMIT,v=c102)CS(SQL_ATTR_LOGIN_TIMEOUT,v=c103)CS(SQL_ATTR_TXN_ISOLATION,v=c108)}R*(I*)s=v,0;}
#define N 10 //1env,2dbc,3stmt,4desc  -1(fail) 0(success)1(successwithinfo) one connection(msqry ss7 ignore)if(h12[j])QS("HY014","boo",-1)
ZK*td[N],tk[N];ZS*tf[N],*tb[N];Z L*tw[N],**tn[N];ZI*tu[N],ti[N],tj[N],bi[N],s[N],s0[N],s3[N],s5[N],s6[N],s9[N],s11[N],sb[13]={0,0,0,0,0,0,0,SQL_CONCUR_READ_ONLY};
A SQLAllocHandle(H j,D d,D*h1){I h=0;Q(j>3,"desc")P(j<3,(*h1=(D)(L)-j,0))for(;s[h];++h)Q(h==N,"limit")R s[h]=s9[h]=1,s11[h]=SQL_RD_ON,*h1=(D)(L)h,0;}
ZV b1(I h){I j=tj[h];tb[h]=(S*)malloc(j*SZ),tu[h]=(I*)malloc(j*4),tw[h]=(L*)malloc(j*SZ),tn[h]=(L**)malloc(j*SZ);DO(j,tb[h][i]=0)}
ZV b0(I h){if(tb[h])free(tb[h]),tb[h]=0,free(tu[h]),free(tw[h]),free(tn[h]);}
ZV ch(I h){if(tk[h])r0(tk[h]),tk[h]=0,ti[h]=tj[h]=0;}ZV fh(I h){ch(h),b0(h),s[h]=s5[h]=s6[h]=0;}
A SQLFreeStmt(D d,UH j){SW(j){CS(SQL_CLOSE,ch((I)(L)d))CS(SQL_UNBIND,b0((I)(L)d))CS(SQL_DROP,fh((I)(L)d))CS(SQL_RESET_PARAMS,0)}R 0;}
A SQLFreeHandle(H j,D d){U(j==3)R fh((I)(L)d),0;}A SQLCancel(D d){R SQLFreeStmt(d,SQL_CLOSE);}
ZA k1(D d,S f,S s,I n){I h=(I)(L)d;C b[99]=".o.";K x=k(c,strcat(b,f),kpn(s,sj(s,n)),0);Q(xt==-128,xs)P(xt!=XT,(r0(x),0))
 R bi[h]=-s9[h],tk[h]=x,x=xk,tf[h]=kS(xx),x=xy,tj[h]=xn,td[h]=xK,x=*xK,ti[h]=xn,0;}
ZI nu(K x,I i){I t=xt;R t<KH?0:t==KH?xH[i]==nh:t==KJ?xJ[i]==nj:t==KE?isnan(xE[i]):t==KF||t==KZ?isnan(xF[i]):t==KC?xG[i]==' ':t==KS?!*xS[i]:xI[i]==ni;}
ZI Td(I f,S b,I d){H*j=(H*)b;R d=dj(d),*j=d/10000,j[1]=(d/100)%100,j[2]=d%100,f?sprintf(b,"%d-%02d-%02d",j[0],j[1],j[2]):6;}
ZI Tv(I f,S b,I v){H*j=(H*)b;R*j=v/3600,j[1]=(v/60)%60,j[2]=v%60,f?sprintf(b,"%02d:%02d:%02d",j[0],j[1],j[2]):6;}
ZI Tz(I f,S b,F z){extern F floor();I d=(I)floor(z),e=floor(z=86400*(z-d));R Tv(f,b+f+Td(f,b,d),e),z-=e,f?(b[10]=' ',sprintf(b+19,".%03d",(I)(1e3*z)),23):(*(I*)(b+12)=1e9*z,16);}
// excel(KS,KF,KZ) vb(KJ>KS) msqry(KS) access(KG>KH KJ>binary) -4(nototal) longchar(-1,1) longbinary(-4,-2) signed(20) unsigned(22)
ZS N0[]={"text","bit",0,0,"tinyint","smallint","int","bigint","real","float","char","varchar",0,"","date","datetime",0,"","","time"};
ZI T0[]={  -1,-7,0,0,-6,5, 4,-5, 7, 8,1, 12,0, 9, 9,11,0,10,10,10},
   U0[]={   1,-7,0,0,-6,5, 4,-5, 7, 8,1,  1,0, 9, 9,11,0,10,10,10},
   B0[]={4096, 1,0,0, 1,2, 4, 8, 4, 8,1,255,0, 6, 6,16,0, 6, 6, 6},
   C0[]={4096, 1,0,0, 3,5,10,19, 7,15,1,255,0,10,10,23,0, 8, 8, 8},
   D0[]={4096, 1,0,0, 4,6,11,20,14,24,1,255,0,10,10,23,0, 8, 8, 8};ZI vt(I t,I x){R t==KU?60*x:t==KV?x:x/1000;}
ZI ut(I t){ZI u[]={0,KS,0,0,KI,KH,0,KE,KF,KD,KV,KZ};R t<-14?ut(t+(t%10<-6?22:20)):t>11?0:t>0?u[t]:t==-5?KJ:t==-6?KG:t==-7?KB:0;}
ZA gd(I h,I j,I i,I u,S b,L w,L*n){K x=td[h][j];I t=xt;Q(t==KM,"KM") //vb datalink P(a,(a=0,S1)) .. a=1
if(!t){Q(u!=1,ssi("utype",u))x=xK[i],*n=t=xt==KC?xn:0;P(!w,1)Q(w<=t,"gd")R memcpy(b,xG,t),b[t]=0;}
u=ut(u==99?U0[t]:u);if(!u||nu(x,i))*n=SQL_NULL_DATA;else SW(*n=B0[u],u){
 CS(KH,*(H*)b=t==KH?xH[i]:xG[i])CS(KI,*(I*)b=t==KI?xI[i]:t==KH?xH[i]:xG[i])
 CS(KF,*(F*)b=t==KF?xF[i]:t==KE?xE[i]:t==KJ?xJ[i]:t==KI?xI[i]:t==KH?xH[i]:xG[i])
 CS(KS,*n=t<KE?sprintf(b,"%I64d",t<KH?xG[i]:t==KH?xH[i]:t==KI?xI[i]:xJ[i]):t<KC?sprintf(b,"%.2f",t<KF?xE[i]:xF[i]):t==KC?(*b=xG[i],1):
  t==KS?strlen(strcpy(b,kS(x)[i])):t==KD?Td(1,b,xI[i]):t==KZ?Tz(1,b,xF[i]):Tv(1,b,vt(t,xI[i])))
 CS(KD,Td(0,b,xI[i]))CS(KV,Tv(0,b,vt(t,xI[i])))CS(KZ,Tz(0,b,t==KZ?xF[i]:t==KD?xI[i]:(t==KT?xI[i]/8.64e7:vt(t,xI[i])/8.64e4)-36526))
 CD:memcpy(b,xG+i**n,*n);}R 0;}//BGJE
A SQLGetData(D d,UH j,H u,V*b,L w,L*n){I h=(I)(L)d;R gd(h,--j,bi[h],u,b,w,n);}
A SQLBindCol(D d,UH j,H u,V*b,L w,L*n){I h=(I)(L)d;P(!tk[h],0)if(!tb[h])b1(h);tb[h][--j]=b;R tu[h][j]=u,tw[h][j]=w,tn[h][j]=n,0;}
A SQLExtendedFetch(D d,UH j,L k,UL*i1,UH*j1){I h=(I)(L)d;L w;SW(j){CS(SQL_FETCH_NEXT,bi[h]+=s9[h])CS(SQL_FETCH_FIRST,bi[h]=0)
  CS(SQL_FETCH_LAST,bi[h]=ti[h]>s9[h]?ti[h]-s9[h]:0)CS(SQL_FETCH_PRIOR,bi[h]-=s9[h])CS(SQL_FETCH_ABSOLUTE,bi[h]=k-1)CS(SQL_FETCH_RELATIVE,bi[h]+=k)}
 P(bi[h]>=ti[h],S1)k=ti[h]-bi[h]<s9[h]?ti[h]-bi[h]:s9[h];if(i1)*i1=k;if(j1)DO(s9[h],j1[i]=i<k?SQL_ROW_SUCCESS:SQL_ROW_NOROW)
 if(!s11[h]||!tb[h])R 0;DO(k,for(j=0;j<tj[h];++j)if(w=tw[h][j],tb[h][j])gd(h,j,bi[h]+i,tu[h][j],tb[h][j]+i*(s5[h]?s5[h]:w),w,tn[h][j]+i*(s5[h]?s5[h]:4)/4))R 0;}
A SQLFetch(D d){R SQLExtendedFetch(d,SQL_FETCH_NEXT,(L)0,(L*)0,(UH*)0);} 
A SQLPrepare(D d,S s,SQLINTEGER n){Q(memchr(s,'?',sj(s,n)),"?")R k1(d,"ex",s,n);} A SQLExecute(D d){R 0;}
A SQLExecDirect(D d,S s,SQLINTEGER n){R k1(d,"ex",s,n);}                          A SQLMoreResults(D h){R S1;}         
A SQLNumResultCols(D h,H*j){R*j=tj[(I)(L)h],0;}                             A SQLRowCount(D h,L*n){R*n=ti[(I)(L)h],0;} 
A SQLDescribeCol(D d,UH j,S s,H j1,H*j2,H*u,UL*c,H*p,H*n){I h=(I)(L)d,t=td[h][--j]->t;R*j2=sns(s,j1,tf[h][j]),*u=T0[t],*c=C0[t],*p=0,*n=t?SQL_NULLABLE:0,0;}
A SQLColAttributes(D d,UH j,UH f,V*b,H j1,H*j2,L*n){I h=(I)(L)d,t=td[h][--j]->t;S s=0;SW(f){CD:Q1(ssi("attr ",f))
case SQL_COLUMN_COUNT:CS(SQL_DESC_COUNT,*n=tj[h])
/*SQL_COLUMN_DISPLAY_SIZE:*/CS(SQL_DESC_DISPLAY_SIZE,*n=D0[t])
case SQL_COLUMN_LENGTH:CS(SQL_DESC_LENGTH,*n=B0[t])
case SQL_COLUMN_NAME:case SQL_DESC_LABEL:CS(SQL_DESC_NAME,s=tf[h][j])
case SQL_COLUMN_PRECISION:CS(SQL_DESC_PRECISION,*n=C0[t])
case SQL_COLUMN_SCALE:CS(SQL_DESC_SCALE,*n=0)
case SQL_COLUMN_NULLABLE:CS(SQL_DESC_NULLABLE,*n=t?SQL_NULLABLE:0)
CS(SQL_DESC_AUTO_UNIQUE_VALUE,*n=SQL_FALSE)CS(SQL_DESC_BASE_COLUMN_NAME,s="")CS(SQL_DESC_BASE_TABLE_NAME,s="")
CS(SQL_DESC_CASE_SENSITIVE,*n=SQL_FALSE)CS(SQL_DESC_CATALOG_NAME,s="")CS(SQL_DESC_CONCISE_TYPE,*n=T0[t])
CS(SQL_DESC_FIXED_PREC_SCALE,*n=SQL_FALSE)CS(SQL_DESC_LITERAL_PREFIX,s="'")CS(SQL_DESC_LITERAL_SUFFIX,s="'")
CS(SQL_DESC_LOCAL_TYPE_NAME,s=N0[t])CS(SQL_DESC_NUM_PREC_RADIX,*n=10)CS(SQL_DESC_OCTET_LENGTH,*n=B0[t])
CS(SQL_DESC_SCHEMA_NAME,s="")CS(SQL_DESC_SEARCHABLE,*n=SQL_PRED_SEARCHABLE)CS(SQL_DESC_TABLE_NAME,s="")
CS(SQL_DESC_TYPE,*n=T0[t>KS?KZ:t])CS(SQL_DESC_TYPE_NAME,s=N0[t])CS(SQL_DESC_UNNAMED,*n=SQL_NAMED)CS(SQL_DESC_UNSIGNED,*n=SQL_FALSE)CS(SQL_DESC_UPDATABLE,*n=SQL_ATTR_WRITE)}
if(s)*j2=sns(b,j1,s);R 0;}
A SQLGetTypeInfo(D h,H j){R k1(h,"TypeInfo",j?si(j):(S)"",S0);}
A SQLTables(D h,S d,H dj,S s,H sj,S t,H tj,S c,H cj){Q(c&&*c=='%',"tables")R k1(h,"Tables",t&&*t&&*t!='%'?t:(S)"",tj);}
A SQLColumns(D h,S d,H dj,S u,H uj,S t,H tj,S c,H cj){Q(c,"column")R k1(h,"Columns",t,tj);}
A SQLPrimaryKeys(D h,S d,H dj,S s,H sj,S t,H tj){R k1(h,"Key",t,tj);}
A SQLForeignKeys(D h,S d,H dj,S s,H sj,S t,H tj,S d1,H dj1,S s1,H sj1,S t1,H tj1){R k1(h,t?"Gkey":"Fkey",t?t:t1,t?tj:tj1);}
A SQLSpecialColumns(D h,UH i,S d,H dj,S s,H sj,S t,H tj,UH j,UH j1){R k1(h,"Special",i==SQL_ROWVER?(S)"":t,tj);}
A SQLStatistics(D h,S d,H dj,S s,H sj,S t,H tj,UH j,UH j1){R k1(h,"Stats",t,tj);}
//QUERY_TIMEOUT,MAX_ROWS,NO_SCAN,MAX_LENGTH,ASYNC_ENABLE,5,6,CONCUR,KEYSET_SIZE,ROWSET_SIZE,RETRIEVE_DATA,USE_BOOKMARKS 
A SQLSetStmtAttr(D d,SQLINTEGER i,V*s,SQLINTEGER n){I h=(I)(L)d,v=(I)(L)s;SW(i){CS(SQL_QUERY_TIMEOUT,s0[h]=v)CS(SQL_MAX_LENGTH,s3[h]=v)
CS(SQL_BIND_TYPE,s5[h]=v)CS(SQL_CURSOR_TYPE,s6[h]=v?SQL_CURSOR_STATIC:0;P(v!=s6[h],QS("01S02","cursor",1)))
case 27:CS(SQL_ROWSET_SIZE,bi[h]-=v-s9[h];s9[h]=v)CS(SQL_RETRIEVE_DATA,s11[h]=v)CD:P(i>12||sb[i]!=v,QS("01S02","stmt",1))}R 0;}
A SQLGetStmtAttr(D d,SQLINTEGER i,V*s,SQLINTEGER n,SQLINTEGER*i1){I h=(I)(L)d,v;SW(i){CS(SQL_QUERY_TIMEOUT,v=s0[h])CS(SQL_MAX_LENGTH,v=s3[h])
CS(SQL_BIND_TYPE,v=s5[h])CS(SQL_CURSOR_TYPE,v=s6[h])
case 27:CS(SQL_ROWSET_SIZE,v=s9[h])CS(SQL_RETRIEVE_DATA,v=s11[h])CD:Q(i>12,"getstmtattr")v=sb[i];}R*(I*)s=v,0;}
#define MX 128 // MSQ schema_name_len=0; CRW table_name_len!=0;
A SQLGetInfo(D d,UH h,V*v,H h1,H*h2){S s=0;I i=-2;  //  ver/commit/rollback
SW(h){CD:Q1(si(h))// 47-72 convert  103 65003
CS(SQL_CONVERT_FUNCTIONS,i=0)
CS(SQL_NUMERIC_FUNCTIONS,i=0)
CS(SQL_STRING_FUNCTIONS,i=0)
CS(SQL_SYSTEM_FUNCTIONS,i=0)
CS(SQL_TIMEDATE_FUNCTIONS,i=0) //SQL_FN_TD_EXTRACT)
CS(SQL_IDENTIFIER_QUOTE_CHAR,s=" ") //"\"") excel does: from ""a a
CS(SQL_ALTER_TABLE,i=SQL_AT_DROP_COLUMN|SQL_AT_ADD_COLUMN)
CS(SQL_UNION,i=0) //SQL_U_UNION|SQL_U_UNION_ALL)
CS(SQL_KEYWORDS,s="")
CS(SQL_SUBQUERIES,i=SQL_SQ_CORRELATED_SUBQUERIES|SQL_SQ_COMPARISON|SQL_SQ_EXISTS|SQL_SQ_IN|SQL_SQ_QUANTIFIED)
CS(SQL_EXPRESSIONS_IN_ORDERBY,s="N")
CS(SQL_DATA_SOURCE_READ_ONLY,s=c101?"Y":"N")
CS(SQL_ACCESSIBLE_PROCEDURES,s="N")
 CS(SQL_ACCESSIBLE_TABLES,s="Y")CS(SQL_BOOKMARK_PERSISTENCE,i=0)
 CS(SQL_CATALOG_LOCATION,h=SQL_CL_START)CS(SQL_CATALOG_NAME_SEPARATOR,s="")CS(SQL_CATALOG_TERM,s="catalog")CS(SQL_CATALOG_USAGE,i=0)
 CS(SQL_COLUMN_ALIAS,s="Y")CS(SQL_CONCAT_NULL_BEHAVIOR,h=SQL_CB_NULL)CS(SQL_CORRELATION_NAME,h=SQL_CN_ANY)
 CS(SQL_CURSOR_ROLLBACK_BEHAVIOR,h=SQL_CB_PRESERVE)CS(SQL_DATA_SOURCE_NAME,s="")CS(SQL_DATABASE_NAME,s="")//used in table names!
 CS(SQL_DBMS_NAME,s="kdb+")CS(SQL_DBMS_VER,s="00.00.0000")CS(SQL_DEFAULT_TXN_ISOLATION,i=SQL_TXN_SERIALIZABLE)
 CS(SQL_DRIVER_NAME,s="qodbc.dll")CS(SQL_DRIVER_ODBC_VER,s="02.50") //03.00=> descriptors sql_type_date etc.
 CS(SQL_DRIVER_VER,s="00.00.0000")CS(SQL_FILE_USAGE,h=SQL_FILE_CATALOG)
 CS(SQL_GETDATA_EXTENSIONS,i=SQL_GD_ANY_COLUMN|SQL_GD_ANY_ORDER)CS(SQL_GROUP_BY,h=SQL_GB_GROUP_BY_EQUALS_SELECT)
 CS(SQL_IDENTIFIER_CASE,h=SQL_IC_MIXED)CS(SQL_INTEGRITY,s="N")
 CS(SQL_MAX_BINARY_LITERAL_LEN,i=0)CS(SQL_MAX_CATALOG_NAME_LEN,h=0)CS(SQL_MAX_CHAR_LITERAL_LEN,i=0)CS(SQL_MAX_COLUMN_NAME_LEN,h=MX)CS(SQL_MAX_COLUMNS_IN_GROUP_BY,h=0)
 CS(SQL_MAX_COLUMNS_IN_INDEX,h=0)CS(SQL_MAX_COLUMNS_IN_ORDER_BY,h=0)CS(SQL_MAX_COLUMNS_IN_SELECT,h=0)
 CS(SQL_MAX_COLUMNS_IN_TABLE,h=0)CS(SQL_MAX_CONCURRENT_ACTIVITIES,h=0)CS(SQL_MAX_CURSOR_NAME_LEN,h=MX)
 CS(SQL_MAX_DRIVER_CONNECTIONS,h=0)CS(SQL_MAX_INDEX_SIZE,i=0)CS(SQL_MAX_PROCEDURE_NAME_LEN,h=MX)
 CS(SQL_MAX_ROW_SIZE,i=0)CS(SQL_MAX_SCHEMA_NAME_LEN,h=0)CS(SQL_MAX_STATEMENT_LEN,i=0)
 CS(SQL_MAX_TABLE_NAME_LEN,h=MX)CS(SQL_MAX_TABLES_IN_SELECT,h=0)CS(SQL_MAX_USER_NAME_LEN,h=MX)
 CS(SQL_MULT_RESULT_SETS,s="N")CS(SQL_MULTIPLE_ACTIVE_TXN,s="N")CS(SQL_NEED_LONG_DATA_LEN,s="N")
 CS(SQL_NON_NULLABLE_COLUMNS,h=SQL_NNC_NON_NULL)CS(SQL_NULL_COLLATION,h=SQL_NC_LOW)
 CS(SQL_CURSOR_COMMIT_BEHAVIOR,h=SQL_CB_PRESERVE)
 case 65003:CS(SQL_OJ_CAPABILITIES,i=0)CS(SQL_ORDER_BY_COLUMNS_IN_SELECT,s="Y")
 CS(SQL_PROCEDURE_TERM,s="procedure")CS(SQL_PROCEDURES,s="N")CS(SQL_QUOTED_IDENTIFIER_CASE,h=SQL_IC_SENSITIVE)
 CS(SQL_ROW_UPDATES,s="N")CS(SQL_SCHEMA_TERM,s="")CS(SQL_SCHEMA_USAGE,i=0)CS(SQL_SCROLL_OPTIONS,i=SQL_SO_STATIC)
 CS(SQL_LIKE_ESCAPE_CLAUSE,s="N")CS(SQL_SEARCH_PATTERN_ESCAPE,s="")CS(SQL_SERVER_NAME,s="")CS(SQL_SPECIAL_CHARACTERS,s="")
 CS(SQL_TABLE_TERM,s="table")CS(SQL_TIMEDATE_ADD_INTERVALS,i=0)
 CS(SQL_TIMEDATE_DIFF_INTERVALS,i=0)CS(SQL_TXN_CAPABLE,h=SQL_TC_ALL)
 CS(SQL_TXN_ISOLATION_OPTION,i=SQL_TXN_SERIALIZABLE)CS(SQL_USER_NAME,s="")
 CS(SQL_SQL_CONFORMANCE,i=SQL_SC_SQL92_ENTRY)CS(SQL_ODBC_SQL_CONFORMANCE,h=SQL_OSC_MINIMUM)
 CS(SQL_MAX_ROW_SIZE_INCLUDES_LONG,s="Y")CS(SQL_OUTER_JOINS,s="Y")
 CS(SQL_FETCH_DIRECTION,i=0x3F)CS(SQL_LOCK_TYPES,i=SQL_LCK_NO_CHANGE)CS(SQL_ODBC_API_CONFORMANCE,h=SQL_OAC_LEVEL2)
 CS(SQL_POSITIONED_STATEMENTS,i=0)CS(SQL_POS_OPERATIONS,i=SQL_POS_POSITION)
 CS(SQL_SCROLL_CONCURRENCY,i=SQL_SCCO_READ_ONLY)CS(SQL_STATIC_SENSITIVITY,i=0)}
R s?(*h2=sns(v,h1,s)):i!=-2?(*h2=4,*(I*)v=i):(*h2=2,*(UH*)v=h),0;}
//A SQLNumParams(D h,H*j){Q1("npar")}A SQLBindParameter(D h,UH i,H it,H vt,H pt,L w,H d,V*v,L n,L*p){Q1("bpar")}
