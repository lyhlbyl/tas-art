from clyngor import ASP, solve

asp_code_base = """
 %% A set of strict rule R. in ASP they are represented using r :- p1 ... pn.
  %% note that for each rule, nor r means, for each pi, p1..not r, ..pn -> not pi
  %% r10
  -intoxicated(X) :- sober(X).
  %% r10'
  -sober(X) :- intoxicated(X).
  %% r11
  should_leave_car(X) :- transfer_to_safe_place(X, Y), injury(Y).
  %% r11'1
  -transfer_to_safe_place(X,Y) :- -should_leave_car(X), injury(Y).
  %% r11'2
  -injury(X) :- transfer_to_safe_place(X,Y), -should_leave_car(X).
  %% r12
  should_leave_car(X) :- do_necessary_aid(X,Y), injury(Y).
  %% r12'1
  -do_necessary_aid(X,Y) :- -should_leave_car(X), injury(Y).
  %% r12'2
  -injury(Y) :- do_necessary_aid(X,Y), -should_leave_car(X).


  
  %% A set of defeasible rule N. in ASP they are represented using r :- p1 ... pn, not -r.
  %% r1
  sober(X) :- dirver(X), not -sober(X).
  %% r2
  -leave_car(X) :- intoxicated(X), not leave_car(X).
  %% r3
  be_revoke_license(X) :- 
    driver(X), intoxicated(X), 
    not -be_revoke_license(X).
  %% r4
  take_criminal_res(X) :- 
    driver(X), intoxicated(X), 
    not -take_criminal_res(X).
  %% r5
  take_criminal_res(X) :- 
    hit_and_run(X,Y), injury(Y), 
    not -take_criminal_res(X).
  %% r6
  aggravated_punishment(X) :- 
    hit_and_run(X,Y), cause_death(X,Y), injury(Y), 
    not -aggravated_punishment(X). 
  %% r7
  aggravated_punishment(X) :- 
    hit_and_run(X,Y), driver(X), intoxicated(X), injury(Y), 
    not -aggravated_punishment(X). 
  %% r8
  transfer_to_safe_place(X,Y) :- 
    cause_accident(X,Y), injury(Y), 
    not -transfer_to_safe_place(X,Y).
  %% r9
  do_necessary_aid(X,Y) :- 
    cause_accident(X,Y), injury(Y), need_emergency_aid(Y),
    not -do_necessary_aid(X,Y).


%% a set of axiom K^A
driver(ps1).
intoxicated(ps1).
hit_and_run(ps1, injury1).
injury(injury1).
cause_death(ps1, injury1).
cause_accident(ps1, injury1).
need_emergency_aid(injury1).


%% #show leave_car/1.
%% #show -leave_car/1.
"""


if __name__ == '__main__':
    # answers = ASP(asp_code_base)
    # for answer in answers:
    #     print(answer)

    answers = ASP("""
    rel(a,(c;d)). rel(b,(d;e)).
    obj(X):- rel(X,_) ; rel(X,Y): att(Y).
    att(Y):- rel(_,Y) ; rel(X,Y): obj(X).
    :- not obj(X):obj(X).
    :- not att(Y):att(Y).
    """)
    for answer in answers:
        print(answer)