
%% ------Car/Wheels------
wp :- wt.
wt :- wp.

%% ------Car/Doors------
ds :- dl.
dl :- ds.

%% ------DLCU------
wp :- mv_pm.
mv_pm :- wp.

mv_pm :- ds.
ds :- mv_pm.

%% ------SC-3------
%% C1
violation :- mv, -dl. 
%% C2
violation :- -mv, dl.
%% C3
-violation :- not violation.
%% C4
:- -violation.


%% ------Road------
mv :- wt.
%% wt :- mv.
mv,  -wt.


-wp :- not wp.
-wt :- not wt.
-ds :- not ds.
-dl :- not dl.
-mv :- not mv.
mv;-mv.