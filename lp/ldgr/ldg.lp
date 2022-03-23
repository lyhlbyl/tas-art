#include "../framework.lp".
#const max_step=10.

%% redefine step as timetick, and define time in second
timetick(X) :- step(X).
#const count_per_sec=2.
time(TT/count_per_sec) :- timetick(TT).

%% %% ----- Req Def -------
%% 1. There shall be 3 undercarriage legs:
%% a. Nose,
%% b. Left and
%% c. Right;
%% Note: Left and Right Gear are collectively known as ‘Main Gear’.
sort(mgr).
%% TODO: not sure if single sort is sufficient, might be worth to move to multiple sort in future
is_a((nose;left;right),mgr).
sys_var(nose;left;right).


%% %% ----- Req Def -------
%% 2. The undercarriage shall be simultaneously commanded by a switch to 
%% a. ‘lower’ and
%% b. ‘retract’.
sort(mgr_cmd).
is_a((lower; retract), mgr_cmd).

%% %% ----- Req Def -------
%% 3. On command from the undercarriage switch to ‘lower’ the undercarriage, each leg shall have
%% the following states which are sequential:
%% a. Up and Locked
%% b. Up and Unlocked
%% c. Travelling (could be sub state up and down tbd)
%% d. Down and Unlocked
%% e. Down and Locked
%% The order is reversed for ‘retract’.
sort(mgr_stat).
data_enum(up_locked;up_unlocked;travelling;down_unlocked;down_locked, mgr_stat).

data_enum_ord(up_locked, up_unlocked).
data_enum_ord(up_unlocked, travelling).
data_enum_ord(travelling, down_unlocked).
data_enum_ord(down_unlocked, down_locked).

req_decl(r3).
req_vars(r3, sys_vars(nose,left,right)).
-holds(g1d3, I) :- timetick(TT), sys_status(moving, true, I), sys_status(doorLocked, false, I).
:- timetick(T), is_a(Leg,mgr), sys_status(Leg, Val, T), 



%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
%% %% ----- Req Def -------
uc_cmd(UCL, CMD, TIME_CNT) :- typ_cmd_switch(CMD), typ_carriage_legs(UCL), timestamp(TIME_CNT), switch_cmd(CMD,TIME_CNT).

%% definition for lower or retract operation mode, these mode remains until an locked status is achieved
%% note the use of not negated predicate in the body to allow exceptions.
op_uc(UCL, lower, TIME_CNT+1) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), 
	op_uc(UCL, lower, TIME_CNT), uc_status(UCL,X,TIME_CNT), X != down_locked, not -op_uc(UCL, lower, TIME_CNT+1).
op_uc(UCL, retract, TIME_CNT+1) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), 
	op_uc(UCL, retract, TIME_CNT), uc_status(UCL,X,TIME_CNT), X != up_locked, not -op_uc(UCL, retract, TIME_CNT+1).
%% operation mode is triggered by switch
op_uc(UCL, UC_CMD, TIME_CNT+1) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), typ_cmd_switch(UC_CMD), 
	uc_cmd(UCL, UC_CMD, TIME_CNT), not -op_uc(UCL, UC_CMD, TIME_CNT+1).
%% also the cmd will trigger an negated evidence of not to process thew oppsite operation
-op_uc(UCL, retract, TIME_CNT+1) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), typ_cmd_switch(UC_CMD), 
	uc_cmd(UCL, lower, TIME_CNT).
-op_uc(UCL, lower, TIME_CNT+1) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), typ_cmd_switch(UC_CMD), 
	uc_cmd(UCL, retract, TIME_CNT).

	
#show sys_cmpnt/2.