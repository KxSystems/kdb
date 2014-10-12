#include"c.h" 

// 1: reassemble  CLASS(5-25hours 70-300lines)  READ(.5hour) k(1hour)+c(1hour) 6lines

// overlap
I f(S s,S t){I a=strlen(s),b=strlen(t),m=0;P(strstr(s,t),b)N(MIN(a,b),I(!memcmp(s+a-i,t,i))m=i)R m;}

// merge
V g(I n,S*b){I m=0,mi=0,mj=1;N(n,J(n,I k=i!=j?f(b[i],b[j]):0;I(m<k)m=k,mi=i,mj=j))  // m-max mi mj
 S s=b[mi],t=b[mj];b[mi]=strcat(strcpy(malloc(strlen(s)+strlen(t)+1-m),s),t+m),b[mj]=b[n-1],free(s),free(t);}

// run
I main(I n,S*x){L m;S b[20000],s=map(&m,x[1]);A(s)n=0;
 N(m,I h;I('{'==s[i])h=i+1;I('}'==s[i])b[n++]=strndup(s+h,i-h))
 W(1<n)g(n--,b);O("%s\n",*b),free(*b);}
