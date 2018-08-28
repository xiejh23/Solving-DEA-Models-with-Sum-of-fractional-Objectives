$ontext

   MDT-based MILP example

   Jianhui Xie, Jun 2017

   Data from:
      Doyle and Green, 1994




$offtext

* =============================================================================


OPTION QCP = cplex;


OPTION solvelink = 0;
OPTION limrow    = 0;
OPTION limcol    = 0;
OPTION SOLPRINT  = OFF;
OPTION optcr     = 0.0;
option sysout    = on
OPTION iterlim   = 10000000;
OPTION reslim    = 10000000;
OPTION decimals=7;


*==============================================================================



SETS
i                index of firms/i1*i5/
l                index of inputs/x1,x2,x3/
k                index of outputs/y1,y2/
;
alias(i,j)
alias (i,iter2);
;

PARAMETERS
   x0(l)   'inputs of firm j0'
   y0(k)  'outputs of firm j0'
   x(l,i)  'inputs of firm i'
   y(k,i) 'outputs of firm i'
   n              sample size
   efficiency(i) 'efficiency of each DMU'
Evalue(i)      residual
;

Table dataC(i,l)
         x1        x2       x3
i1        7        7        7
i2        5        9        7
i3        4        6        5
i4        5        9        8
i5        6        8        5
;

Table Ydata(i,k)
         y1        y2
i1        4        4
i2        7        7
i3        5        7
i4        6        2
i5        3        6
;

x(l,i) = dataC(i,l);
y(k,i) = Ydata(i,k);

x(l,i) = dataC(i,l);
y(k,i) = Ydata(i,k);

positive variables
   v(l)  'input weights'
   u(k) 'output weights'
;

variable
   eff 'efficiency'
   us 'variable returns to scale'
;

equations
   objective  'objective function: maximize efficiency'
   normalize  'normalize input weights'
   limit(i)   "limit other DMU's efficiency";

objective..  eff =e= sum(k, u(k)*y0(k));

normalize..  sum(l, v(l)*x0(l)) =e= 1;

limit(i)..   sum(k, u(k)*y(k,i)) =l= sum(l, v(l)*x(l,i));


model dea /objective, normalize, limit/;


alias (i,iter);




loop(iter,

   x0(l) = x(l, iter);
   y0(k) = y(k, iter);

   solve dea using lp maximizing eff;
   abort$(dea.modelstat<>1) "LP was not optimal";

   efficiency(iter) = eff.l;
);


display efficiency, u.l, v.l;

*------------------model for cross efficiency---------------------------------

Sets
r                index of power/r1*r5/
m                index of digital/m0*m9/

PARAMETERS


effdea(i)    DEA efficiency of DMU(i)
e0           DEA efficiency of DMU(0)
p(r)         power of precision (%)

      / r1   0.1
        r2   0.01
        r3   0.001
        r4   0.0001
        r5   0.00001/

d(m)  The numbers (%)
      / m0   0
        m1   1
        m2   2
        m3   3
        m4   4
        m5   5
        m6   6
        m7   7
        m8   8
        m9   9 /

V_U(l)  the upper bound of v(l)

x_0(l)
y_0(k)


*B_L(i,m)  the lower bound of beta
;
effdea(i) = efficiency(i);
   y0(k) = y(k, 'i4');
   x0(l) = x(l, 'i4');
   e0 = effdea('i4');
*V_U(l) = 1/x0(l);
*B_L(i,m)=0;
*;


V_U(l) = 1;

positive variables
e(i)               cross efficiency of each DMU
w(l,i)             bilinear term 'e(i)*v(l)'
zhat(l,i,r,m)       z-hat variables
DeltaW(l,i)        The slack variables of W
DeltaV(l)          The slack variables of v(l)
;

Binary Variables
z(l,r,m)         Count number of the digital of each power level
;

Variables
ee(iter2,i)    efficiency of DMU(i) when keep j's efficiency
se             sum of efficiencies
;

equations

objective2              'obejective function: maximize sum of efficiencies'
representation(i)       representation of e(i)
repe0                   representation of e(0)
normalize2              'normalize input weights'
limit2(i)               limit other DMU's efficiency
EQ1(l,i)                Represention of wli
EQ2(l,i,r)              Represention of e(i)
EQ3(l)                  Represention of v(l)
EQ4(l,i,r,m)            Lower and upper bound of xhat
EQ5(l,r)                Constraint of z
EQ6(l,i)                Lower and upper bound of
EQ7(l,i)                upper bound of deltawli
EQ8(l,i)                lower bound of deltawli
EQ9(l)                  upper bound of Deltaei
EQ10
;

objective2..         sum(i,e(i)) =e= se;
representation(i)..  sum(l, w(l,i)*x(l,i)) =e= sum(k, u(k)*y(k,i));
repe0..              e0*sum(l, v(l)*x0(l)) =e= sum(k, u(k)*y0(k));
normalize2..         sum(l, v(l)) =e= 1;
limit2(i)..          e(i) =l= 1;

EQ1(l,i)..           w(l,i) =e= sum(r,sum(m,p(r)*d(m)*zhat(l,i,r,m))) + DeltaW(l,i);

EQ2(l,i,r)..         e(i) =e= sum(m,zhat(l,i,r,m));

EQ3(l)..             v(l) =e= sum(r,sum(m,p(r)*d(m)*z(l,r,m))) + DeltaV(l);

EQ4(l,i,r,m)..       zhat(l,i,r,m) =l= effdea(i)*z(l,r,m);

EQ5(l,r)..           sum(m,z(l,r,m)) =e= 1;

EQ6(l,i)..           DeltaW(l,i) =l= effdea(i)*DeltaV(l);

EQ7(l,i)..           DeltaW(l,i) =l= e(i)*p('r5');

EQ8(l,i)..           DeltaW(l,i) =g= effdea(i)*DeltaV(l) + (e(i) - effdea(i))*p('r5');

EQ9(l)..             DeltaV(l) =l= p('r5');

EQ10..               e0 =e= e('i4');


model crossdea /objective2, representation, repe0, limit2, normalize2,
               EQ1, EQ2, EQ3, EQ4, EQ5, EQ6, EQ7, EQ8, EQ9,EQ10/;


OPTION MIP = Cplex;


OPTION solvelink = 0;
OPTION limrow    = 0;
OPTION limcol    = 0;
OPTION SOLPRINT  = OFF;
OPTION optcr     = 0.0;
option sysout    = on
OPTION iterlim   = 10000000;
OPTION reslim    = 10000000;
OPTION decimals=7;

alias (i,iter3);



   solve crossdea using MIP maximizing se;
   display e.l, u.l, v.l, se.l;


