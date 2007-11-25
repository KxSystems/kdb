pi:acos -1

/ normal from x
nx:{abs(x>0)-(exp[-.5*x*x]%sqrt 2*pi)*t*.31938153+t*-.356563782+t*1.781477937+t*-1.821255978+1.330274429*t:1%1+.2316419*abs x}

/ x from normal
xn:{sqrt[2]*prds[y*count[x]#y]$x%y:-1+2*y}{xexp[.5*sqrt pi;n]*x%n:1+2*til count x:x{x,sum(x*reverse x)%sums 1+4*til count x}/1.0}20

/ normal distribution, e.g. nor 10
nor:{$[x=2*n:x div 2;raze sqrt[-2*log n?1f]*/:(sin;cos)@\:(2*pi)*n?1f;-1_nor 1+x]}

/ builtins: avg var dev med wavg cov cor avgs 

/ covariance matrix (8 times faster than x cov/:\:x)
cvm:{(x+flip(not n=\:n)*x:(n#'0.0),'(x$/:'(n:til count x)_\:x)%count first x)-a*\:a:avg each x}

/ correlation matrix
crm:{cvm[x]%u*/:u:dev each x}

