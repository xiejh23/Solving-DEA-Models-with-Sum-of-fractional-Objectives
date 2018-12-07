$ontext

   MDT-based MILP example

   Jianhui Xie, Jun 2017

   Data from:
            random data



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
i                index of firms/i1*i100/
l                index of inputs/x1,x2,x3/
k                index of outputs/y1,y2,y3/
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
              x1              x2            x3
i1          0.3516         0.6017         0.5053
i2          0.1919         0.9923         0.4601
i3          0.6091         0.8071         0.1917
i4          0.9052         0.7428         0.1670
i5          0.5137         0.6890         0.1023
i6          0.3013         0.9454         0.1523
i7          0.7628         0.5462         0.1875
i8          0.1656         0.6196         0.5166
i9          0.4986         0.9990         0.7538
i10         0.0317         0.3816         0.8501
i11         0.0359         0.1625         0.7449
i12         0.0460         0.6161         0.2593
i13         0.7751         0.9458         0.5852
i14         0.4384         0.3967         0.8831
i15         0.8894         0.2550         0.5793
i16         0.2827         0.6601         0.6431
i17         0.4835         0.1170         0.4482
i18         0.0458         0.5982         0.6207
i19         0.4712         0.1353         0.1387
i20         0.6340         0.5312         0.8811
i21         0.7634         0.0153         0.7414
i22         0.1967         0.2993         0.4570
i23         0.6970         0.5460         0.4079
i24         0.5192         0.7186         0.3780
i25         0.8403         0.2199         0.0758
i26         0.9961         0.5790         0.1087
i27         0.3560         0.4944         0.6548
i28         0.7573         0.8032         0.7319
i29         0.1286         0.8016         0.6686
i30         0.5792         0.4174         0.0395
i31         0.8159         0.4697         0.0411
i32         0.8213         0.5537         0.8499
i33         0.4742         0.0787         0.7042
i34         0.3764         0.8682         0.0744
i35         0.9497         0.3165         0.8679
i36         0.2009         0.7264         0.2701
i37         0.6230         0.3418         0.4441
i38         0.5831         0.4589         0.5730
i39         0.7324         0.7586         0.5716
i40         0.6699         0.4891         0.7463
i41         0.7323         0.3863         0.1953
i42         0.2212         0.6840         0.3616
i43         0.3154         0.7797         0.5634
i44         0.8211         0.2446         0.1389
i45         0.0569         0.0963         0.3350
i46         0.9940         0.2083         0.8212
i47         0.3636         0.6864         0.7532
i48         0.2107         0.1656         0.7373
i49         0.8928         0.1211         0.5665
i50         0.4751         0.1805         0.5103
i51         0.8517         0.8427         0.6748
i52         0.1066         0.6195         0.4996
i53         0.6198         0.7574         0.9004
i54         0.6960         0.5086         0.3299
i55         0.5782         0.7630         0.4186
i56         0.3244         0.9845         0.2685
i57         0.1712         0.6052         0.4470
i58         0.3006         0.0009         0.6140
i59         0.3837         0.4610         0.8288
i60         0.6150         0.7850         0.1229
i61         0.2400         0.0487         0.3080
i62         0.2411         0.6657         0.3929
i63         0.9135         0.0533         0.4301
i64         0.9890         0.6995         0.6775
i65         0.0736         0.9618         0.2488
i66         0.3388         0.4001         0.9532
i67         0.5817         0.7768         0.9758
i68         0.0113         0.8095         0.9051
i69         0.2917         0.5373         0.4237
i70         0.1550         0.9537         0.7227
i71         0.5589         0.8483         0.9585
i72         0.4905         0.4045         0.3496
i73         0.6441         0.9430         0.7533
i74         0.4341         0.7541         0.5468
i75         0.2129         0.2798         0.3463
i76         0.9568         0.0066         0.6032
i77         0.7803         0.9693         0.6684
i78         0.6279         0.0863         0.5910
i79         0.9905         0.6604         0.8574
i80         0.1284         0.1885         0.5032
i81         0.4736         0.0110         0.2965
i82         0.7580         0.8264         0.2209
i83         0.9355         0.5061         0.4919
i84         0.7927         0.1549         0.7230
i85         0.1058         0.8682         0.5131
i86         0.9165         0.9937         0.7386
i87         0.5268         0.2353         0.2451
i88         0.1849         0.0816         0.6389
i89         0.7482         0.0822         0.1161
i90         0.5764         0.4002         0.7325
i91         0.2356         0.6725         0.5264
i92         0.5758         0.8397         0.5620
i93         0.5201         0.1224         0.8140
i94         0.1299         0.4248         0.9815
i95         0.6145         0.1177         0.1938
i96         0.2142         0.1585         0.1929
i97         0.6414         0.0859         0.6548
i98         0.1366         0.2273         0.1551
i99         0.5190         0.9235         0.8639
i100        0.6450         0.3914         0.9662
;

