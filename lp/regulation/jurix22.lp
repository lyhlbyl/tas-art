%% A set of strict rule R. in ASP they are represented using r :- p1 ... pn.
%% note that for each rule, nor r means, for each pi, p1..not r, ..pn -> not pi
%% r10
-intoxicated(X) :- applies(r10, X).
applies(r10, X):- sober(X), not -applies(r10, X).

%% r10'
-sober(X) :- applies(r10p, X).
applies(r10p, X):- intoxicated(X), not -applies(r10p, X).

%% r11
leave_car(X) :- applies(r11, X).
applies(r11, X) :- transfer_to_safe_place(X, Y), injury(Y), not -applies(r11, X).

%% r11'1
-transfer_to_safe_place(X,Y) :- applies(r11p1, X, Y).
applies(r11p1, X, Y) :- -leave_car(X), injury(Y), not -applies(r11p1, X, Y).

%% r11'2
-injury(X) :- applies(r11p2, X).
applies(r11p2, X) :- transfer_to_safe_place(X,Y), -leave_car(X), not -applies(r11p2, X).

%% r12
leave_car(X) :- applies(r12, X).
applies(r12, X) :- do_necessary_aid(X,Y), injury(Y), not -applies(r12, X).

%% r12'1
-do_necessary_aid(X,Y) :- applies(r12p1, X, Y).
applies(r12p1, X, Y) :- -leave_car(X), injury(Y), not -applies(r12p1, X, Y).

%% r12'2
-injury(Y) :- applies(r12p2, Y).
applies(r12p2, Y) :- do_necessary_aid(X,Y), -leave_car(X), not -applies(r12p2, Y).



%% A set of defeasible rule N. in ASP they are represented using r :- p1 ... pn, not -r.
%% r1
sober(X) :- applies(r1, X).
applies(r1, X) :- dirver(X), not -applies(r1, X).

%% r2
-leave_car(X) :- applies(r2, X).
applies(r2, X) :- intoxicated(X), not -applies(r2, X).

%% r3
be_revoke_license(X) :- applies(r3, X).
applies(r3, X) :-  driver(X), intoxicated(X), not -applies(r3, X).

%% r4
take_criminal_res(X) :- applies(r4, X).
applies(r4, X) :- driver(X), intoxicated(X), not -applies(r4, X).

%% r5
take_criminal_res(X) :- applies(r5, X).
applies(r5, X) :- hit_and_run(X,Y), injury(Y), not -applies(r5, X).

%% r6
aggravated_punishment(X) :- applies(r6, X).
applies(r6, X) :- hit_and_run(X,Y), cause_death(X,Y), injury(Y), not -applies(r6, X).

%% r7
aggravated_punishment(X) :- applies(r7, X).
applies(r7, X) :- hit_and_run(X,Y), driver(X), intoxicated(X), injury(Y), 
  not -applies(r7, X). 

%% r8
transfer_to_safe_place(X,Y) :- applies(r8, X, Y).
applies(r8, X, Y) :- cause_accident(X,Y), injury(Y), 
  not -applies(r8, X, Y).

%% r9
do_necessary_aid(X,Y) :- applies(r9, X, Y).
applies(r9, X, Y)  :- cause_accident(X,Y), injury(Y), need_emergency_aid(Y),
  not -applies(r9, X, Y).


%% a set of axiom K^A
driver(ps1).
intoxicated(ps1).
hit_and_run(ps1, injury1).
injury(injury1).
cause_death(ps1, injury1).
cause_accident(ps1, injury1).
need_emergency_aid(injury1).


#show leave_car/1.
#show -leave_car/1.
#show applies/1.
#show applies/2.