/ a1(820 1571)  a2(6000 10000)

a:`s#flip`row`col`val!("JJF";",")0:`a1.csv
/a:([]row:0 1 1 2;col:0 0 1 1;val:2 3 4 5.)  /test

/transpose
t:{update row:col,col:row from x}

/multiply
mm:{select sum val*v by row,col from ej[`a;`row`a`v xcol x;`a xcol y]}
\t r:mm[a;t a]

/sparse from matrix
sm:{([]row:where count each i;col:raze i;val:raze x@'i:where each x<>0)}

/matrix from sparse
ms:{./[(1+max x)#0.;x:x[;`row`col];:;x`val]}

b:ms a

\t b$flip b 
