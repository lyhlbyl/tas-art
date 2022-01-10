%% context setting for time
#const max_timestamp_count=20.
#const count_per_sec=2.
timestamp(0..max_timestamp_count).
time(TC/2) :- timestamp(TC).

#const cnt_disable_green=2.
#const cnt_wow_on_ground=2.
#const max_uc_op_time=5.
#const airspeed_bound=200.

%% -- sec 4.1
%% req 1: there are three undercarriage legs, and left and right are known as main gears.
%% typ_carriage_legs(nose;left;right).
%% mainly for debugging
typ_carriage_legs(uc).

%% req 2: send command simultaneously to all uc legs
typ_cmd_switch(lower; retract).
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

%% req 3: status of uc legs,
typ_uc_status(up_locked;up_unlocked;travelling;down_unlocked;down_locked).
%% leg status in order for command lower, and the reverse for retract
uc_status_ord(up_locked, up_unlocked).
uc_status_ord(up_unlocked, travelling).
uc_status_ord(travelling, down_unlocked).
uc_status_ord(down_unlocked, down_locked).


%% uc leg status transition defined in inductive way
%% init status
uc_status(UCL,X,TIME_CNT) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), typ_uc_status(X), init_status(X), TIME_CNT = 0.
%% time transition, inherit status, note, in this model, only one transition happened for 1 time unit
uc_status(UCL,X,TIME_CNT+1) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), typ_uc_status(X), 
	uc_status(UCL,X,TIME_CNT), TIME_CNT < max_timestamp_count, not op_uc(UCL, lower, TIME_CNT), not op_uc(UCL, retract, TIME_CNT).
%% nondeterministic status transition
%% uc_status(UCL,X,TIME_CNT+1),uc_status(UCL,Y,TIME_CNT+1) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), typ_uc_status(X),
%% 	uc_status(UCL,X,TIME_CNT), op_uc(UCL, lower, TIME_CNT), uc_status_ord(X,Y), TIME_CNT < max_timestamp_count.
%% uc_status(UCL,Y,TIME_CNT+1),uc_status(UCL,X,TIME_CNT+1) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), typ_uc_status(X),
%% 	uc_status(UCL,X,TIME_CNT), op_uc(UCL, retract, TIME_CNT), uc_status_ord(Y,X), TIME_CNT < max_timestamp_count.

%% determinstic version, just simpler
uc_status(UCL,Y,TIME_CNT+1) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), typ_uc_status(X),
	uc_status(UCL,X,TIME_CNT), op_uc(UCL, lower, TIME_CNT), uc_status_ord(X,Y), TIME_CNT < max_timestamp_count.
uc_status(UCL,Y,TIME_CNT+1) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), typ_uc_status(X),
	uc_status(UCL,X,TIME_CNT), op_uc(UCL, retract, TIME_CNT), uc_status_ord(Y,X), TIME_CNT < max_timestamp_count.

uc_status(UCL,X,TIME_CNT+1) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), typ_uc_status(X),
	uc_status(UCL,X,TIME_CNT), op_uc(UCL, lower, TIME_CNT), X = down_locked, TIME_CNT < max_timestamp_count.
uc_status(UCL,X,TIME_CNT+1) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), typ_uc_status(X),
	uc_status(UCL,X,TIME_CNT), op_uc(UCL, retract, TIME_CNT), X = up_locked, TIME_CNT < max_timestamp_count.


%% req 4: the whole process should be no more than 5s
op_uc_cnt(UCL, UC_CMD, 0, TIME_CNT) :- uc_cmd(UCL, UC_CMD, TIME_CNT).
op_uc_cnt(UCL, UC_CMD, CNT+1, TIME_CNT+1) :- op_uc_cnt(UCL, UC_CMD, CNT, TIME_CNT), TIME_CNT < max_timestamp_count, op_uc(UCL, UC_CMD, TIME_CNT+1).
:- op_uc_cnt(UCL, UC_CMD, CNT, TIME_CNT), count_per_sec * max_uc_op_time < CNT.

%% req 5 - 7: each leg has a sensor; 
%% req 8 is partially specified, i.e. excluding 0.5s
%% req 9 has not been formalised.
uc_led(UCL, green, TIME_CNT) :- uc_status(UCL, up_locked, TIME_CNT), not -uc_led(UCL, green, TIME_CNT).
uc_led(UCL, green, TIME_CNT) :- uc_status(UCL, down_locked, TIME_CNT).
uc_led(UCL, red_flash, TIME_CNT) :- uc_status(UCL, up_unlocked, TIME_CNT).
uc_led(UCL, red_flash, TIME_CNT) :- uc_status(UCL, travelling, TIME_CNT).
uc_led(UCL, red_flash, TIME_CNT) :- uc_status(UCL, down_unlocked, TIME_CNT).

