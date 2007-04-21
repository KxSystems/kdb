//2007.04.20 sql.Timestamp time date
//2006.10.06 truncate string at null 2006.09.29 Date.Date(); sync with c.cs
//jar cf c.jar *.class
import java.net.*;import java.io.*;import java.sql.*;import java.lang.reflect.Array;import java.text.*;
public class c{public static void main(String[]args){try{ //s.setSoTimeout(ms);
 java.util.TimeZone.setDefault(java.util.TimeZone.getTimeZone("GMT"));
// static long lt(){long t=t();return t+java.util.TimeZone.getDefault().getOffset(t);}
//c c=new c(new ServerSocket(5010));while(true)c.w(2,c.k());
//c c=new c("",5010);Object[]x={"GE",new Double(2.5),new Integer(23)};c.k(".u.upd","trade",x);
c c=new c("",5001);
c.k("0N!",new Time(0));
//Object[]x={new Time(lt()),"xx",new Double(93.5),new Integer(300)};for(int i=0;i<1000;++i)c.ks("upsert","trade",x);c.k("");
//Flip t=td(c.k("select sum size by sym from trade"));O(n(t.x));O(n(t.y[0]));O(at(t.y[0],0)); //cols rows data
 c.close();}catch(Exception e){e.printStackTrace();}}

public Socket s;DataInputStream i;OutputStream o;byte[]b,B;int j,J;boolean a;
void io(Socket x)throws IOException{s=x;i=new DataInputStream(s.getInputStream());o=s.getOutputStream();}
public void close()throws IOException{s.close();i.close();o.close();}
public c(ServerSocket s)throws IOException{io(s.accept());i.read(b=new byte[99]);o.write(b,0,1);}
public c(String h,int p,String u)throws KException,IOException{io(new Socket(h,p));B=new byte[1+ns(u)];J=0;w(u);o.write(B);if(1!=i.read(B,0,1))throw new KException("access");}
public c(String h,int p)throws KException,IOException{this(h,p,System.getProperty("user.name"));}
public static class Month{public int i;public Month(int x){i=x;}public String toString(){int m=i+24000,y=m/12;return i==ni?"":i2(y/100)+i2(y%100)+"-"+i2(1+m%12);}}
public static class Minute{public int i;public Minute(int x){i=x;}public String toString(){return i==ni?"":i2(i/60)+":"+i2(i%60);}}
public static class Second{public int i;public Second(int x){i=x;}public String toString(){return i==ni?"":new Minute(i/60).toString()+':'+i2(i%60);}}
public static class Dict{public Object x;public Object y;public Dict(Object X,Object Y){x=X;y=Y;}}
public static class Flip{public String[]x;public Object[]y;public Flip(Dict X){x=(String[])X.x;y=(Object[])X.y;}public Object at(String s){return y[find(x,s)];}}
public static Flip td(Object X){if(t(X)==98)return(Flip)X;Dict d=(Dict)X;Flip a=(Flip)d.x,b=(Flip)d.y;int m=n(a.x),n=n(b.x);
 String[]x=new String[m+n];System.arraycopy(a.x,0,x,0,m);System.arraycopy(b.x,0,x,m,n);
 Object[]y=new Object[m+n];System.arraycopy(a.y,0,y,0,m);System.arraycopy(b.y,0,y,m,n);return new Flip(new Dict(x,y));}
//object.getClass().isArray()   t(int[]) is .5 isarray is .1 lookup .05
static int t(Object x){return x instanceof Boolean?-1:x instanceof Byte?-4:x instanceof Short?-5:x instanceof Integer?-6:x instanceof Long?-7:
 x instanceof Float?-8:x instanceof Double?-9:x instanceof Character?-10:x instanceof String?-11:x instanceof Month?-13:
 x instanceof Timestamp?-15:x instanceof Time?-19:x instanceof Date?-14:x instanceof Minute?-17:x instanceof Second?-18:
 x instanceof boolean[]?1:x instanceof byte[]?4:x instanceof short[]?5:x instanceof int[]?6:x instanceof long[]?7:
 x instanceof float[]?8:x instanceof double[]?9:x instanceof char[]?10:x instanceof String[]?11:x instanceof Month[]?13:
 x instanceof Timestamp[]?15:x instanceof Time[]?19:x instanceof Date[]?14:x instanceof Minute[]?17:x instanceof Second[]?18:
 x instanceof Flip?98:x instanceof Dict?99:0;}
static int ni=Integer.MIN_VALUE;static long nj=Long.MIN_VALUE;static double nf=Double.NaN;
static int[]nt={0,1,0,0,1,2,4,8,4,8,1,0,0,4,4,8,0,4,4,4};
static int ns(String s){int i;return s==null?0:-1<(i=s.indexOf('\000'))?i:s.length();}
public static Object[]NULL={null,new Boolean(false),null,null,new Byte((byte)0),new Short(Short.MIN_VALUE),new Integer(ni),new Long(nj),new Float(nf),new Double(nf),
 new Character(' '),"",null,new Month(ni),new Date(nj),new Timestamp(nj),null,new Minute(ni),new Second(ni),new Time(nj)};
public static Object NULL(char c){return NULL[" b  xhijefcs mdz uvt".indexOf(c)];}
public static boolean qn(Object x){int t=-t(x);return t>4&&x.equals(NULL[t]);}
public static Object at(Object x,int i){return qn(x=Array.get(x,i))?null:x;}
public static void set(Object x,int i,Object y){Array.set(x,i,null==y?NULL[t(x)]:y);}
static int n(Object x){return x instanceof Dict?n(((Dict)x).x):x instanceof Flip?n(((Flip)x).y[0]):Array.getLength(x);}
static int nx(Object x){int i=0,n,t=t(x),j;if(t==99)return 1+nx(((Dict)x).x)+nx(((Dict)x).y);if(t==98)return 3+nx(((Flip)x).x)+nx(((Flip)x).y);
 if(t<0)return t==-11?2+ns((String)x):1+nt[-t];j=6;n=n(x);if(t==0||t==11)for(;i<n;++i)j+=t==0?nx(((Object[])x)[i]):1+ns(((String[])x)[i]);else j+=n*nt[t];return j;}
static long k=86400000L*10957;void w(Timestamp z){long l=z.getTime();w(l==nj?nf:(l-k)/8.64e7);}
Timestamp rz(){double f=rf();return new Timestamp(Double.isNaN(f)?nj:k+(long)(8.64e7*f));}
void w(Time t){long l=t.getTime();w(l==nj?ni:(int)l);}                Time rt(){int i=ri();return new Time(i==ni?nj:i);}
void w(Date d){long l=d.getTime();w(l==nj?ni:(int)((l-k)/86400000));} Date rd(){int i=ri();return new Date(i==ni?nj:k+86400000L*i);}
void w(byte x){B[J++]=x;}void w(boolean x){w((byte)(x?1:0));}void w(short h){w((byte)(h>>8));w((byte)h);}
void w(int i){w((short)(i>>16));w((short)i);}void w(long j){w((int)(j>>32));w((int)j);}
void w(float e){w(Float.floatToIntBits(e));}void w(double f){w(Double.doubleToLongBits(f));}
void w(char c){w((byte)c);}void w(String s){int i=0,n=ns(s);for(;i<n;)w(s.charAt(i++));B[J++]=0;}
void w(Month m){w(m.i);}void w(Minute u){w(u.i);}void w(Second v){w(v.i);}
void w(Object x){int i=0,n,t=t(x);w((byte)t);if(t<0)switch(t){case-1:w(((Boolean)x).booleanValue());return;
  case-4:w(((Byte)x).byteValue());return;      case-5:w(((Short)x).shortValue());return;
  case-6:w(((Integer)x).intValue());return;    case-7:w(((Long)x).longValue());return;
  case-8:w(((Float)x).floatValue());return;    case-9:w(((Double)x).doubleValue());return;
 case-10:w(((Character)x).charValue());return; case-11:w((String)x);return;
 case-13:w((Month)x);return;case-14:w((Date)x);return;case-15:w((Timestamp)x);return;
 case-17:w((Minute)x);return;case-18:w((Second)x);return;case-19:w((Time)x);return;}
 if(t==99){Dict r=(Dict)x;w(r.x);w(r.y);return;}B[J++]=0;if(t==98){Flip r=(Flip)x;B[J++]=99;w(r.x);w(r.y);return;}
 w(n=n(x));for(;i<n;++i)if(t==0)w(((Object[])x)[i]);else if(t==1)w(((boolean[])x)[i]);else if(t==4)w(((byte[])x)[i]);
 else if(t==5)w(((short[])x)[i]);else if(t==6)w(((int[])x)[i]);else if(t==7)w(((long[])x)[i]);
 else if(t==8)w(((float[])x)[i]);else if(t==9)w(((double[])x)[i]);else if(t==10)w(((char[])x)[i]);
 else if(t==11)w(((String[])x)[i]);else if(t==13)w(((Month[])x)[i]);else if(t==14)w(((Date[])x)[i]);
 else if(t==15)w(((Timestamp[])x)[i]);else if(t==17)w(((Minute[])x)[i]);else if(t==18)w(((Second[])x)[i]);
 else w(((Time[])x)[i]);}

boolean rb(){return 1==b[j++];}short rh(){int x=b[j++],y=b[j++];return(short)(a?x&0xff|y<<8:x<<8|y&0xff);}
int ri(){int x=rh(),y=rh();return a?x&0xffff|y<<16:x<<16|y&0xffff;}long rj(){int x=ri(),y=ri();return a?x&0xffffffffL|(long)y<<32:(long)x<<32|y&0xffffffffL;}
float re(){return Float.intBitsToFloat(ri());}double rf(){return Double.longBitsToDouble(rj());}char rc(){return(char)(b[j++]&0xff);}
String rs(){int i=j;for(;b[j++]!=0;);return new String(b,i,j-1-i);}Month rm(){return new Month(ri());}Minute ru(){return new Minute(ri());}Second rv(){return new Second(ri());}
Object r(){int i=0,n,t=b[j++];if(t<0)switch(t){case-1:return new Boolean(rb());case-4:return new Byte(b[j++]);case-5:return new Short(rh());
  case-6:return new Integer(ri());case-7:return new Long(rj());case-8:return new Float(re());
  case-9:return new Double(rf());case-10:return new Character(rc());case-11:return rs();
  case-13:return rm();case-14:return rd();case-15:return rz();case-17:return ru();case-18:return rv();case-19:return rt();}
 if(t>99){if(t==100){rs();return r();}if(t<104)return b[j++]==0&&t==101?null:"func";if(t>105)r();else for(n=ri();i<n;i++)r();return"func";}
 if(t==99)return new Dict(r(),r());j++;if(t==98)return new Flip((Dict)r());n=ri();switch(t){
  case 0:Object[]L=new Object[n];for(;i<n;i++)L[i]=r();return t==0?L:(Object)"func";  case 1:boolean[]B=new boolean[n];for(;i<n;i++)B[i]=rb();return B;
  case 4:byte[]G=new byte[n];for(;i<n;i++)G[i]=b[j++];return G;   case 5:short[]H=new short[n];for(;i<n;i++)H[i]=rh();return H;
  case 6:int[]I=new int[n];for(;i<n;i++)I[i]=ri();return I;       case 7:long[]J=new long[n];for(;i<n;i++)J[i]=rj();return J;
  case 8:float[]E=new float[n];for(;i<n;i++)E[i]=re();return E;	  case 9:double[]F=new double[n];for(;i<n;i++)F[i]=rf();return F;
 case 10:char[]C=new char[n];for(;i<n;i++)C[i]=rc();return C;    case 11:String[]S=new String[n];for(;i<n;i++)S[i]=rs();return S;
 case 13:Month[]M=new Month[n];for(;i<n;i++)M[i]=rm();return M;  case 14:Date[]D=new Date[n];for(;i<n;i++)D[i]=rd();return D;
 case 17:Minute[]U=new Minute[n];for(;i<n;i++)U[i]=ru();return U;case 15:Timestamp[]Z=new Timestamp[n];for(;i<n;i++)Z[i]=rz();return Z;
 case 18:Second[]V=new Second[n];for(;i<n;i++)V[i]=rv();return V;case 19:Time[]T=new Time[n];for(;i<n;i++)T[i]=rt();return T;}return null;}

void w(int i,Object x)throws IOException{int n=nx(x)+8;synchronized(o){B=new byte[n];B[0]=0;B[1]=(byte)i;J=4;w(n);w(x);o.write(B);}}
public void ks(String s)throws IOException{w(0,cs(s));} char[]cs(String s){return s.toCharArray();}
public void ks(String s,Object x)throws IOException{Object[]a={cs(s),x};w(0,a);}
public void ks(String s,Object x,Object y)throws IOException{Object[]a={cs(s),x,y};w(0,a);}
public void ks(String s,Object x,Object y,Object z)throws IOException{Object[]a={cs(s),x,y,z};w(0,a);}
public static class KException extends Exception{KException(String s){super(s);}}
public Object k()throws KException,IOException{synchronized(i){i.readFully(b=new byte[8]);a=b[0]==1;j=4;
 i.readFully(b=new byte[ri()-8]);if(b[0]==-128){j=1;throw new KException(rs());}j=0;return r();}}
public synchronized Object k(Object x)throws KException,IOException{w(1,x);return k();}
public Object k(String s)throws KException,IOException{return k(cs(s));}
public Object k(String s,Object x)throws KException,IOException{Object[]a={cs(s),x};return k(a);}
public Object k(String s,Object x,Object y)throws KException,IOException{Object[]a={cs(s),x,y};return k(a);}
public Object k(String s,Object x,Object y,Object z)throws KException,IOException{Object[]a={cs(s),x,y,z};return k(a);}
static int find(String[]x,String y){int i=0;for(;i<x.length&&!x[i].equals(y);)++i;return i;}
static void O(Object x){System.out.println(x);}static void O(int x){System.out.println(x);}static void O(boolean x){System.out.println(x);}
static void O(long x){System.out.println(x);}static void O(double x){System.out.println(x);}
static long t(){return System.currentTimeMillis();}static long t;static void tm(){long u=t;t=t();if(u>0)O(t-u);}
static String i2(int i){return new DecimalFormat("00").format(i);}
}
