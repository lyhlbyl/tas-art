%% ----- Block Def -------

%% ----- General System Framework Definition -------
%% we assume perfect knowledge of the system, i.e. close world assumption for system status variable
sys_status(-Var, I) :- sys_var(Var), step(I), not sys_status(Var, I).
-sys_status(Var, I) :- sys_status(-Var, I).
%% system status perserve unless explicit changes 
sys_status(Var, I+1) :- 
	sys_var(Var), sys_status(Var, I), 
	step(I), step(I+1), not sys_status(-Var, I+1).

%% For each event, it can ocuur in the next step, keep generate steps until violation happens
occurs(X, I) | -occurs(X, I) :- event(X, I), step(I).

%% -allHolds(I) :- -holds(Rq, I), req(Rq, _), step(I).
%% allHolds(I) :- not -allHolds(I), step(I).

%% But events can only occur in an atomic way
:- occurs(X, I), occurs(Y, I), X != Y.

%% ----- Step Def -------
#const max_step=2.
step(0..max_step).
%% holds, occurs

%% ----- Sys Vars Def -------
%% Template: sys_var(VarName).
%% --------------------------
%% system variable definition
sys_var(moving).
sys_var(doorLocked).
sys_var(sensorHigh).


%% %% ----- Req Def -------
holds(X, I) :- step(I), req(X, subgoal), not -holds(X, I).
-holds(X, I) :- step(I), req(X, subgoal), not holds(X, I).
:- req(X, subgoal), step(I), -holds(X, I).

req_typ(subgoal).
req_typ(goal).

req_decl(g1d3(moving, doorLocked)).
req_decl(g1d3d1(sensorHigh, moving)).
req_decl(g1d3d2(doorLocked, sensorHigh)).
req_parent_of(g1d3(moving, doorLocked), g1d3d1(sensorHigh, moving)).
req_parent_of(g1d3(moving, doorLocked), g1d3d2(doorLocked, sensorHigh)).

req_has_child(X) :- req_decl(X), req_decl(Y), req_parent_of(X, Y).
-req_has_child(X) :- req_decl(X), not req_has_child(X).
req_is_subreq(X, Y) :- req_decl(X), req_decl(Y), req_parent_of(X, Y).
req_is_subreq(X, Z) :- req_decl(X), req_decl(Y), req_decl(Z), req_parent_of(X, Y), req_is_subreq(Y, Z).


req(X, goal) :- req_decl(X), req_has_child(X).
req(X, subgoal) :- req_decl(X), -req_has_child(X).

%% G1.3: DoorsLockedWhenMoving
%% req(g1d3(moving, doorLocked), goal).
-holds(g1d3(moving, doorLocked), I) :- step(I), sys_status(moving, I), sys_status(-doorLocked, I).

%% G1.3.1: SensorHighWhenMoving
%% req(g1d3d1(sensorHigh, moving), subgoal).
-holds(g1d3d1(sensorHigh, moving), I) :- step(I), sys_status(moving, I), sys_status(-sensorHigh, I).

%% G1.3.2: DoorsLockedWhenSensorHigh
%% req(g1d3d2(doorLocked, sensorHigh), subgoal).
-holds(g1d3d2(doorLocked, sensorHigh), I) :- step(I), sys_status(sensorHigh, I), sys_status(-doorLocked, I).




%% ----- Event Def -------
%% Template: 
%% event(Event, I) :- precond.
%% postcond(_, I+1) :- occur(Event, I).
%% --------------------------
event(set_moving, I) :- step(I).
sys_status(moving, I+1) :- step(I), step(I+1), occurs(set_moving, I).

event(unset_moving, I) :- step(I).
sys_status(-moving, I+1) :- step(I), step(I+1), occurs(unset_moving, I).

event(set_doorLocked, I) :- step(I).
sys_status(doorLocked, I+1) :- step(I), step(I+1), occurs(set_doorLocked, I).
event(unset_doorLocked, I) :- step(I).
sys_status(-doorLocked, I+1) :- step(I), step(I+1), occurs(unset_doorLocked, I).

event(set_sensorHigh, I) :- step(I).
sys_status(sensorHigh, I+1) :- step(I), step(I+1), occurs(set_sensorHigh, I).
event(unset_sensorHigh, I) :- step(I).
sys_status(-sensorHigh, I+1) :- step(I), step(I+1), occurs(unset_sensorHigh, I).


%% ----- Init -------
%% only generate liters that satifies req
%% sys_status(moving, 0). 
%% sys_status(doorLocked, 0).
%% sys_status(-doorLocked, 1).

{sys_status(V, 0): sys_var(V)}.
:- -holds(X, 0), req(X, _), step(0).

%% ----- check Def -------
%% warning :- -holds(X, I), req(X, goal), step(I).
%% :- not warning.

%% #program base.
%% #show occurs/2.
%% #show -occurs/2.
%% #show sys_status/2.
%% #show -holds/2.
%% #show req/2.


%% %% encoding domain
%% -brokenWire :- sensorHigh.
%% sensor2Wire :- sensorHigh.
%% sensorOn :- sensorHigh.

%% sensorHigh :- moving, -brokenWire, sensorOn, sensor2Wire.

%% :- maintain(g1d3).
