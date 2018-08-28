$ontext

   MDT-based MILP example of two-stage process

   Jianhui Xie, Jun 2017

   Data from:
            Kao and Hwang 2008



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
i                index of firms/i1*i24/
l                index of inputs/x1,x2/
t                index of intermeadiate products/z1,z2/
k                index of outputs/y1,y2/
;
alias(i,j)
alias (i,iter2);
;

PARAMETERS
   x0(l)   'inputs of firm j0'
   z0(t)   'intermediate products of firm j0'
   y0(k)   'outputs of firm j0'
   e011    'efficiency of stage 1 of DMU j0 when stage 1 is regarded as leader'
   e012    'efficiency of stage 2 of DMU j0 when stage 1 is regarded as leader'
   e021    'efficiency of stage 1 of DMU j0 when stage 2 is regarded as leader'
   e022    'efficiency of stage 2 of DMU j0 when stage 2 is regarded as leader'
   x(l,i)  'inputs of firm i'
   z(t,i)  'intermediate products of firm i'
   y(k,i)  'outputs of firm i'
   n              sample size
   efficiency11(i) 'efficiency of stage 1 of DMU i when stage 1 is regarded as leader'
   efficiency12(i) 'efficiency of stage 2 of DMU i when stage 1 is regarded as leader'
   efficiency21(i) 'efficiency of stage 1 of DMU i when stage 2 is regarded as leader'
   efficiency22(i) 'efficiency of stage 2 of DMU i when stage 2 is regarded as leader'
;

Table dataC(i,l)
             x1             x2
i1         1178744        673512
i2         1381822        1352755
i3         1177494        592790
i4         601320         594259
i5         6699063        3531614
i6         2627707        668363
i7         1942833        1443100
i8         3789001        1873530
i9         1567746        950432
i10        1303249        1298470
i11        1962448        672414
i12        2592790        650952
i13        2609941        1368802
i14        1396002        988888
i15        2184944        651063
i16        1211716        415071
i17        1453797        1085019
i18        757515         547997
i19        159422         182338
i20        145442         53518
i21        84171          26224
i22        15993          10502
i23        54693          28408
i24        163297         235094
;

Table Ydata(i,k)
             y1             y2
i1         984143         681687
i2         1228502        834754
i3         293613         658428
i4         248709         177331
i5         7851229        3925272
i6         1713598        415058
i7         2239593        439039
i8         3899530        622868
i9         1043778        264098
i10        1697941        554806
i11        1486014        18259
i12        1574191        909295
i13        3609236        223047
i14        1401200        332283
i15        3355197        555482
i16        854054         197947
i17        3144484        371984
i18        692731         163927
i19        519121         46857
i20        355624         26537
i21        51950          6491
i22        82141          4181
i23        0.1            18980
i24        142370         16976
;

Table Zdata(i,t)
              z1            z2
i1         7451757         856735
i2         10020274        1812894
i3         4776548         560244
i4         3174851         371863
i5         37392862        1753794
i6         9747908         952326
i7         10685457        643412
i8         17267266        1134600
i9         11473162        546337
i10        8210389         504528
i11        7222378         643178
i12        9434406         1118489
i13        13921464        811343
i14        7396396         465509
i15        10422297        749893
i16        5606013         402881
i17        7695461         342489
i18        3631484         995620
i19        1141950         483291
i20        316829          131920
i21        225888          40542
i22        52063           14574
i23        245910          49864
i24        476419          644816
;


x(l,i) = dataC(i,l);
z(t,i) = Zdata(i,t);
y(k,i) = Ydata(i,k);

*------------------model for e11---------------------------------

positive variables
   v(l)  'input weights'
   o(t)  'intermediate product weights'
   u(k)  'output weights'
;

variable
   eff 'efficiency'
   us 'variable returns to scale'
;

equations
   objective  'objective function: maximize efficiency of stage 1 when it is leader'
   normalize  'normalize input weights'
   limit1(i)  "constraint of stage 1"
   limit2(i)  "constraint of stage 2"
;

objective..   eff =e= sum(t, o(t)*z0(t));

normalize..   sum(l, v(l)*x0(l)) =e= 1;

limit1(i)..   sum(k, u(k)*y(k,i)) =l= sum(t, o(t)*z(t,i));

limit2(i)..   sum(t, o(t)*z(t,i)) =l= sum(l, v(l)*x(l,i));

model dea /objective, normalize, limit1, limit2/;


alias (i,iter);




loop(iter,

   x0(l) = x(l, iter);
   y0(k) = y(k, iter);
   z0(t) = z(t, iter);
   solve dea using lp maximizing eff;
   abort$(dea.modelstat<>1) "LP was not optimal";

   efficiency11(iter) = eff.l;
);


display efficiency11, u.l, v.l, o.l;


*------------------model for e12---------------------------------
equations
   objective2  'objective function: maximize efficiency of stage 2 when stage 1 is leader'
   normalize2  'normalize input weights'
   limit3(i)   'keep the efficiency of stage 1'
;

objective2..   eff =e= sum(k, u(k)*y0(k));
normalize2..   sum(t, o(t)*z0(t)) =e= 1;
limit3(i)..    sum(t, o(t)*z0(t)) =e= e011*sum(l, v(l)*x0(l));

model dea2 /objective2, normalize2, limit1, limit2, limit3/;

loop(iter,

   x0(l) = x(l, iter);
   y0(k) = y(k, iter);
   z0(t) = z(t, iter);
   e011 = efficiency11(iter);
   solve dea2 using lp maximizing eff;
   abort$(dea.modelstat<>1) "LP was not optimal";

   efficiency12(iter) = eff.l;
);


