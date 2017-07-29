set default_parallel 4;
UI = load '/RcomSys/UserItemRating/*' as (uid:int,itemid:int,rating:double);
split UI into NonZero if rating!=0.0,Zero if rating==0.0;
G1 = group NonZero by uid;
U_avg = foreach G1 generate group as uid,AVG(NonZero.rating) as avg;
J1 = join UI by uid,U_avg by uid;
AUI = foreach J1 generate UI::uid as uid,UI::itemid as itemid,(DOUBLE)(UI::rating - U_avg::avg) as n_rating;

it = load '/RcomSys/Items/*' using PigStorage('|') as (itemid:int,itname:chararray,edate:chararray,vedate:chararray,imdburl:chararray,ug:int,f1:int,f2:int,f3:int,f4:int,f5:int,f6:int,f7:int,f8:int,f9:int,f10:int,f11:int,f12:int,f13:int,f14:int,f15:int,f16:int,f17:int,f18:int);
IP = foreach it generate itemid,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18;

J2  = join AUI by itemid,IP by itemid;
G2 = group J2 by uid;
Count_f = foreach G2 generate group as uid,SUM(J2.IP::f1) as c_f1,SUM(J2.IP::f2) as c_f2,SUM(J2.IP::f3) as c_f3,SUM(J2.IP::f4) as c_f4,SUM(J2.IP::f5) as c_f5,SUM(J2.IP::f6) as c_f6,SUM(J2.IP::f7) as c_f7,SUM(J2.IP::f8) as c_f8,SUM(J2.IP::f9) as c_f9,SUM(J2.IP::f10) as c_f10,SUM(J2.IP::f11) as c_f11,SUM(J2.IP::f12) as c_f12,SUM(J2.IP::f13) as c_f13,SUM(J2.IP::f14) as c_f14,SUM(J2.IP::f15) as c_f15,SUM(J2.IP::f16) as c_f16,SUM(J2.IP::f17) as c_f17,SUM(J2.IP::f18) as c_f18;
Rp = foreach J2 generate AUI::uid as uid,(DOUBLE)(AUI::n_rating * IP::f1) as p_f1,(DOUBLE)(AUI::n_rating * IP::f2) as p_f2,(DOUBLE)(AUI::n_rating * IP::f3) as p_f3,(DOUBLE)(AUI::n_rating * IP::f4) as p_f4,(DOUBLE)(AUI::n_rating * IP::f5) as p_f5,(DOUBLE)(AUI::n_rating * IP::f6) as p_f6,(DOUBLE)(AUI::n_rating * IP::f7) as p_f7,(DOUBLE)(AUI::n_rating * IP::f8) as p_f8,(DOUBLE)(AUI::n_rating * IP::f9) as p_f9,(DOUBLE)(AUI::n_rating * IP::f10) as p_f10,(DOUBLE)(AUI::n_rating * IP::f11) as p_f11,(DOUBLE)(AUI::n_rating * IP::f12) as p_f12,(DOUBLE)(AUI::n_rating * IP::f13) as p_f13,(DOUBLE)(AUI::n_rating * IP::f14) as p_f14,(DOUBLE)(AUI::n_rating * IP::f15) as p_f15,(DOUBLE)(AUI::n_rating * IP::f16) as p_f16,(DOUBLE)(AUI::n_rating * IP::f17) as p_f17,(DOUBLE)(AUI::n_rating * IP::f18) as p_f18;
G3 = group Rp by uid;
Sum_r = foreach G3 generate group as uid,SUM(Rp.p_f1) as s_f1,SUM(Rp.p_f2) as s_f2,SUM(Rp.p_f3) as s_f3,SUM(Rp.p_f4) as s_f4,SUM(Rp.p_f5) as s_f5,SUM(Rp.p_f6) as s_f6,SUM(Rp.p_f7) as s_f7,SUM(Rp.p_f8) as s_f8,SUM(Rp.p_f9) as s_f9,SUM(Rp.p_f10) as s_f10,SUM(Rp.p_f11) as s_f11,SUM(Rp.p_f12) as s_f12,SUM(Rp.p_f13) as s_f13,SUM(Rp.p_f14) as s_f14,SUM(Rp.p_f15) as s_f15,SUM(Rp.p_f16) as s_f16,SUM(Rp.p_f17) as s_f17,SUM(Rp.p_f18) as s_f18;
J3 = join Sum_r by uid,Count_f by uid;

