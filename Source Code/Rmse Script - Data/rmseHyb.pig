--load input data
set default_parallel 4;
UI = load '/RcomSys/RmseInput/d_1.rmse' using PigStorage('\t') as (uid:int,itemid:int,rating:double);
t1 = load '/RcomSys/RmseInput/d_2.rmse' using PigStorage('\t') as (uid:int,itemid:int,rating:double);

SPLIT UI into NonZero if rating!=0,Zero if rating==0;

--initially calculating b

--calculating average mean of all movies
A_1 = group UI all;
A_2 = foreach A_1 generate FLATTEN(UI.uid) AS uid,(DOUBLE)AVG(UI.rating) as mean_rating;
M_1 = DISTINCT A_2;
--calculating average mean of ratings of each user
A_3 = group UI by uid;
A_4 = foreach A_3 generate group as uid, (DOUBLE)AVG(UI.rating) as uid_mean_rating;

--calculating average mean of ratings of each movie
A_5 = group UI by itemid;
A_6 = foreach A_5 generate group as itemid,FLATTEN(UI.uid) as uid, (DOUBLE)AVG(UI.rating) as itemid_mean_rating;

A_7 = join A_4 by uid,A_6 by uid;
A_8 = join A_7 by A_4::uid,M_1 by uid;
A_9 = foreach A_8 generate A_7::A_4::uid as uid,A_7::A_6::itemid as itemid,(DOUBLE)(M_1::mean_rating + (A_7::A_4::uid_mean_rating - M_1::mean_rating) + (A_7::A_6::itemid_mean_rating - M_1::mean_rating)) as b;

--calculating centered average rating for each item
G = group NonZero by itemid;
Avg = foreach G generate group as itemid,AVG(NonZero.rating) as avg;
J = join NonZero by itemid,Avg by itemid;
S = foreach J generate NonZero::uid as uid,NonZero::itemid as itemid,(DOUBLE)(NonZero::rating - Avg::avg) as rating;
CA = UNION S,Zero;

--creating Item X Item Similarity matrix
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

--Finding 10 nearest neighbours(rated by user) for each item(not rated by user)
JNZ = join NonZero by itemid,II by it1;
BJ = join JNZ by (NonZero::uid,II::it2),Zero by (uid,itemid);
Test = foreach BJ generate Zero::uid as uid, Zero::itemid as pitem ,JNZ::II::it1 as sitem,JNZ::NonZero::rating as rating,JNZ::II::sim as sim;
P_13 = group Test by (uid,pitem);
P_14 = foreach P_13 { sim_ord = order Test by sim DESC; lim_1 = limit sim_ord 10; generate group as uid_itemnotrated,lim_1; };
P_15 = foreach P_14 generate FLATTEN(uid_itemnotrated),FLATTEN(lim_1);
P_16 = foreach P_15 generate uid_itemnotrated::uid as uid,uid_itemnotrated::pitem as itemid,lim_1::sitem as sim_item,lim_1::rating as rating,lim_1::sim as sim;

-- joining A_9 and P_16 
A_16 = join A_9 by (uid,itemid),P_16 by (uid,sim_item);
A_17 = foreach A_16 generate A_9::uid as uid,A_9::itemid as itemid,P_16::sim_item as sim_item,A_9::b as b_sim_item,P_16::rating as 
rating,P_16::sim as sim;

--subtracting value of b during summation
A_18 = foreach A_17 generate uid,itemid,(DOUBLE)(rating - b_sim_item) as m,sim;
A_19 = foreach A_18 generate uid,itemid,(DOUBLE)(m * sim) as pro,sim;
A_20 = group A_19 by (uid,itemid);
A_21 = foreach A_20 generate group as uid_item,(DOUBLE)SUM(A_19.pro) as sum_pro,(DOUBLE)SUM(A_19.sim) as sum_sim;
A_22 = foreach A_21 generate uid_item,(DOUBLE)(sum_pro / sum_sim) as prePR;
M_2 = foreach A_22 generate FLATTEN(uid_item),prePR;
M_3 = join A_9 by (uid,itemid),M_2 by(uid_item::uid,uid_item::itemid);
M_4 = foreach M_3 generate A_9::uid as uid,A_9::itemid as itemid,A_9::b as b,M_2::prePR as prePR;
--ading value of b after summation
A_23 = foreach M_4 generate uid,itemid,(DOUBLE)(b + prePR) as PredictedRating;

Z_4 = join A_23 by (uid,itemid),t1 by (uid,itemid);
Z_5 = foreach Z_4 generate A_23::uid as uid,A_23::itemid as itemid,(DOUBLE)(A_23::PredictedRating - t1::rating) as diff;
Z_6 = foreach Z_5 generate uid,itemid,(DOUBLE)(diff * diff) as sqr;
Z_7 = group Z_6 ALL ;
Z_8 = foreach Z_7 generate COUNT(Z_6.sqr) as count,SUM(Z_6.sqr) as su;
Z_9 = foreach Z_8 generate (DOUBLE)(su/count) as mean;
Z_10 = foreach Z_9 generate (DOUBLE)SQRT(mean) as rmse;
store Z_10 into '/RcomSys/RmseHybdOut';
