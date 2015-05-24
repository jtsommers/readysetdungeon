#const width=10.

param("width",width).

dim(0..width-1).

tile((X,Y)) :- dim(X); dim(Y).
    
adj((X1,Y1),(X2,Y2)) :- 
    tile((X1,Y1));
    tile((X2,Y2));
    |X1-X2| + |Y1-Y2| == 1.
    
start((0,0)).
finish((width-1,width-1)).

% tile at most one named sprite
0 { sprite(T,(wall;gem;altar;trap)) } 1 :- tile(T).
   
% there is exactly one gem and one altar in the whole level
:- not 1 { sprite(T,altar) } 1.
:- not 1 { sprite(T,gem) } 1.
    
% there are between 2 and 5 traps in the level
:- not 2 { sprite(T,trap) } 5.
    
% the start and finish are clear
:- start(T); sprite(T,Name).
:- finish(T); sprite(T,Name).
    
#show param/2.
#show tile/1.
#show sprite/2.