Table Ydata(i,k)
              y1             y2             y3
i1          0.6282         0.8479         0.8766
i2          0.3150         0.0753         0.1233
i3          0.5493         0.8479         0.7032
i4          0.6296         0.3991         0.6112
i5          0.3915         0.3445         0.9022
i6          0.3704         0.6496         0.5161
i7          0.2921         0.5473         0.5227
i8          0.5677         0.6105         0.7508
i9          0.4846         0.0645         0.0734
i10         0.2842         0.5140         0.9968
i11         0.7707         0.6427         0.8187
i12         0.8361         0.4394         0.3491
i13         0.8383         0.8776         0.2091
i14         0.1933         0.1514         0.1670
i15         0.6951         0.4133         0.9946
i16         0.0228         0.8038         0.1953
i17         0.9696         0.7343         0.8086
i18         0.5217         0.6610         0.2766
i19         0.8529         0.0522         0.5455
i20         0.8036         0.4470         0.0675
i21         0.1579         0.9282         0.6940
i22         0.2436         0.2242         0.3371
i23         0.1637         0.4916         0.1772
i24         0.8508         0.7395         0.7695
i25         0.2214         0.1281         0.7396
i26         0.2152         0.8060         0.3520
i27         0.4823         0.8029         0.4291
i28         0.3843         0.7326         0.9826
i29         0.7754         0.6453         0.3505
i30         0.3096         0.7853         0.3717
i31         0.4965         0.1471         0.9779
i32         0.0838         0.7183         0.3279
i33         0.9140         0.1821         0.4720
i34         0.4796         0.6674         0.4698
i35         0.6590         0.4741         0.2837
i36         0.8629         0.8207         0.0023
i37         0.0567         0.8935         0.1935
i38         0.3712         0.9813         0.6642
i39         0.0570         0.1165         0.4367
i40         0.2909         0.8483         0.1306
i41         0.3766         0.3088         0.3128
i42         0.6406         0.7277         0.6988
i43         0.5140         0.9276         0.5506
i44         0.0177         0.4477         0.9887
i45         0.6697         0.4706         0.4685
i46         0.2048         0.9951         0.9078
i47         0.7354         0.6421         0.9458
i48         0.8293         0.7243         0.3232
i49         0.0818         0.7579         0.7748
i50         0.5044         0.8558         0.7474
i51         0.0988         0.7950         0.9232
i52         0.1466         0.4393         0.9241
i53         0.1758         0.2082         0.7747
i54         0.1713         0.9063         0.3709
i55         0.6133         0.2839         0.2918
i56         0.1872         0.9342         0.8058
i57         0.1380         0.7708         0.7201
i58         0.9414         0.8122         0.0172
i59         0.5692         0.0318         0.6522
i60         0.5781         0.5920         0.0794
i61         0.1496         0.7860         0.7465
i62         0.5366         0.3758         0.1688
i63         0.5940         0.7630         0.1996
i64         0.4777         0.3748         0.2470
i65         0.9128         0.6468         0.7981
i66         0.5941         0.4241         0.5940
i67         0.0931         0.3996         0.9476
i68         0.2889         0.5742         0.0098
i69         0.5408         0.9090         0.4902
i70         0.0556         0.7500         0.2185
i71         0.4259         0.8402         0.6622
i72         0.6720         0.2152         0.0070
i73         0.8121         0.1104         0.2083
i74         0.2234         0.9985         0.0420
i75         0.3525         0.9600         0.0722
i76         0.7398         0.4978         0.7750
i77         0.0749         0.0809         0.0922
i78         0.3401         0.7834         0.5933
i79         0.1804         0.0260         0.3124
i80         0.3824         0.1979         0.0829
i81         0.8362         0.3658         0.5236
i82         0.2359         0.7227         0.6807
i83         0.3531         0.9746         0.1005
i84         0.0564         0.6599         0.8317
i85         0.9993         0.9424         0.3983
i86         0.3546         0.9169         0.2461
i87         0.1004         0.9613         0.6451
i88         0.1793         0.0315         0.7119
i89         0.0878         0.8094         0.3873
i90         0.8897         0.3605         0.1527
i91         0.8667         0.9847         0.8692
i92         0.6552         0.4234         0.6595
i93         0.7401         0.5095         0.0496
i94         0.8456         0.3940         0.0577
i95         0.6525         0.8027         0.7034
i96         0.3960         0.5031         0.0982
i97         0.0984         0.5467         0.3042
i98         0.0148         0.1864         0.3111
i99         0.9543         0.1143         0.0432
i100        0.6802         0.7665         0.5104
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
r                index of power/r1*r4/
m                index of digital/m0*m9/

