set default_parallel 4;
UI = load '/RcomSys/RmseInput/d_1.rmse' using PigStorage('\t') as (uid:int,itemid:int,rating:double);
t1 = load '/RcomSys/RmseInput/d_2.rmse' using PigStorage('\t') as (uid:int,itemid:int,rating:double);

SPLIT UI into NonZero if rating!=0,Zero if rating==0;

G = group NonZero by itemid;
Avg = foreach G generate group as itemid,AVG(NonZero.rating) as avg;
J = join NonZero by itemid,Avg by itemid;
S = foreach J generate NonZero::uid as uid,NonZero::itemid as itemid,(DOUBLE)(NonZero::rating - Avg::avg) as rating;
CA = UNION S,Zero;

A = foreach CA generate uid,itemid,rating;
B = foreach CA generate uid,itemid,rating;
C = join A by uid,B by uid;
P = foreach C generate A::itemid,B::itemid,A::uid,(DOUBLE)(A::rating * B::rating) as rp;
Gr = group P by (A::itemid,B::itemid);
G_Sum = foreach Gr generate group as pid,SUM(P.rp) as sum;
G_Sum1 = foreach G_Sum generate pid,FLATTEN(pid),sum;
Numerator = foreach G_Sum1 generate pid::A::itemid as it1,pid::B::itemid as it2,sum;

P_1 = foreach CA generate uid,itemid,rating;
P_2 = foreach P_1 generate uid,itemid,(DOUBLE)(rating * rating) as sq; 
P_3 = group P_2 by itemid;
P_4 = foreach P_3 generate group as itemid,(DOUBLE)(SUM(P_2.sq)) as ss;
Sqrt = foreach P_4 generate  itemid,(DOUBLE)(SQRT(ss)) as rms;
P_5 = foreach Sqrt generate itemid,rms;
P_6 = foreach Sqrt generate itemid,rms;
P_7 = CROSS P_5,P_6;
Denominator = foreach P_7 generate P_5::itemid as it1,P_6::itemid as it2,(DOUBLE)(P_5::rms * P_6::rms) as prms;

P_8 = join Numerator by (it1,it2),Denominator by (it1,it2);
II = foreach P_8 generate Numerator::it1 as it1,Numerator::it2 as it2,(DOUBLE)(Numerator::sum / Denominator::prms) as sim;

JNZ = join NonZero by itemid,II by it1;
BJ = join JNZ by (NonZero::uid,II::it2),Zero by (uid,itemid);
Test = foreach BJ generate Zero::uid as uid, Zero::itemid as pitem ,JNZ::II::it1 as sitem,JNZ::NonZero::rating as rating,JNZ::II::sim as sim;
P_13 = group Test by (uid,pitem);
P_14 = foreach P_13 { sim_ord = order Test by sim desc; lim = limit sim_ord 10; generate group as uid_itemnotrated,lim; };
P_15 = foreach P_14 generate uid_itemnotrated,FLATTEN(lim);
P_16 = foreach P_15 generate FLATTEN(uid_itemnotrated),(DOUBLE)(lim::rating * lim::sim) as pro,lim::sim as sim;
P_17 = group P_16 by (uid_itemnotrated::uid,uid_itemnotrated::pitem);
P_18 = foreach P_17 generate group as uid_item,(DOUBLE)SUM(P_16.pro) as sum_pro,(DOUBLE)SUM(P_16.sim) as sum_sim;
P_19 = foreach P_18 generate uid_item,(DOUBLE)(sum_pro / sum_sim) as PredictedRating;
Prediction = foreach P_19 generate FLATTEN(uid_item),PredictedRating;
A_23 = foreach Prediction generate uid_item::uid_itemnotrated::uid as uid,uid_item::uid_itemnotrated::pitem as itemid,PredictedRating;

Z_4 = join A_23 by (uid,itemid),t1 by (uid,itemid);
Z_5 = foreach Z_4 generate A_23::uid as uid,A_23::itemid as itemid,(DOUBLE)(A_23::PredictedRating - t1::rating) as diff;
Z_6 = foreach Z_5 generate uid,itemid,(DOUBLE)(diff * diff) as sqr;
Z_7 = group Z_6 ALL ;
Z_8 = foreach Z_7 generate COUNT(Z_6.sqr) as count,SUM(Z_6.sqr) as su;
Z_9 = foreach Z_8 generate (DOUBLE)(su/count) as mean;
Z_10 = foreach Z_9 generate (DOUBLE)SQRT(mean) as rmse;
store Z_10 into '/RcomSys/RmseCfOut';
