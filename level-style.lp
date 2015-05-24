% style: at least half of the map has wall sprites
:- not (width*width)/2 { sprite(T,wall) }.
 
% style: every wall has at least two neighboring walls
:- sprite(T1,wall); not 2 { sprite(T2,wall) : adj(T1,T2) }.
   
% style: altars have no surrounding sprites for two steps
:- sprite(T1,altar); not 0 { sprite(T2,S) : adj(T1,T2) } 0.
:- sprite(T1,altar); not 0 { sprite(T3,S) : adj(T1,T2), adj(T2,T3), T1 != T3 } 0.
    
% style: altars have four adjacent tiles (not on a map border)
:- sprite(T1,altar); not 4 { adj(T1,T2) }.
    
% style: gems have exactly three surrounding walls
:- sprite(T1,gem); not 3 { sprite(T2,wall) : adj(T1,T2) } 3.