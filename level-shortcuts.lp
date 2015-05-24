__level_design(sprite(T,Name)) :- sprite(T,Name).
    
wander :- width*width/2 { touch(T,S) }.
trap_step :- touch(T,S); sprite(T,trap).
    
__concept :- wander; trap_step.
        
        
#show __level_design/1.
#show __concept/0.