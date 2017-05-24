//2017.05.23 identify string[] as type 11
//2017.04.18 added ssl/tls support
//2014.01.29 make method n public
//2013.12.19 qn did not detect null guid
//2013.12.10 remove retry logic on authentication fail. For kdb+2.5 and prior, use
//             B=new byte[1+u.Length];Connect(h,p);s=this.GetStream();J=0;w(u);s.Write(B,0,J);if(1!=s.Read(B,0,1))...
//2013.09.16 za represents -0Wd, not 0Nd
//2013.08.20 null val for TimeStamp -> nj
//2012.06.07 fixed scoping of GUID 
//2012.05.29 for use with kdb+v3.0, changed handshake and added Guid. boolean v6->vt tracks type capability.
//2012.01.26 refactored clamp into clampDT, for Date.DateTime()
//2012.01.25 rz() clamp datetime to valid range
//2010.11.17 Block sending new timetypes to version of kdb+ prior to v2.6 (use prior release of c.cs for older kdb+ versions)
//           Max buffer size (default 64kB) used for reading is now a parameter to the c constructor
//           Date, Month, Minute, Second, KTimeSpan are now serializable, implement IComparable
//            and have default constructors for xml serialization.
//           Added NULL(Type t)
//2010.08.05 Added KException for exceptions due to server error, authentication fail and func decode
//2010.01.14 Exposed static var e (Encoding) as public
//2010.01.12 Added support for unicode encoding, defaults to ASCII 
//2010.01.11 Added null checks for qn for UDTs Date,Month,Minute,Second,KTimespan
//2010.01.04 Added new time types (timespan->KTimespan,timestamp->DateTime), drop writing kdb+ datetime
//2009.10.19 Limit reads to blocks of 64kB to reduce load on kernel memory
//2007.09.26 0Wz to MaxValue
//2006.10.05 truncate string at null
//2006.09.29 NULL  c.Date class(sync with c.java)
//Regarding SSL/TLS: To use self-signed certificates add them to the Local Computer Trusted Root Certification Authorities
using System;using System.IO;using System.Net.Sockets;using System.Net.Security;using System.Security.Cryptography.X509Certificates;
namespace kx{
public class c:TcpClient{
/*public static void Main(string[]args){
//c.ReceiveTimeout=1000;
//c c=new c("localhost",5010);c.k(".u.sub[`trade;`MSFT.O`IBM.N]");while(true){object r=c.k();O(n(at(r,2)));}
 c c=new c("localhost",5001);
//c.e=System.Text.Encoding.UTF8;
//O("Unicode "+c.k("`$\"c\"$0x52616e627920426ac3b6726b6c756e64204142"));                                
//object[]x=new object[4];x[0]=t();x[1]="xx";x[2]=(double)93.5;x[3]=300;tm();for(int i=0;i<1000;++i)c.k("insert","trade",x);tm();
//Flip r=td(c.k("select sum price by sym from trade"));O("cols: "+n(r.x));O("rows: "+n(r.y[0]));
 c.Close();
}
*/
private const int DefaultMaxBufferSize=65536;
private readonly int _maxBufferSize=DefaultMaxBufferSize;
public static System.Text.Encoding e=System.Text.Encoding.ASCII;
byte[]b,B;int j,J,vt;bool a;Stream s;public new void Close(){s.Close();base.Close();}
public c(string h,int p):this(h,p,Environment.UserName){}
public c(string h,int p,string u,int maxBufferSize=DefaultMaxBufferSize,bool useTLS=false){_maxBufferSize=maxBufferSize;Connect(h,p);s=this.GetStream();if(useTLS){s=new SslStream(s,false);((SslStream)s).AuthenticateAsClient(h);}B=new byte[2+u.Length];J=0;w(u+"\x3");s.Write(B,0,J);if(1!=s.Read(B,0,1))throw new KException("access");vt=Math.Min(B[0],(byte)3);}
static int ns(string s){int i=s.IndexOf('\0');i=-1<i?i:s.Length;return e.GetBytes(s.Substring(0,i)).Length;}
static TimeSpan t(){return DateTime.Now.TimeOfDay;}static TimeSpan v;static void tm(){TimeSpan u=v;v=t();O(v-u);}
static void O(object x){Console.WriteLine(x);}static string i2(int i){return String.Format("{0:00}",i);}
static int ni=Int32.MinValue;static long nj=Int64.MinValue,o=(long)8.64e11*730119;static double nf=Double.NaN;
static object[]NU={null,false,new Guid(),null,(byte)0,Int16.MinValue,ni,nj,(Single)nf,nf,' ',"",new DateTime(0),
 new Month(ni),new Date(ni),new DateTime(0),new KTimespan(nj),new Minute(ni),new Second(ni),new TimeSpan(nj)};
static object NULL(char c){return NU[" bg xhijefcspmdznuvt".IndexOf(c)];}
public static object NULL(Type t){for(int i=0;i<NU.Length;i++)if(NU[i]!=null&&t==NU[i].GetType())return NU[i];return null;}
public static bool qn(object x){int t=-c.t(x);return(t==2||t>4)&&x.Equals(NU[t]);}
private void u(){int n=0,r=0,f=0,s=8,p=s;short i=0;j=0;byte[]dst=new byte[ri()];int d=j;int[]aa=new int[256];
while(s<dst.Length){if(i==0){f=0xff&(int)b[d++];i=1;}if((f&i)!=0){r=aa[0xff&(int)b[d++]];dst[s++]=dst[r++];dst[s++]=dst[r++];n=0xff&(int)b[d++];for(int m=0;m<n;m++)dst[s+m]=dst[r+m];}
else dst[s++]=b[d++];
while(p<s-1)aa[(0xff&(int)dst[p])^(0xff&(int)dst[p+1])]=p++;if((f&i)!=0)p=s+=n;i*=2;if(i==256)i=0;}
b=dst;j=8;}
static DateTime za=DateTime.MinValue.AddTicks(1),zw=DateTime.MaxValue;
private static long clampDT(long j){return Math.Min(Math.Max(j,za.Ticks),zw.Ticks);}
[Serializable]public class Date:IComparable{public int i;private Date(){}public Date(int x){i=x;}
 public DateTime DateTime(){return i==-int.MaxValue?za:i==int.MaxValue?zw:new DateTime(i==ni?0L:clampDT((long)8.64e11*i+o));}
 public Date(long x){i=x==0L?ni:(int)(x/(long)8.64e11)-730119;}public Date(DateTime z):this(z.Ticks){}
 public override string ToString(){return i==ni?"":this.DateTime().ToString("d");}
 public override bool Equals(object o){if(o==null)return false;if(this.GetType()!=o.GetType())return false;Date d=(Date)o;return i==d.i;}
 public override int GetHashCode(){return i;}
 public int CompareTo(object o){if(o==null)return 1;Date other=o as Date;if(other==null)return 1;return i.CompareTo(other.i);}}
[Serializable]public class Month:IComparable{public int i;private Month(){}public Month(int x){i=x;}
 public override string ToString(){int m=24000+i,y=m/12;return i==ni?"":i2(y/100)+i2(y%100)+"-"+i2(1+m%12);}
 public override bool Equals(object o){if(o==null)return false;if(this.GetType()!=o.GetType())return false;Month m=(Month)o;return i==m.i;}
 public override int GetHashCode(){return i;}
 public int CompareTo(object o){if(o==null)return 1;Month other=o as Month;if(other==null)return 1;return i.CompareTo(other.i);}}
[Serializable]public class Minute:IComparable{public int i;private Minute(){}public Minute(int x){i=x;}
 public override string ToString(){return i==ni?"":i2(i/60)+":"+i2(i%60);}
 public override bool Equals(object o){if(o==null)return false;if(this.GetType()!=o.GetType())return false;Minute m=(Minute)o;return i==m.i;}
 public override int GetHashCode(){return i;}
 public int CompareTo(object o){if(o==null)return 1;Minute other=o as Minute;if(other==null)return 1;return i.CompareTo(other.i);}}
[Serializable]public class Second:IComparable{public int i;private Second(){}public Second(int x){i=x;}
 public override string ToString(){return i==ni?"":new Minute(i/60).ToString()+':'+i2(i%60);}
 public override bool Equals(object o){if(o==null)return false;if(this.GetType()!=o.GetType())return false;Second s=(Second)o;return i==s.i;}
 public override int GetHashCode(){return i;}
 public int CompareTo(object o){if(o==null)return 1;Second other=o as Second;if(other==null)return 1;return i.CompareTo(other.i);}}
[Serializable]public class KTimespan:IComparable{public TimeSpan t;private KTimespan(){}public KTimespan(long x){t=new TimeSpan(x==nj?nj:x/100);}
 public override string ToString(){return qn(t)?"":t.ToString();}
 public override bool Equals(object o){if(o==null)return false;if(this.GetType()!=o.GetType())return false;KTimespan n=(KTimespan)o;return t.Ticks==n.t.Ticks;}
 public override int GetHashCode(){return t.GetHashCode();}
 public int CompareTo(object o){if(o==null)return 1;KTimespan other=o as KTimespan;if(other==null)return 1;return t.CompareTo(other.t);}}
public class Dict{public object x;public object y;public Dict(object X,object Y){x=X;y=Y;}}
static int find(string[]x,string y){int i=0;for(;i<x.Length&&!x[i].Equals(y);)++i;return i;}
public class Flip{public string[]x;public object[]y;public Flip(Dict X){x=(string[])X.x;y=(object[])X.y;}public object at(string s){return y[find(x,s)];}}
public static Flip td(object X){if(t(X)==98)return(Flip)X;Dict d=(Dict)X;Flip a=(Flip)d.x,b=(Flip)d.y;int m=c.n(a.x),n=c.n(b.x);
 string[]x=new string[m+n];Array.Copy(a.x,0,x,0,m);Array.Copy(b.x,0,x,m,n);
 object[]y=new object[m+n];Array.Copy(a.y,0,y,0,m);Array.Copy(b.y,0,y,m,n);return new Flip(new Dict(x,y));}
static int t(object x){return x is bool?-1:x is Guid?-2:x is byte?-4:x is short?-5:x is int?-6:x is long?-7:x is float?-8:x is double?-9:x is char?-10:
 x is string?-11:x is DateTime?-12:x is Month?-13:x is Date?-14:x is DateTime?-15:x is KTimespan?-16:x is Minute?-17:x is Second?-18:x is TimeSpan?-19:
 x is bool[]?1:x is Guid[]?2:x is byte[]?4:x is short[]?5:x is int[]?6:x is long[]?7:x is float[]?8:x is double[]?9:x is char[]?10:x is string[]?11:
 x is DateTime[]?12:x is DateTime[]?15:x is KTimespan[]?16:x is TimeSpan[]?19:x is Flip?98:x is Dict?99:0;}
static int[]nt={0,1,16,0,1,2,4,8,4,8,1,0,8,4,4,8,8,4,4,4};// x.GetType().IsArray
public static int n(object x){return x is Dict?n(((Dict)x).x):x is Flip?n(((Flip)x).y[0]):x is char[]?e.GetBytes((char[])x).Length:((Array)x).Length;}
static int nx(object x){int i=0,n,t=c.t(x),j;if(t==99)return 1+nx(((Dict)x).x)+nx(((Dict)x).y);if(t==98)return 3+nx(((Flip)x).x)+nx(((Flip)x).y);
 if(t<0)return t==-11?2+ns((string)x):1+nt[-t];j=6;n=c.n(x);if(t==0||t==11)for(;i<n;++i)j+=t==0?nx(((object[])x)[i]):1+ns(((string[])x)[i]);else j+=n*nt[t];return j;}
public static object at(object x,int i){object r=((Array)x).GetValue(i);return qn(r)?null:r;} 
//public static void set(object x,int i,object y){Array.set(x,i,null==y?NU[t(x)]:y);}
void w(bool x){B[J++]=(byte)(x?1:0);}bool rb(){return 1==b[j++];}void w(byte x){B[J++]=x;}byte rx(){return b[j++];}
void w(short h){B[J++]=(byte)h;B[J++]=(byte)(h>>8);}short rh(){int x=b[j++],y=b[j++];return(short)(a?x&0xff|y<<8:x<<8|y&0xff);}
void w(int i){w((short)i);w((short)(i>>16));}int ri(){int x=rh(),y=rh();return a?x&0xffff|y<<16:x<<16|y&0xffff;}
private byte[]gip={3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
void w(Guid g){byte[]b=g.ToByteArray();if(vt<3)throw new KException("Guid not valid pre kdb+3.0");for(int i=0;i<b.Length;i++)w(b[gip[i]]);}
Guid rg(){bool oa=a;a=false;int i=ri();short h1=rh(),h2=rh();a=oa;byte[]b=new byte[8];for(int j=0;j<8;j++)b[j]=rx();return new Guid(i,h1,h2,b);}
void w(long j){w((int)j);w((int)(j>>32));}long rj(){int x=ri(),y=ri();return a?x&0xffffffffL|(long)y<<32:(long)x<<32|y&0xffffffffL;}
void w(float e){byte[]b=BitConverter.GetBytes(e);foreach(byte i in b)w(i);}float re(){byte c;float e;
 if(!a){c=b[j];b[j]=b[j+3];b[j+3]=c;c=b[j+1];b[j+1]=b[j+2];b[j+2]=c;}e=BitConverter.ToSingle(b,j);j+=4;return e;}
void w(double f){w(BitConverter.DoubleToInt64Bits(f));}double rf(){return BitConverter.Int64BitsToDouble(rj());}
void w(char c){w((byte)c);}char rc(){return (char)(b[j++]&0xff);}
void w(string s){byte[]b=e.GetBytes(s);foreach(byte i in b)w(i);B[J++]=0;}
string rs(){int k=j;for(;b[j]!=0;++j);string s=e.GetString(b,k,j-k);j++;return s;}
void w(Date d){w(d.i);}Date rd(){return new Date(ri());}   void w(Minute u){w(u.i);}Minute ru(){return new Minute(ri());}    
void w(Month m){w(m.i);}Month rm(){return new Month(ri());}void w(Second v){w(v.i);}Second rv(){return new Second(ri());}
void w(TimeSpan t){if(vt<1)throw new KException("Timespan not valid pre kdb+2.6");w(qn(t)?ni:(int)(t.Ticks/10000));}TimeSpan rt(){int i=ri();return new TimeSpan(qn(i)?nj:10000L*i);}
void w(DateTime p){if(vt<1)throw new KException("Timestamp not valid pre kdb+2.6");w(qn(p)?nj:(100*(p.Ticks-o)));}
DateTime rz(){double f=rf();return Double.IsInfinity(f)?(f<0?za:zw):new DateTime(qn(f)?0:clampDT(10000*(long)Math.Round(8.64e7*f)+o));}
void w(KTimespan t){w(qn(t)?nj:(t.t.Ticks*100));} KTimespan rn(){return new KTimespan(rj());}
DateTime rp(){long j=rj(),d=j<0?(j+1)/100-1:j/100;DateTime p=new DateTime(j==nj?0:o+d);return p;}
void w(object x){int t=c.t(x);w((byte)t);if(t<0)switch(t){case-1:w((bool)x);return;
 case-2:w((Guid)x);return;case-4:w((byte)x);return;
 case-5:w((short)x);return;case-6:w((int)x);return;case-7:w((long)x);return;case-8:w((float)x);return;case-9:w((double)x);return;
 case-10:w((char)x);return;case-11:w((string)x);return;case-12:w((DateTime)x);return;case-13:w((Month)x);return;
 case-14:w((Date)x);return;case-15:w((DateTime)x);return;case-16:w((KTimespan)x);return;case-17:w((Minute)x);return;case-18:w((Second)x);return;
 case-19:w((TimeSpan)x);return;}
 if(t==99){Dict r=(Dict)x;w(r.x);w(r.y);return;}B[J++]=0;if(t==98){Flip r=(Flip)x;B[J++]=99;w(r.x);w(r.y);return;}
 w(c.n(x));switch(t){
  case 0:foreach(object o in(object[])x)w(o);return;           case 1:foreach(bool o in(bool[])x)w(o);return;
  case 2:foreach(Guid o in(Guid[])x)w(o);return;
  case 4:foreach(byte o in(byte[])x)w(o);return;               case 5:foreach(short o in(short[])x)w(o);return;
  case 6:foreach(int o in(int[])x)w(o);return;                 case 7:foreach(long o in(long[])x)w(o);return;
  case 8:foreach(float o in(float[])x)w(o);return;             case 9:foreach(double o in(double[])x)w(o);return;
  case 10:foreach(byte b in e.GetBytes((char[])x))w(b);return; case 11:foreach(string o in(string[])x)w(o);return;
  case 12:foreach(DateTime o in(DateTime[])x)w(o);return;      case 13:foreach(Month o in(Month[])x)w(o);return;
  case 14:foreach(Date o in(Date[])x)w(o);return;              case 15:foreach(DateTime o in(DateTime[])x)w(o);return;
  case 16:foreach(KTimespan o in(KTimespan[])x)w(o);return;    case 17:foreach(Minute o in(Minute[])x)w(o);return;
  case 18:foreach(Second o in(Second[])x)w(o);return;          case 19:foreach(TimeSpan o in(TimeSpan[])x)w(o);return;}
}
object r(){int i=0,n,t=(sbyte)b[j++];if(t<0)switch(t){case-1:return rb();case-2:return rg();case-4:return b[j++]; case-5:return rh();
 case-6:return ri();case-7:return rj();case-8:return re();case-9:return rf();case-10:return rc();case-11:return rs();
 case -12: return rp();case-13:return rm();case-14:return rd();case-15:return rz();case -16:return rn();case-17:return ru();
 case-18:return rv();case-19:return rt();}
 if(t>99){if(t==101&&b[j++]==0)return null;throw new KException("func");}if(t==99)return new Dict(r(),r());j++;if(t==98)return new Flip((Dict)r());n=ri();switch(t){
  case 0:object[]L=new object[n];for(;i<n;i++)L[i]=r();return L;        case 1:bool[]B=new bool[n];for(;i<n;i++)B[i]=rb();return B;
  case 2:{Guid[]G=new Guid[n];for(;i<n;i++)G[i]=rg();return G;}
  case 4:{byte[]G=new byte[n];for(;i<n;i++)G[i]=b[j++];return G;}       case 5:short[]H=new short[n];for(;i<n;i++)H[i]=rh();return H;
  case 6:int[]I=new int[n];for(;i<n;i++)I[i]=ri();return I;             case 7:long[]J=new long[n];for(;i<n;i++)J[i]=rj();return J;
  case 8:float[]E=new float[n];for(;i<n;i++)E[i]=re();return E;         case 9:double[]F=new double[n];for(;i<n;i++)F[i]=rf();return F;
  case 10:char[] C=e.GetChars(b,j,n);j+=n;return C;                     case 11:string[]S=new string[n];for(;i<n;i++)S[i]=rs();return S;
  case 12:DateTime[]P=new DateTime[n];for(;i<n;i++)P[i]=rp();return P;  case 13:Month[]M=new Month[n];for(;i<n;i++)M[i]=rm();return M;
  case 14:Date[]D=new Date[n];for(;i<n;i++)D[i]=rd();return D;          case 15:DateTime[]Z=new DateTime[n];for(;i<n;i++)Z[i]=rz();return Z;
  case 16:KTimespan[]N=new KTimespan[n];for(;i<n;i++)N[i]=rn();return N;case 17:Minute[]U=new Minute[n];for(;i<n;i++)U[i]=ru();return U;
  case 18:Second[]V=new Second[n];for(;i<n;i++)V[i]=rv();return V;      case 19:TimeSpan[]T=new TimeSpan[n];for(;i<n;i++)T[i]=rt();return T;}return null;}
void w(int i,object x){int n=nx(x)+8;B=new byte[n];B[0]=1;B[1]=(byte)i;J=4;w(n);w(x);s.Write(B,0,n);}
void read(byte[]b){int i=0,j,n=b.Length;for(;i<n;i+=j)if(0==(j=s.Read(b,i,Math.Min(_maxBufferSize,n-i))))throw new Exception("read");}
public object k(){read(b=new byte[8]);a=b[0]==1;bool c=b[2]==1;j=4;read(b=new byte[ri()-8]);if(c)u();else j=0;if(b[0]==128){j=1;throw new KException(rs());}return r();}
public object k(object x){w(1,x);return k();}
public object k(string s){return k(cs(s));}char[]cs(string s){return s.ToCharArray();}
public object k(string s,object x){object[]a={cs(s),x};return k(a);}
public object k(string s,object x,object y){object[]a={cs(s),x,y};return k(a);}
public object k(string s,object x,object y,object z){object[]a={cs(s),x,y,z};return k(a);}
public void ks(string s){w(0,cs(s));}
public void ks(string s,Object x){Object[]a={cs(s),x};w(0,a);}
public void ks(string s,Object x,Object y){Object[]a={cs(s),x,y};w(0,a);}
}
public class KException:Exception{
   public KException(){}
   public KException(string message):base(message){}
}
}