PARAMETERS


effdea(i)    DEA efficiency of DMU(i)
e0           DEA efficiency of DMU(0)
p(r)         power of precision (%)

      / r1   0.1
        r2   0.01
        r3   0.001
        r4   0.0001/
*        r5   0.00001/

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

*V_U(l) = 1/x0(l);
*B_L(i,m)=0;
*;

effdea(i) = efficiency(i);
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
;

objective2..         sum(i,e(i)) =e= se;
representation(i)..  sum(l, w(l,i)*x(l,i)) =e= sum(k, u(k)*y(k,i));
repe0..              e0*sum(l, v(l)*x0(l)) =e= sum(k, u(k)*y0(k));
normalize2..         sum(l, v(l)) =e= 1;
limit2(i)..          e(i) =l= 1;

EQ1(l,i)..           w(l,i) =e= sum(r,sum(m,p(r)*d(m)*zhat(l,i,r,m))) + DeltaW(l,i);

EQ2(l,i,r)..         e(i) =e= sum(m,zhat(l,i,r,m));

EQ3(l)..             v(l) =e= sum(r,sum(m,p(r)*d(m)*z(l,r,m))) + DeltaV(l);

EQ4(l,i,r,m)..       zhat(l,i,r,m) =l= z(l,r,m);

EQ5(l,r)..           sum(m,z(l,r,m)) =e= 1;

EQ6(l,i)..           DeltaW(l,i) =l= DeltaV(l);

EQ7(l,i)..           DeltaW(l,i) =l= e(i)*p('r4');

EQ8(l,i)..           DeltaW(l,i) =g= DeltaV(l) + (e(i) - 1)*p('r4');

EQ9(l)..             DeltaV(l) =l= p('r4');



model crossdea /objective2, representation, repe0, limit2, normalize2,
               EQ1, EQ2, EQ3, EQ4, EQ5, EQ6, EQ7, EQ8, EQ9,/;


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

loop(iter3,
   y0(k) = y(k, iter3);
   x0(l) = x(l, iter3);
   e0 = effdea(iter3);
   solve crossdea using MIP maximizing se;
   display e.l, u.l, v.l, se.l;

   ee.l(iter3,i) = e.l(i);
);

display ee.l;
