/combinations

/pascal triangle
a:{$[x=y;enlist til x;1=y;flip enlist til x;a[x;y],a[x;y-1],'x-:1]}
a[5;2]

/cross uniques
b:{y{raze x{x,/:last[x]_y}\:y}[;1_til x]/flip enlist til x-y-:1}

/cross uniques
c:{(flip enlist x:til x-y){(x+z){raze x,''y}'x#\:y}[1+x]/til y-:1}

n:10
\t:n a[20;5]
\t:n b[20;5]
\t:n raze c[20;5]

