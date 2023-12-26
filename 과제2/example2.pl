% Facts
male(nick).
male(tom).
male(mike).
male(arnold).
male(micheal).
male(jack).

female(ann).
female(nicole).
female(julia).
female(kitty).
female(sue).

parent(nick,mike).
parent(nick,julia).
parent(ann,mike).
parent(ann,julia).

parent(tom,arnold).
parent(tom,kitty).
parent(tom,micheal).
parent(nicole,arnold).
parent(nicole,kitty).
parent(nicole,micheal).

parent(julia,jack).
parent(julia,sue).
parent(micheal,jack).
parent(micheal,sue).

% rules

married(A,B) :- parent(A,C),parent(B,C),A\=B.
sibling(A,B) :- parent(C,A),parent(C,B),A\=B.
sibling(A,B,C) :- parent(Z,A),parent(Z,B),parent(Z,C),A\=B,A\=C,B\=C.

grandparent(A,B) :- parent(A,C),parent(C,B).

ancestor(A,B) :- parent(A,B).
ancestor(A,B) :- parent(A,C),ancestor(C,B).

descendant(A,B) :- parent(B,A).
descendant(A,B) :- parent(B,C),descendant(A,C).

father(A,B) :- male(A),parent(A,B).
mother(A,B) :- female(A),parent(A,B).