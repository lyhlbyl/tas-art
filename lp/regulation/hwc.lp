%% Ver. Valid for the 2021. Updated 14/09/2021
%% summary: 307 in total 

%% In this formalisation, we focus on the rules specifying behaviours of vehicles
%% on the road. Rules such as seat belts, driving license, and vehicle conditions drivers 
%% responsibility are not in scope.
%% - TBF: yet to be formalised
%% - OOS: out of scope
#include "opendrive.pl".
#include "atom_veh.pl".




%% action(turn_left;turn_right;park_on_side).


%% -- Signal
%% 103, signal intention plenty of time before action, and cancel signal when finished, not misleading
%% TODO: need temporal logic to properly specify the rule
%% change_intenstion(V, ACT, T) := fact_veh_act(V, changing_course, T).
%% change_intenstion(V, ACT, T) := fact_veh_act(V, changing_direction, T).
 

%% applies(hwc103, V, ACT, T) :- veh(V), act(ACT), time(T), veh_act(V, ACT, T).
%% applies(hwc103, V, ACT, T1), T2 < T1, 

%% TODO: to decide turning left or right, we need to consider the coor between R1 and R2.
%% TODO: to consider the no confusing part, temporal logic is needed.

%% sub 103 turning
%% turning(V, R1, R2, T1) :- vehicle(V), road(R1), road(R2), junction(R1, R2, _), on_road(V, R1, T1), on_road(V, R2, T1+1).
%% violation(hwc103, T1) :- turning(V, R1, R2, T1+1), signalling(V, T1).


%% 104, watch out signals by other road users, note that the signal might not be accurate.
%% TBF, 107-112, 



%% -- Must
%% 105 obey authorised person, mainly stop here.
%% 109 obey traffic light signal and signs.

%% #show timestamp/1
