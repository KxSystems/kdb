#ifndef KX
#define KX
typedef char*S,C;typedef const char *S2;typedef unsigned char G;typedef short H;typedef int I;typedef long long J;typedef float E;typedef double F;typedef void V;typedef unsigned long long UJ;
#ifdef __cplusplus
extern"C"{
#endif
#if !defined(KXVER)
// Asof 2023.03.30, default to 3. For kdb+2.x or standalone c-api before 2011-04-20 used KXVER=2
#define KXVER 3
#endif
#if KXVER>=3
typedef struct k0{signed char m,a,t;C u;I r;union{G g;H h;I i;J j;E e;F f;S2 s;struct k0*k;struct{J n;G G0[];};};}*K;
typedef struct{G g[16];}U;
#define kU(x) ((U*)kG(x))
#define xU ((U*)xG)
extern K ku(U),knt(J,K),ktn(I,J),kpn(const S,J);
extern I setm(I),ver();
#define DO(n,x)	{J i=0,_i=(n);for(;i<_i;++i){x;}}
#else
typedef struct k0{I r;H t,u;union{G g;H h;I i;J j;E e;F f;S2 s;struct k0*k;struct{I n;G G0[];};};}*K;
extern K ktn(I,I),kpn(S2,I);
#define DO(n,x)	{I i=0,_i=(n);for(;i<_i;++i){x;}}
#endif
#ifdef __cplusplus
}
#endif
//#include<string.h>
// vector accessors, e.g. kF(x)[i] for float&datetime
#define kG(x)	((x)->G0)
#define kC(x)	kG(x)
#define kH(x)	((H*)kG(x))
#define kI(x)	((I*)kG(x))
#define kJ(x)	((J*)kG(x))
#define kE(x)	((E*)kG(x))
#define kF(x)	((F*)kG(x))
#define kS(x)	((S2*)kG(x))
#define kK(x)	((K*)kG(x))

//      type bytes qtype     ctype  accessor
#define KB 1  // 1 boolean   char   kG
#define UU 2  // 16 guid     U      kU
#define KG 4  // 1 byte      char   kG
#define KH 5  // 2 short     short  kH
#define KI 6  // 4 int       int    kI
#define KJ 7  // 8 long      long   kJ
#define KE 8  // 4 real      float  kE
#define KF 9  // 8 float     double kF
#define KC 10 // 1 char      char   kC
#define KS 11 // * symbol    char*  kS

#define KP 12 // 8 timestamp long   kJ (nanoseconds from 2000.01.01)
#define KM 13 // 4 month     int    kI (months from 2000.01.01)
#define KD 14 // 4 date      int    kI (days from 2000.01.01)

#define KN 16 // 8 timespan  long   kJ (nanoseconds)
#define KU 17 // 4 minute    int    kI
#define KV 18 // 4 second    int    kI
#define KT 19 // 4 time      int    kI (millisecond)

#define KZ 15 // 8 datetime  double kF (DO NOT USE)

// table,dict
#define XT 98 //   x->k is XD
#define XD 99 //   kK(x)[0] is keys. kK(x)[1] is values.

#ifdef __cplusplus
#include<cstdarg>
extern"C"{
extern V m9();
#else
#include<stdarg.h>
extern V m9(V);
#endif
extern J gc(J j);
extern I khpunc(S2,I,S2,I,I),khpun(S2,I,S2,I),khpu(S2,I,S2),khp(S2,I),okx(K),ymd(I,I,I),dj(I);extern V r0(K),sd0(I),sd0x(I d,I f),kclose(I);extern S sn(S2,I),ss(S2);
extern K ee(K),ktj(I,J),ka(I),kb(I),kg(I),kh(I),ki(I),kj(J),ke(F),kf(F),kc(I),ks(S2),kd(I),kz(F),kt(I),sd1(I,K(*)(I)),dl(V*f,J),m4(I),
 knk(I,...),kp(S2),ja(K*,V*),js(K*,S2),jk(K*,K),jv(K*k,K),k(I,S2,...),xT(K),xD(K,K),ktd(K),r1(K),krr(S2),orr(S2),dot(K,K),b9(I,K),d9(K),sslInfo(K x),vaknk(I,va_list),vak(I,S2,va_list),vi(K,UJ),
 vk(K);
#ifdef __cplusplus
}
#endif

// nulls(n?) and infinities(w?)
#define nh ((I)0xFFFF8000)
#define wh ((I)0x7FFF)
#define ni ((I)0x80000000)
#define wi ((I)0x7FFFFFFF)
#define nj ((J)0x8000000000000000LL) 
#define wj 0x7FFFFFFFFFFFFFFFLL
#if defined(WIN32) || defined(_WIN32)
#define nf (log(-1.0))
#define wf (-log(0.0))
#define finite _finite
extern double log(double);
#else  
#define nf (0/0.0)
#define wf (1/0.0)
#define closesocket(x) close(x)
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
#define xC xG
#define xB ((G*)xG)

#endif

