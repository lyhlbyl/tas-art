%% ---------
%% Observations
road_has_lane(1,1).
road_has_lane(1,2).
veh(ego;tesla). 
regulation(rvv3;rvv13_1;rvv_82).
%% time(1).
time(1).
%% (vehicle, time): vehicle is moving forward.
veh_onward(ego, 1).

%% - CASE1: ego is on Road Land at Time
on_road_lane(ego, 1, 2, 1).

%% - CASE2: queueing case
%% on_road_lane(tesla, 1, 1, 1).
%% prev_veh_on_road_lane(ego, tesla, 1, 1). 
%% veh_queuing(tesla, 1).

%% - CASE3: of under police's instruction
%% under_police_cntrl(ego, 1).

%% V1
%% %% ---------
%% %% Positioning
%% %% rvv3, keep far left as possible, by default
%% applies(rvv3, V, T) :- 	veh_onward(V, T), veh(V), time(T),  not applies(rvv13_1, V, T).
%% requires(keep_right, V, T) :- applies(rvv3, V, T), not -requires(keep_right, V, T).

%% %% rw 13_1: allows to on left lane if there is a queue on left
%% applies(rvv13_1, V, T) :- veh_onward(V, T), veh(V), time(T), cond_queue_on_right(V, T).
%% cond_queue_on_right(V, T) :- on_road_lane(V, R, L, T), L>1, L1=L-1, prev_veh_on_road_lane(V, V1, R, L1), 
%% veh_queuing(V1, T).

%% %% rvv82 must follow authorised persons
%% -requires(keep_right, V, T) :- under_police_cntrl(V, T).

%% V2
%% ---------
%% Positioning
%% rvv3, keep far left as possible, by default
applies(rvv3, V, T) :- 	veh_onward(V, T),
						not -applies(rvv3, V, T), not inexp_ab(rvv3, V, T).
requires(keep_right, V, T) :- applies(rvv3, V, T).


%% rw 13_1: allows to on left lane if there is a queue on left
applies(rvv13_1, V, T) :- 	veh_onward(V, T), cond_queue_on_right(V, T),
							not -applies(rvv13_1, V, T), not inexp_ab(rvv13_1, V, T).
cond_queue_on_right(V, T) :- 	on_road_lane(V, R, L, T), 
								prev_veh_on_road_lane(V, V1, R, L1), veh_queuing(V1, T),
								L>1, L1=L-1.
-applies(rvv3, V, T) :- applies(rvv13_1, V, T).

%% %% rvv82 must follow authorised persons
applies(rvv_82, V, T) :- under_police_cntrl(V, T).
inexp_ab(X, V, T) :- regulation(X), applies(rvv_82, V, T), X != rvv_82.

%% ---------
%% Constraints for enforcing the rules on the observation.
violation(rvv3, V, T):- applies(rvv3, V, T), on_road_lane(V, R, L, T), road_has_lane(R, L1), L1 < L.


#show requires/3.
%% #show -requires/3.
#show applies/3.
#show -applies/3.
#show violation/3.