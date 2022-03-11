%% road, lane and junction model by opendirve v1.7

#const roadID_max=3.

%% road literal definitions
%% road(ID), road
road(1..roadID_max).

%% spped limit def
road_speed_limit(1, 60).
road_speed_limit((2;3), 30).
%% road len def
road_len(1..roadID_max, 100).
%% lane def
road_has_lane(1..roadID_max, (-1;1)).
%% junction(RID,RID,JID) definition
junction(1, 2, 1).

%% a road must have a speed limit, length and lanes.
valid_road_def(R):- road(R), road_speed_limit(R, _), road_len(R, _), road_has_lane(R, _).
:- road(R), not valid_road_def(R).



%% Testing
%% vehicle(ego).
%% on_road(ego, 1, 1).
%% on_road(ego, 2, 3).

%% turning(V, R1, R2) :- vehicle(V), road(R1), road(R2), on_road(V, R1, T1), on_road(V, R2, T1+1).

%% #show road/1.
%% #show valid_road_def/1.