%% -- sec 4.2
%% req 10: possible to command uc at any status, using transitivity
lower_trans_status(X, Y) :- uc_status_ord(X, Y).
lower_trans_status(X, Y) :- lower_trans_status(X, Z), uc_status_ord(Z, Y).
retract_trans_status(X, Y) :- uc_status_ord(Y, X).
retract_trans_status(X, Y) :- retract_trans_status(X, Z), uc_status_ord(Y, Z).
:- typ_uc_status(X), typ_uc_status(Y), not lower_trans_status(X,Y), not retract_trans_status(X,Y), X != Y.


%% req 11: each leg has a wow to indicate on_gorund status, once detect weight, it enter on_ground status.
typ_wow_status(on_ground;airborne).

%% %% req 12: on_gound is explicit negation of retract ....
-op_uc(UCL,retract,TIME_CNT+1) :- wow_status(UCL, on_ground, TIME_CNT), typ_carriage_legs(UCL).

%% %% req 13: if not on_ground, then airborne
wow_status(UCL, airborne, TIME_CNT) :- timestamp(TIME_CNT), typ_carriage_legs(UCL), not wow_status(UCL, on_ground, TIME_CNT).
:- wow_status(UCL, airborne, TIME_CNT), wow_status(UCL, on_ground, TIME_CNT), timestamp(TIME_CNT).

%% %% req 14:  continuous counting 10s of airborne and up_locked and to disable green led
cnt_airborne_uplock(UCL, 0, 0) :- typ_carriage_legs(UCL).
%% increase cnt if airborne and up_locked
cnt_airborne_uplock(UCL, CNT+1, TIME_CNT+1) :- typ_carriage_legs(UCL), timestamp(TIME_CNT), 
	wow_status(UCL, airborne, TIME_CNT), uc_status(UCL, up_locked, TIME_CNT), cnt_airborne_uplock(UCL, CNT, TIME_CNT).
%% otherwise, reset cnt 
cnt_airborne_uplock(UCL, 0, TIME_CNT+1) :- typ_carriage_legs(UCL), timestamp(TIME_CNT), wow_status(UCL, WOW, TIME_CNT), WOW != airborne.
cnt_airborne_uplock(UCL, 0, TIME_CNT+1) :- 
typ_carriage_legs(UCL), timestamp(TIME_CNT), uc_status(UCL, X, TIME_CNT), X != up_locked.
%% no need to TIME_CNT+1, because uc_led is not defined inductively
-uc_led(UCL, green, TIME_CNT) :- cnt_airborne_uplock(UCL, CNT, TIME_CNT), CNT > cnt_disable_green * count_per_sec.

%% -- sec 4.3
%% req 15. continuous 2 sec of weight detection to enter on ground status
cnt_wow_status(0, UCL, 0) :- typ_carriage_legs(UCL).
cnt_wow_status(CNT+1, UCL, TIME_CNT+1) :- detect_weight(UCL, TIME_CNT), cnt_wow_status(CNT, UCL, TIME_CNT), timestamp(TIME_CNT).
cnt_wow_status(0, UCL, TIME_CNT+1) :- not detect_weight(UCL, TIME_CNT), cnt_wow_status(CNT, UCL, TIME_CNT), timestamp(TIME_CNT).
wow_status(UCL, on_ground, TIME_CNT) :- cnt_wow_status(CNT, UCL, TIME_CNT), CNT > cnt_wow_on_ground * count_per_sec.

%% req 16. lower can only work if airspeed is less than 200
-op_uc(UCL,lower,TIME_CNT+1) :- airspeed(SPEED, TIME_CNT), SPEED >= airspeed_bound, timestamp(TIME_CNT), typ_carriage_legs(UCL).


%% ----------------
%% simulation examples
%% ----------------

%%-- case 1: lower and retract 
%% init status
%% init_status(up_locked).

%% %% command list 
%% switch_cmd(lower,1).
%% switch_cmd(retract,3).
%% #show uc_status/3.


%% -- case 2: on ground counting, and forbid cmd retract
%% init status
init_status(down_locked).

%% command list 
detect_weight(uc, 1..2).
detect_weight(uc, 4..16).
switch_cmd(retract,9).
%% give an counterexample of an undesirable status.
check(X, TIME_CNT):- timestamp(TIME_CNT), uc_status(UCL, X, TIME_CNT), TIME_CNT > 9, X != down_locked.

%% #show wow_status/3.
%% #show uc_status/3.
#show check/2.
%% #show uc_led/2.


%% check requirement: landing not allow to retract, but in the spec it only forbit on ground for 2s