display efficiency12, u.l, v.l, o.l;

*------------------model for e22---------------------------------



model dea3 /objective2, normalize2, limit1, limit2/;

loop(iter,

   x0(l) = x(l, iter);
   y0(k) = y(k, iter);
   z0(t) = z(t, iter);
   solve dea3 using lp maximizing eff;
   abort$(dea.modelstat<>1) "LP was not optimal";

   efficiency22(iter) = eff.l;
);


display efficiency22, u.l, v.l, o.l;


*------------------model for e21---------------------------------

equations
   limit4(i)   'keep the optimal efficiency of stage 2'
;

limit4(i)..    sum(k, u(k)*y0(k)) =e= e022*sum(t, o(t)*z0(t));

model dea4 /objective, normalize, limit1, limit2, limit4/;

loop(iter,

   x0(l) = x(l, iter);
   y0(k) = y(k, iter);
   z0(t) = z(t, iter);
   e022 = efficiency22(iter);
   solve dea4 using lp maximizing eff;
   abort$(dea.modelstat<>1) "LP was not optimal";

   efficiency21(iter) = eff.l;
);

display efficiency21, u.l, v.l, o.l;



*------------------model for global optimal integrated efficiency---------------------------------

Sets
r                index of power/r1*r4/
m                index of digital/m0*m9/

PARAMETERS

E1_L         'the lower bound of E1'
E1_U         'the upper bound of E1'
E2_L         'the lower bound of E2'
E2_U         'the upper bound of E2'
EE1(i)       'the final optimal efficiency of stage 1 for DMU i'
EE2(i)       'the final optimal efficiency of stage 2 for DMU i'
E(i)         'the final optimal efficiency of the whole system for DMU i'
p(r)         power of precision (%)

      / r1   0.1
        r2   0.01
        r3   0.001
        r4   0.0001/

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
;

positive variables
   E1            'the efficiency of stage 1'
   E2            'the efficiency of stage 2'
   w             'representation of bilinear term: w=E1*E2'
   DeltaW        'the slack of w12'
   Deltalambda   'the slack of lambda'
   ahat(r,m)     'E1*z(r,m)'

;

variables
se            the value of objective function
;

binary variables

a(r,m)
;




equations
   objective3              'objective function of the integrated efficiency'
   normalize5              'normalize input weights: sum(v(l)*x0(l)) = 1'
   limit51(i)              "constraint of stage 1"
   limit52(i)              "constraint of stage 2"
   R1                      'representation1: w12=E1*E2'
   R2                      'representation1: E1=sum(t,o(l)z0(l))'
   EQ1                     Represention of w
   EQ2(r)                  Represention of E1
   EQ3                     Represention of E2
   EQ4(r,m)                upper bound of zhat
   EQ42(r,m)               lower bound of zhat
   EQ5(r)                  Sum of z(rm)is 1 for each r
   EQ6                     the first upper bound of deltaw: this part is the McCormick envelop
   EQ62                    the first lower bound of...
   EQ7                     the second upper bound of deltaw
   EQ8                     the second lower bound of deltaw
   EQ9                     upper bound of Deltalambda
;

objective3..   se =e= 0.5*(E1+E2);

normalize5..   sum(l, v(l)*x0(l)) =e= 1;

limit51(i)..   sum(k, u(k)*y(k,i)) =l= sum(t, o(t)*z(t,i));

limit52(i)..   sum(t, o(t)*z(t,i)) =l= sum(l, v(l)*x(l,i));

R1..           w =e= sum(k, u(k)*y0(k));

R2..           E1 =e= sum(t, o(t)*z0(t));

EQ1..          w =e= E1*E2_L + (E2_U - E2_L)*(sum(r,sum(m,p(r)*d(m)*ahat(r,m))) + DeltaW);

EQ2(r)..       E1 =e= sum(m,ahat(r,m));

EQ3..          E2 =e= E2_L + (E2_U - E2_L)*(sum(r,sum(m,p(r)*d(m)*a(r,m))) + Deltalambda);

EQ4(r,m)..     ahat(r,m) =l= E1_U*a(r,m);

EQ42(r,m)..    ahat(r,m) =g= E1_L*a(r,m);

EQ5(r)..       sum(m,a(r,m)) =e= 1;

EQ6..          DeltaW =l= E1_U*Deltalambda;

EQ62..         DeltaW =g= E1_L*Deltalambda;

EQ7..          DeltaW =l= (E1 - E1_L)*p('r4') + E1_L*Deltalambda;

EQ8..          DeltaW =g= Deltalambda*E1_U + (E1 - E1_U)*p('r4');

EQ9..          Deltalambda =l= p('r4');

model ITDEA /objective3, limit51, limit52, normalize5, R1, R2
               EQ1, EQ2, EQ3, EQ4, EQ42, EQ5, EQ6, EQ62, EQ7, EQ8, EQ9,/;


loop(iter,
   x0(l) = x(l, iter);
   y0(k) = y(k, iter);
   z0(t) = z(t, iter);
   E1_U = efficiency11(iter);
   E1_L = efficiency21(iter);
   E2_U = efficiency22(iter);
   E2_L = efficiency12(iter);
   solve ITDEA using MIP maximizing se;
*   display E1.l, E2.l, se.l;

   EE1(iter) = E1.l;
   EE2(iter) = E2.l;
   E(iter) = se.l;

);

display EE1, EE2, E;


Execute_Unload "ITDEA.gdx" EE1, EE2, E;