U_profile = foreach J3 generate Sum_r::uid as uid,(DOUBLE)(Sum_r::s_f1 / Count_f::c_f1) as f1,(DOUBLE)(Sum_r::s_f2 / Count_f::c_f2) as f2,(DOUBLE)(Sum_r::s_f3 / Count_f::c_f3) as f3,(DOUBLE)(Sum_r::s_f4 / Count_f::c_f4) as f4,(DOUBLE)(Sum_r::s_f5 / Count_f::c_f5) as f5,(DOUBLE)(Sum_r::s_f6 / Count_f::c_f6) as f6,(DOUBLE)(Sum_r::s_f7 / Count_f::c_f7) as f7,(DOUBLE)(Sum_r::s_f8 / Count_f::c_f8) as f8,(DOUBLE)(Sum_r::s_f9 / Count_f::c_f9) as f9,(DOUBLE)(Sum_r::s_f10 / Count_f::c_f10) as f10,(DOUBLE)(Sum_r::s_f11 / Count_f::c_f11) as f11,(DOUBLE)(Sum_r::s_f12 / Count_f::c_f12) as f12,(DOUBLE)(Sum_r::s_f13 / Count_f::c_f13) as f13,(DOUBLE)(Sum_r::s_f14 / Count_f::c_f14) as f14,(DOUBLE)(Sum_r::s_f15 / Count_f::c_f15) as f15,(DOUBLE)(Sum_r::s_f16 / Count_f::c_f16) as f16,(DOUBLE)(Sum_r::s_f17 / Count_f::c_f17) as f17,(DOUBLE)(Sum_r::s_f18 / Count_f::c_f18) as f18;

J4 = join Zero by itemid,IP by itemid;
J5 = join J4 by Zero::uid,U_profile by uid;
Big = foreach J5 generate J4::Zero::uid as uid,J4::Zero::itemid as itemid,(DOUBLE)(J4::IP::f1*U_profile::f1 + J4::IP::f2*U_profile::f2 + J4::IP::f3*U_profile::f3 + J4::IP::f4*U_profile::f4 + J4::IP::f5*U_profile::f5 + J4::IP::f6*U_profile::f6 + J4::IP::f7*U_profile::f7 + J4::IP::f8*U_profile::f8 + J4::IP::f9*U_profile::f9 + J4::IP::f10*U_profile::f10 + J4::IP::f11*U_profile::f11 + J4::IP::f12*U_profile::f12 + J4::IP::f13*U_profile::f13 + J4::IP::f14*U_profile::f14 + J4::IP::f15*U_profile::f15 + J4::IP::f16*U_profile::f16 + J4::IP::f17*U_profile::f17 + J4::IP::f18*U_profile::f18) as Numerator,(DOUBLE)(SQRT(J4::IP::f1*J4::IP::f1 + J4::IP::f2*J4::IP::f2 + J4::IP::f3*J4::IP::f3 + J4::IP::f4*J4::IP::f4 + J4::IP::f5*J4::IP::f5 + J4::IP::f6*J4::IP::f6 + J4::IP::f7*J4::IP::f7 + J4::IP::f8*J4::IP::f8 + J4::IP::f9*J4::IP::f9 + J4::IP::f10*J4::IP::f10 + J4::IP::f11*J4::IP::f11 + J4::IP::f12*J4::IP::f12 + J4::IP::f13*J4::IP::f13 + J4::IP::f14*J4::IP::f14 + J4::IP::f15*J4::IP::f15 + J4::IP::f16*J4::IP::f16 + J4::IP::f17*J4::IP::f17 + J4::IP::f18*J4::IP::f18) * SQRT(U_profile::f1*U_profile::f1 + U_profile::f2*U_profile::f2 + U_profile::f3*U_profile::f3 + U_profile::f4*U_profile::f4 + U_profile::f5*U_profile::f5 + U_profile::f6*U_profile::f6 + U_profile::f7*U_profile::f7 + U_profile::f8*U_profile::f8 + U_profile::f9*U_profile::f9 + U_profile::f10*U_profile::f10 + U_profile::f11*U_profile::f11 + U_profile::f12*U_profile::f12 + U_profile::f13*U_profile::f13 + U_profile::f14*U_profile::f14 + U_profile::f15*U_profile::f15 + U_profile::f16*U_profile::f16 + U_profile::f17*U_profile::f17 + U_profile::f18*U_profile::f18)) as Denominator;
Cos = foreach Big generate uid,itemid,(DOUBLE)(Numerator / Denominator) as sim;
G4 = group Cos by uid;

N_query = foreach G4 { ord = order Cos by sim DESC ; ord_lim = limit ord 5; generate group as uid,FLATTEN(ord_lim);};

Recommendation = foreach N_query generate uid,ord_lim::itemid as itemid;

store Recommendation into '/RcomSys/ContentOut';
