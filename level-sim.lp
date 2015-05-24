% states:
% 1 --> initial
% 2 --> after picking up gem
% 3 --> after putting gem in altar

% you start in state 1

touch(T,1) :- start(T).
    
special(T) :- sprite(T,gem).
special(T) :- sprite(T,altar).

% possible navigation paths
{ step(T1,1,T2,2):adj(T1,T2) } 1 :- touch(T1,1); sprite(T1,gem).
{ step(T1,2,T2,3):adj(T1,T2) } 1 :- touch(T1,2); sprite(T1,altar).
{ step(T1,S,T2,S):adj(T1,T2) } 1 :- touch(T1,S); not special(T1); not finish(T1).

touch(T2,S2) :- step(T1,S1,T2,S2).

% you can't touch a wall in any state
:- sprite(T,wall); touch(T,S).
    
% you can't touch a trap after picking up the gem
:- sprite(T,trap); touch(T,S); S > 1; S != 2.

% the finish tile must be touched in state 3
completed :- finish(T); touch(T,3).
:- not completed.

#show touch/2.