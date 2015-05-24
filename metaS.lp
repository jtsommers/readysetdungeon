level_design(A) :- show(A,__level_design(_)).
concept(A) :- show(A,__concept).

criteria(0,0,0,A) :- level_design(A).
criteria(0,0,0,-A) :- level_design(A).
criteria(0,0,0,A) :- concept(A).

optimize(0,0,incl).

:- concept(A), not hold(A).