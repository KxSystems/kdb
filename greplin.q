/greplin.com programming challenge

/utilities
/fibonacci
f:1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 6765 10946 17711 28657 46368 75025 121393 196418 317811 514229 832040
/primes
p:{$[x<4;enlist 2;r,1_where not any x#'not til each r:p ceiling sqrt x]}
/all subsets
s:{neg[x]#flip 0b vs/:til prd x#2}


/ 1. longest substring match reverse
x where{x~reverse x}each x@:til[7]+/:til count x:"..oranynartionso..struggledherehaveconsecrated..increaseddevotion.."

/ 2. sum prime factors of 1+firstprimefib > 227000
sum x*not(1+f first where(f in x)&f>227000)mod x:p 1000000

/ 3. count subsets with max=sum remaining
sum(2*max x)=sum x*:s count x:3 4 9 14 15 19 28 37 47 50 54 56 59 61 70 73 78 81 92 95 97 99

