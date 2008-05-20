//WIN32: cl d0.c user32.lib odbccp32.lib
//WIN64: cl d0.c user32.lib odbccp32.lib bufferoverflowU.lib
#include"../c/c/d.h"
I main(){C b[99];I u;S d="qodbc.dll";
 SQLRemoveDriver("kdb+",0,&u);
 SQLInstallDriverEx("kdb+\0driver=qodbc.dll\0",0,b,99,0,ODBC_INSTALL_COMPLETE,&u);
 CopyFile(d,strcat(strcat(b,"\\"),d),0);}
// 02.50 YYN ..