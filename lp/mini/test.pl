sys_var(a;b;c).

%% exv(a).
%% -exv(X) :- sys_var(X), not exv(X).

%% req_t(r1;r2;r3;r4;r5).
%% req_decl(r1, vars(a,b)).
%% req_decl(r2, vars(a)).
%% req_decl(r3, vars(b,c)).
%% req_decl(r4, vars(a)).
%% req_decl(r5, vars(c)).

%% check_exv(R, Vars) :- req_decl(R, Vars).
%% check_exv(R, vars(V0,V1,V2)) :- check_exv(R, vars(V0,V1,V2,V3)), -exv(V3).
%% check_exv(R, vars(V0,V1)) :- check_exv(R, vars(V0,V1,V2)), -exv(V2).
%% check_exv(R, vars(V0)) :- check_exv(R, vars(V0,V1)), -exv(V1).

%% -has_exv(R) :- check_exv(R, vars(V0,V1)), -exv(V0).
%% has_exv(R) :- check_exv(R, vars(V0,V1,V2,V3)), -exv(V3).
%% has_exv(R) :- check_exv(R, vars(V0,V1,V2)), -exv(V2).
%% has_exv(R) :- check_exv(R, vars(V0,V1)), exv(V1).
%% has_exv(R) :- check_exv(R, vars(V0)), exv(V0).

%% %% has_exv(X) :- req_decl(X, vars(V1,V2)), req_t(X), #count{exv(V1); exv(V2)} >= 1.


%% #show has_exv/1.

