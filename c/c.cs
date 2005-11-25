// 2005.06.23 fix DT
// 2005.04.26 s.Close()
// 2005.03.09 readwrite 0Nd 0Nz
// 2004.10.12 usr:pwd http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpguide/html/cpcontemplatefiles.asp
using System;using System.IO; //csc c.cs  given >q trade.q -p 5001
class c:System.Net.Sockets.TcpClient{public static void Main(string[]args){
 c c=new c("localhost",5001);
 Flip r=td(c.k("select sum price by sym from trade"));O("cols: "+n(r.x));O("rows: "+n(r.y[0]));
// object[]x=new object[4];x[0]=t();x[1]="xx";x[2]=(double)93.5;x[3]=300;
// tm();for(int i=0;i<1000;++i)c.ks("insert", "trade", x);tm();
// c c=new c("localhost",5010);c.k(".u.sub[`trade;`MSFT.O`IBM.N]");while(true){object r=c.k();O(n(at(r,2)));}
 c.Close();}
byte[]b,B;int j,J;bool a;Stream s;public c(string h,int p):this(h,p,System.Environment.UserName){}
public new void Close(){s.Close();base.Close();}
public c(string h,int p,string u):base(h,p){s=this.GetStream();B=new byte[1+u.Length];J=0;w(u);s.Write(B,0,J);if(1!=s.Read(B,0,1))throw new Exception("access");}
static TimeSpan t(){return DateTime.Now.TimeOfDay;}static TimeSpan v;static void tm(){TimeSpan u=v;v=t();O(v-u);}
static void O(object x){Console.WriteLine(x);}static string i2(int i){return String.Format("{0:00}",i);}
static bool dt(DateTime d){return d==d.Date;}static int DT(DateTime[]d){int i=0;for(;i<n(d);++i)if(!dt(d[i]))return 15;return 14;}
static double zd(DateTime d){return d.Ticks==0?Double.NaN:(d.Ticks-o)/8.64e11;}static long o=(long)8.64e11*730119;
public class Dict{public object x;public object y;public Dict(object X,object Y){x=X;y=Y;}}
public class Flip{public string[]x;public object[]y;public Flip(Dict X){x=(string[])X.x;y=(object[])X.y;}}
public class Month{public int i;public Month(int x){i=x;}public override string ToString(){int m=24000+i,y=m/12;return i2(y/100)+i2(y%100)+"-"+i2(1+m%12);}}
public class Minute{public int i;public Minute(int x){i=x;}public override string ToString(){return i2(i/60)+":"+i2(i%60);}}
public class Second{public int i;public Second(int x){i=x;}public override string ToString(){return new Minute(i/60).ToString()+':'+i2(i%60);}}
public static Flip td(object X){if(t(X)==98)return(Flip)X;Dict d=(Dict)X;Flip a=(Flip)d.x,b=(Flip)d.y;int m=c.n(a.x),n=c.n(b.x);
 string[]x=new string[m+n];Array.Copy(a.x,0,x,0,m);Array.Copy(b.x,0,x,m,n);
 object[]y=new object[m+n];Array.Copy(a.y,0,y,0,m);Array.Copy(b.y,0,y,m,n);return new Flip(new Dict(x,y));}
static int t(object x){return x is bool?-1:x is byte?-4:x is short?-5:x is int?-6:x is long?-7:x is float?-8:x is double?-9:x is char?-10:
 x is string?-11:x is Month?-13:x is DateTime?(dt((DateTime)x)?-14:-15):x is Minute?-17:x is Second?-18:x is TimeSpan?-19:
 x is bool[]?1:x is byte[]?4:x is short[]?5:x is int[]?6:x is long[]?7:x is float[]?8:x is double[]?9:x is char[]?10:
 x is DateTime[]?DT((DateTime[])x):x is TimeSpan[]?19:x is Flip?98:x is Dict?99:0;}
static int[]nt={0,1,0,0,1,2,4,8,4,8,1,0,0,4,4,8,4,4,4,4}; // x.GetType().IsArray
static int n(object x){return x is Dict?n(((Dict)x).x):x is Flip?n(((Flip)x).y[0]):((Array)x).Length;}
static int nx(object x){int i=0,n,t=c.t(x),j;if(t==99)return 1+nx(((Dict)x).x)+nx(((Dict)x).y);if(t==98)return 3+nx(((Flip)x).x)+nx(((Flip)x).y);
 if(t<0)return t==-11?2+((string)x).Length:1+nt[-t];j=6;n=c.n(x);if(t==0)for(;i<n;++i)j+=nx(((object[])x)[i]);else j+=n*nt[t];return j;}
public static bool qn(object x){int t=-c.t(x);return t==5?(short)x==Int16.MinValue:t==6?(int)x==Int32.MinValue:t==7?(long)x==Int64.MinValue:
 t==8?Single.IsNaN((float)x):t==9?Double.IsNaN((double)x):t==14||t==15?0L==((DateTime)x).Ticks:t==19?qn(((TimeSpan)x).Ticks):false;}
public static object at(object x,int i){object r=((Array)x).GetValue(i);return qn(r)?null:r;} 

void w(bool x){B[J++]=(byte)(x?1:0);}bool rb(){return 1==b[j++];}void w(byte x){B[J++]=x;}byte rx(){return b[j++];}
void w(short h){B[J++]=(byte)h;B[J++]=(byte)(h>>8);}short rh(){int x=b[j++],y=b[j++];return(short)(a?x&0xff|y<<8:x<<8|y&0xff);}
void w(int i){w((short)i);w((short)(i>>16));}int ri(){int x=rh(),y=rh();return a?x&0xffff|y<<16:x<<16|y&0xffff;}
void w(long j){w((int)j);w((int)(j>>32));}long rj(){int x=ri(),y=ri();return a?x&0xffffffffL|(long)y<<32:(long)x<<32|y&0xffffffffL;}
void w(float e){byte[]b=BitConverter.GetBytes(e);foreach(byte i in b)w(i);}float re(){byte c;float e;
 if(!a){c=b[j];b[j]=b[j+3];b[j+3]=c;c=b[j+1];b[j+1]=b[j+2];b[j+2]=c;}e=BitConverter.ToSingle(b,j);j+=4;return e;}
void w(double f){w(BitConverter.DoubleToInt64Bits(f));}double rf(){return BitConverter.Int64BitsToDouble(rj());}
void w(char c){w((byte)c);}char rc(){return(char)(b[j++]&0xff);}void w(string s){foreach(char i in s)w(i);B[J++]=0;}
string rs(){int i=0,k=j;for(;b[k]!=0;)++k;char[]s=new char[k-j];for(;j<k;)s[i++]=(char)(0xFF&b[j++]);++j;return new string(s);}
void w(Month m){w(m.i);}Month rm(){int i=ri();return qn(i)?null:new Month(i);}
void w(Minute u){w(u.i);}Minute ru(){int i=ri();return qn(i)?null:new Minute(i);}
void w(Second v){w(v.i);}Second rv(){int i=ri();return qn(i)?null:new Second(i);}
void w(DateTime d){w((int)zd(d));} DateTime rd(){int i=ri();return new DateTime(qn(i)?0:(long)(8.64e11*i)+o);}
void W(DateTime z){w(zd(z));}   DateTime rz(){double f=rf();return new DateTime(qn(f)?0:(long)(8.64e11*f)+o);}
void w(TimeSpan t){w((int)(t.Ticks/10000));}TimeSpan rt(){return new TimeSpan(10000L*ri());}
void w(object x){int i=0,n,t=c.t(x);w((byte)t);if(t<0)switch(t){case-1:w((bool)x);return;case-4:w((byte)x);return;
 case-5:w((short)x);return;case-6:w((int)x);return;case-7:w((long)x);return;case-8:w((float)x);return;case-9:w((double)x);return;
 case-10:w((char)x);return;case-11:w((string)x);return;case-13:w((Month)x);return;case-17:w((Minute)x);return;case-18:w((Second)x);return;
 case-14:w((DateTime)x);return;case-15:W((DateTime)x);return;case-19:w((TimeSpan)x);return;}
 if(t==99){Dict r=(Dict)x;w(r.x);w(r.y);return;}B[J++]=0;if(t==98){Flip r=(Flip)x;B[J++]=99;w(r.x);w(r.y);return;}
 w(n=c.n(x));for(;i<n;++i)if(t==0)w(((object[])x)[i]);else if(t==1)w(((bool[])x)[i]);else if(t==4)w(((byte[])x)[i]);
 else if(t==5)w(((short[])x)[i]);else if(t==6)w(((int[])x)[i]);else if(t==7)w(((long[])x)[i]);
 else if(t==8)w(((float[])x)[i]);else if(t==9)w(((double[])x)[i]);else if(t==10)w(((char[])x)[i]);
 else if(t==14)w(((DateTime[])x)[i]);else if(t==15)W(((DateTime[])x)[i]);else if(t==19)w(((TimeSpan[])x)[i]);}
object r(){int i=0,n,t=(sbyte)b[j++];if(t<0)switch(t){case-1:return rb();case-4:return b[j++];case-5:return rh();
 case-6:return ri();case-7:return rj();case-8:return re();case-9:return rf();case-10:return rc();case-11:return rs();
 case-13:return rm();case-14:return rd();case-15:return rz();case-17:return ru();case-18:return rv();case-19:return rt();}
 if(t>99){if(t==101&&b[j++]==0)return null;throw new Exception("func");}if(t==99)return new Dict(r(),r());j++;if(t==98)return new Flip((Dict)r());n=ri();switch(t){
  case 0:object[]L=new object[n];for(;i<n;i++)L[i]=r();return L;  case 1:bool[]B=new bool[n];for(;i<n;i++)B[i]=rb();return B;
  case 4:byte[]G=new byte[n];for(;i<n;i++)G[i]=b[j++];return G;   case 5:short[]H=new short[n];for(;i<n;i++)H[i]=rh();return H;
  case 6:int[]I=new int[n];for(;i<n;i++)I[i]=ri();return I;       case 7:long[]J=new long[n];for(;i<n;i++)J[i]=rj();return J;
  case 8:float[]E=new float[n];for(;i<n;i++)E[i]=re();return E;   case 9:double[]F=new double[n];for(;i<n;i++)F[i]=rf();return F;
 case 10:char[]C=new char[n];for(;i<n;i++)C[i]=rc();return C;    case 11:String[]S=new String[n];for(;i<n;i++)S[i]=rs();return S;
 case 13:Month[]M=new Month[n];for(;i<n;i++)M[i]=rm();return M;  case 14:DateTime[]D=new DateTime[n];for(;i<n;i++)D[i]=rd();return D;
 case 17:Minute[]U=new Minute[n];for(;i<n;i++)U[i]=ru();return U;case 15:DateTime[]Z=new DateTime[n];for(;i<n;i++)Z[i]=rz();return Z;
 case 18:Second[]V=new Second[n];for(;i<n;i++)V[i]=rv();return V;case 19:TimeSpan[]T=new TimeSpan[n];for(;i<n;i++)T[i]=rt();return T;}return null;}
void w(int i,object x){int n=nx(x)+8;B=new byte[n];B[0]=1;B[1]=(byte)i;J=4;w(n);w(x);s.Write(B,0,n);}
public object k(){s.Read(b=new byte[8],0,8);a=b[0]==1;j=4;int i=0,m=ri()-8;b=new byte[m];
 for(;i<m;i+=j)j=s.Read(b,i,m-i);if(b[0]==128){j=1;throw new Exception(rs());}j=0;return r();}
public object k(object x){w(1,x);return k();}
public object k(string s){return k(cs(s));}char[]cs(string s){return s.ToCharArray();}
public object k(string s,object x){object[]a={cs(s),x};return k(a);}
public object k(string s,object x,object y){object[]a={cs(s),x,y};return k(a);}
public object k(string s,object x,object y,object z){object[]a={cs(s),x,y,z};return k(a);}
public void ks(String s){w(0,cs(s));}
public void ks(String s,Object x){Object[]a={cs(s),x};w(0,a);}
public void ks(String s,Object x,Object y){Object[]a={cs(s),x,y};w(0,a);}
}
