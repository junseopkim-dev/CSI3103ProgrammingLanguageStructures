neighbor(AColor, BColor) :- color(AColor), color(BColor), AColor \= BColor.
color(red). 	
color(green).
color(blue).
color(yellow).


graph(A, B, C, D, E) :- 
neighbor(A, B), neighbor(B, C), neighbor(A, C) , neighbor(B, D), 
neighbor(C, D), neighbor(E, D), neighbor(A, E) , neighbor(A, D).
