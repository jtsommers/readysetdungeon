__level_design(sprite(T,Name)) :- sprite(T,Name).

a_trap_went_untouched :- sprite(T,trap); not touch(T,2).    
wander :- width*width/2 { touch(T,S) }.
trap_step :- touch(T,S); sprite(T,trap).

__concept :- wander; trap_step, not a_trap_went_untouched.
        
        
#show __level_design/1.
#show __concept/0.