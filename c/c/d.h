#if WIN32||_WIN64
#include<windows.h>
typedef long I;typedef unsigned long UI;typedef __int64 J;typedef unsigned __int64 UJ;
#define nj ((J)0x8000000000000000)
#define isnan _isnan
#ifndef _WIN64
typedef UI L;
#else
typedef unsigned long long L;
#endif
#else
typedef int I;typedef unsigned int UI;typedef long long J;typedef unsigned long long UJ;
typedef long L;
#define nj 0x8000000000000000LL
static void*GetForegroundWindow(){return 0;}extern void*malloc();
#endif
typedef unsigned char*S,C,G;typedef short H;typedef float E;typedef double F;typedef void V;
#if KXVER>=3
typedef struct k0{signed char m,a,t;C u;I r;union{G g;H h;I i;J j;E e;F f;S s;struct k0*k;struct{J n;G G0[1];};};}*K;
typedef struct{G g[16];}U;
#define kU(x) ((U*)kG(x))
#define xU ((U*)xG)
extern K ku(U),ktn(I,J),kpn(S,J);
#define DO(n,x)	{J i=0,_i=(n);for(;i<_i;++i){x;}}
#else
typedef struct k0{I r;H t,u;union{G g;H h;I i;J j;E e;F f;S s;struct k0*k;struct{I n;G G0[1];};};}*K;
extern K ktn(I,I),kpn(S,I);
#define DO(n,x)	{I i=0,_i=(n);for(;i<_i;++i){x;}}
#endif
typedef V*D;typedef unsigned short UH;
#include<sqlext.h>
#include<odbcinst.h>
typedef struct tagSS_TIME2_STRUCT {  
   SQLUSMALLINT hour;  
   SQLUSMALLINT minute;  
   SQLUSMALLINT second;  
   SQLUINTEGER fraction;  
} SS_TIME2;
typedef struct tagSS_TIMESTAMPOFFSET_STRUCT {  
   SQLSMALLINT year;  
   SQLUSMALLINT month;  
   SQLUSMALLINT day;  
   SQLUSMALLINT hour;  
   SQLUSMALLINT minute;  
   SQLUSMALLINT second;  
   SQLUINTEGER fraction;  
   SQLSMALLINT timezone_hour;  
   SQLSMALLINT timezone_minute;  
} SS_TIMESTAMPOFFSET;
#define S0 SQL_NTS
#define S1 SQL_NO_DATA_FOUND
#define A SQLRETURN SQL_API
#define ZA Z A
#define SZ	(I)sizeof(K) //S,K
#define ni ((I)0x80000000)
#define nh ((I)0xFFFF8000)

// vector accessors, e.g. kF(x)[i] for float&datetime
#define kG(x)	((x)->G0)
#define kC(x)	kG(x)
#define kH(x)	((H*)kG(x))
#define kI(x)	((I*)kG(x))
#define kJ(x)	((J*)kG(x))
#define kE(x)	((E*)kG(x))
#define kF(x)	((F*)kG(x))
#define kS(x)	((S*)kG(x))
#define kK(x)	((K*)kG(x))

//      type bytes qtype    ctype  accessor
#define KB 1  // 1 boolean  char   kG
#define KG 4  // 1 byte     char   kG
#define KH 5  // 2 short    short  kH
#define KI 6  // 4 int      int    kI
#define KJ 7  // 8 long     int64  kJ
#define KE 8  // 4 real     float  kE
#define KF 9  // 8 float    double kF
#define KC 10 // 1 char     char   kC
#define KS 11 // * symbol   char*  kS
#define KP 12 // 8 timestamp long   kJ (nanoseconds from 2000.01.01)
#define KM 13 // 4 month    int    kI
#define KD 14 // 4 date     int    kI (days from 2000.01.01)
#define KZ 15 // 8 datetime double kF (days from 2000.01.01)
#define KN 16 // 8 timespan  long   kJ (nanoseconds)
#define KU 17 // 4 minute   int    kI
#define KV 18 // 4 second   int    kI
#define KT 19 // 4 time     int    kI (millisecond)


// table,dict
#define XT 98 //   x->k is XD
#define XD 99 //   kK(x)[0] is keys. kK(x)[1] is values.

#ifdef __cplusplus
extern"C"{
#endif
extern I khpu(char*,I,char*),khp(char*,I),ymd(I,I,I),dj(I);extern V r0(K),sd0(I);extern S sn(S,I),ss(S);
extern K ka(I),kb(I),kg(I),kh(I),ki(I),kj(J),ke(F),kf(F),kc(I),ks(S),kd(I),kz(F),kt(I),sd1(I,K(*)(I)),dl(V*f,I),
 knk(I,...),kp(S),ja(K*,S),js(K*,S),jk(K*,K),jv(K*,K),k(I,char*,...),xT(K),xD(K,K),ktd(K),r1(K),krr(S),orr(S),dot(K,K);
#ifdef __cplusplus 
}
#endif

// remove more clutter
#define O printf
#define R return
#define Z static
#define P(x,y) {if(x)R(y);}
#define U(x) P(!(x),0)
#define SW switch
#define CS(n,x)	case n:x;break;
#define CD default

#define ZV Z V
#define ZK Z K
#define ZH Z H
#define ZI Z I
#define ZJ Z J
#define ZE Z E
#define ZF Z F
#define ZC Z C
#define ZS Z S

#define K1(f) K f(K x)
#define K2(f) K f(K x,K y)
#define TX(T,x) (*(T*)((G*)(x)+8))
#define xr x->r
#define xt x->t
#define xu x->u
#define xn x->n
#define xx xK[0]
#define xy xK[1]
#define xg TX(G,x)
#define xh TX(H,x)
#define xi TX(I,x)
#define xj TX(J,x)
#define xe TX(E,x)
#define xf TX(F,x)
#define xs TX(S,x)
#define xk TX(K,x)
#define xG x->G0
#define xH ((H*)xG)
#define xI ((I*)xG)
#define xJ ((J*)xG)
#define xE ((E*)xG)
#define xF ((F*)xG)
#define xS ((S*)xG)
#define xK ((K*)xG)
