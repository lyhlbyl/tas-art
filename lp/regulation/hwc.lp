%% Ver. Valid for the 2021. Updated 14/09/2021
%% summary: 307 in total 

%% theta for threshold
#const theta_speedup_persec=10
#const theta_braking_persec=20
%% define a list of operations that should be considered as change of state, 
-- taking a third-person view, ego for itself.
%% change_of_state(Time) :- not -change_of_state(Time).
vehicle(ego).
% Status of vehicles
% speed(Vehicle, Speed, Time)
%% naive definition of status changes
speedup(Vehicle, T0, T1) :- speed(Vehicle, Sp0, T0), speed(Vehicle, Sp1, T1), 
	Sp0+theta_speedup_persec*(Sp1-Sp0)<Sp1, T0<T1.
braking(Vehicle, T0, T1) :- speed(Vehicle, Sp0, T0), speed(Vehicle, Sp1, T1), 
	Sp1+theta_braking_persec*(Sp1-Sp0)<Sp0, T0<T1.
change_lane(Vehicle, T0, T1) :- lane(Lane0), lane(Lane1), not Lane0 = Lane1, T1 > T0,
	at_lane(Vehicle, Road0, Lane0, T0), at_lane(Vehicle, Road0, Lane1, T1).
change_road(Vehicle, T0, T1) :- road(Road0), road(Road1), not Road0 = Road1, T1 > T0,
	at_road(Vehicle, Road0, T0), at_road(Vehicle, Road1, T1).

change_of_state(Vehicle, T0) :- braking(Vehicle, T0, T1).
change_of_state(Vehicle, T0) :- change_lane(Vehicle, T0, T1).
change_of_state(Vehicle, T0) :- change_road(Vehicle, T0, T1).

%% -- Signal
%% 103, signal intention plenty of time before action, 
%% and cancel signal when finished, not misleading


