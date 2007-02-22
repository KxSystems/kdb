#include"k.h" // odbc.ini odbcinst.ini regedit kdb+
#ifdef WIN32
#include<windows.h>
typedef size_t L,UL;
#else
typedef long L;typedef unsigned long UL;extern V*malloc(),free();
#endif
#define SZ sizeof(L)
#include<sqlext.h>
#include<odbcinst.h>
typedef V*D;typedef unsigned short UH;
#define S0 SQL_NTS
#define S1 SQL_NO_DATA_FOUND
#define A SQLRETURN SQL_API
