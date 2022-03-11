#include "atom_veh.pl".
#include "context.pl".
#include "opendrive.pl".


%% -- Literal def

%% vehicle_motion(ego, s, a, t).

%% -- Basic operation:
%% overtaking, not sure about this method applies to overtaking tram .
%% ego overtakes obj from T1 to T2
%% for these rules, will logicbasewd formalisation the best way for classification, maybe a better way is to  
%% use ML classification to give tags.

%% overtaking(ego, obj, T1, T2):- 
%% on_lane(ego, r1, lane1, T1), on_lane(obj, r1, lane1, T1), front_of(obj, ego, T1), 
%% front_of(ego, obj, T2), on_lane(obj, _, lane2, T2), T2 > T1, lane1 != lane2.


%% WVW1994
%% RW1990

%% -- Positioning
%% rw3, keep far left as possible, by default
%% keep_far_left.
applies(rw3, V, T) :- veh_onward(V, T), veh(V), time(T), not applies(rw13_1, V, T).
requires(keep_left, V, T) :- applies(rw3, V, T), not -requires(keep_left, V, T).


%% rw 13_1: allow to on right lane if there is a queue on left
applies(rw13_1, V, T) :- veh_onward(V, T), veh(V), time(T), cond_queue_on_left(V, T).
cond_queue_on_left(V, T) :- on_road_lane(V, R, L, T), L>1, L1=L-1, prev_veh_on_road_lane(V1, R, L1), 
veh_queuing(V1, T).



%% -- Overtaking
%% art11 overtaking on left by default
%% on_left(tgt_v, ego) :- overtaking(ego, tgt_v, T1, T2), .

%% rw 11_2; 11_3, (11_4 position panel?), 11_5 normal scenarios to allow overtake on right
%% rw 13_1 allows to overtake queue on right

%% rw 11_2; 11_3, 11_5, 13_1 > rw11_1


%% Mortorways and highways
%% rw43 must not uturn or stop on
%% rw43 not permitted to drive on hard shoulder


%% -- Must
%% rw49 must give way at pedestrain crossing
%% rw50 must give priority to emergency vehicle
%% rw63 must obey traffic sign
%% rw68 must obey traffic light, greem prceed, amber stop if too close, red stop
%% rw82 must follow aurhorised persons
-requires(keep_left, V, T) :- under_police_cntrl(V, T).


%% -- Must not, can serve as explict evidence of negations.
%% wvw5 must not cause harzard
%% rw14 must not block junction


%% Constrains for enforcement
:- requires(keep_left, V, T), on_road_lane(V, R, L, T), road_has_lane(R, L2), L2 < L.

