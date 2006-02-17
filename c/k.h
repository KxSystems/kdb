#define O printf
#define R return
#define Z static
#define P(x,y) {if(x)R(y);}
#define U(x) P(!(x),0)
#define SW switch
#define CS(n,x)	case n:x;break;
#define CD default
#define DO(n,x)	{I i=0,_i=(n);for(;i<_i;++i){x;}}

#define nh ((I)0xFFFF8000)
#define wh ((I)0x7FFF)
#define ni ((I)0x80000000)
#define wi ((I)0x7FFFFFFF)
#ifdef WIN32
#define nj ((J)0x8000000000000000)
#define wj ((J)0x7FFFFFFFFFFFFFFF)
#define nf (log(-1.0))
#define wf (-log(0.0))
#define isnan _isnan
#define finite _finite
typedef long I;typedef __int64 J;extern double log();
#else  
#define nj 0x8000000000000000LL
#define wj 0x7FFFFFFFFFFFFFFFLL
#define nf (0/0.0)
#define wf (1/0.0)
#define closesocket(x) close(x)
typedef int I;typedef long long J;
#endif //KBGHIJEFCSMDZUVT*  basetypes: GHIJEFS (G:BC)(I:MDUVT)(F:Z)
typedef unsigned char*A,G,*S,C;typedef short H;typedef float E;typedef double F;typedef void V;
typedef struct k0{I r;H t,u;union{G g;H h;I i;J j;E e;F f;S s;struct k0*k;struct{I n;G G0[1];};};}*K;
//typedef struct k0{I r;H t,u;I n;G G0[1];}*K; //gcc3.0 or later for anonymous unions and anonymous structs

#ifdef __cplusplus
extern"C"{
#endif
extern I khpu(char*,I,char*),khp(char*,I),ymd(I,I,I),dj(I);extern V r0(K),sd0(I);extern S sn(S,I),ss(S);
extern K ka(I),kb(I),kg(I),kh(I),ki(I),kj(J),ke(F),kf(F),kc(I),ks(S),kd(I),kz(F),kt(I),sd1(I,K(*)(I)),
 ktn(I,I),knk(I,...),kp(S),kpn(S,I),ja(K*,A),js(K*,S),jk(K*,K),k(I,char*,...),xT(K),xD(K,K),ktd(K),r1(K),krr(S),orr(S);
#ifdef __cplusplus 
}
#endif

#define ZA Z A
#define ZV Z V
#define ZK Z K
#define ZH Z H
#define ZI Z I
#define ZJ Z J
#define ZE Z E
#define ZF Z F
#define ZC Z C
#define ZS Z S

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

// vector types
#define KB 1
#define KG 4
#define KH 5
#define KI 6
#define KJ 7
#define KE 8
#define KF 9
#define KC 10
#define KS 11
#define KM 13
#define KD 14
#define KZ 15
#define KU 17
#define KV 18
#define KT 19

// table,dict
#define XT 98 //K
#define XD 99 //KK

// remove more clutter
#define K1(f) K f(K x)
#define K2(f) K f(K x,K y)
#define TX(T,x) (*(T*)((G*)(x)+8))
#define xr x->r
#define xt x->t
#define xu x->u
#define xn x->n
#define xk TX(K,x)
#define xx xK[0]
#define xy xK[1]
#define xg TX(G,x)
#define xh TX(H,x)
#define xi TX(I,x)
#define xj TX(J,x)
#define xe TX(E,x)
#define xf TX(F,x)
#define xs TX(S,x)
#define xB ((G*)xG)
#define xG x->G0
#define xH ((H*)xG)
#define xI ((I*)xG)
#define xJ ((J*)xG)
#define xE ((E*)xG)
#define xF ((F*)xG)
#define xC ((C*)xG)
#define xS ((S*)xG)
#define xK ((K*)xG)
