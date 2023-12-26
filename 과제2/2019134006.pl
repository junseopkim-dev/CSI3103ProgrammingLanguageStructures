% facts
% size(game,9,9).
% bomb(game,4,1).
% bomb(game,5,1).
% bomb(game,7,2).
% bomb(game,3,6).
% bomb(game,8,6).
% bomb(game,1,7).
% bomb(game,3,7).
% bomb(game,6,7).
% bomb(game,3,9).
% bomb(game,8,9).

% size(game,4,4).
% bomb(game,1,1).
% bomb(game,1,2).
% bomb(game,1,3).
% bomb(game,1,4).
% bomb(game,2,4).
% bomb(game,3,4).
% bomb(game,4,4).
% bomb(game,4,3).
% bomb(game,4,2).
% bomb(game,4,1).

% size(game,7,9).
% bomb(game,1,3).
% bomb(game,2,6).
% bomb(game,7,2).
% bomb(game,4,7).
% bomb(game,7,1).
% bomb(game,2,9).
% bomb(game,1,1).
% bomb(game,7,9).
% bomb(game,3,2).
% bomb(game,1,9).


% size(game,13,11).
% bomb(game,1,1).
% bomb(game,4,1).
% bomb(game,7,2).
% bomb(game,13,2).
% bomb(game,9,3).
% bomb(game,1,4).
% bomb(game,5,4).
% bomb(game,10,4).
% bomb(game,1,5).
% bomb(game,7,6).
% bomb(game,1,7).
% bomb(game,3,9).
% bomb(game,8,9). 
% bomb(game,10,9). 
% bomb(game,13,10).



% rules
% 1. open_at
count(Game, X, Y, N) :-
    size(Game, SizeX, SizeY),
    X1 is max(X-1, 1),
    X2 is min(X+1, SizeX),
    Y1 is max(Y-1, 1),
    Y2 is min(Y+1, SizeY),
    findall((X5,Y5), (between(X1, X2, X5), between(Y1, Y2, Y5), bomb(Game, X5, Y5)), Bombs),
    length(Bombs, N).


open_at(Game, X, Y, Status) :-
    size(Game, SizeX, SizeY),
    X > 0, X =< SizeX,
    Y > 0, Y =< SizeY,
    (   bomb(Game, X, Y) -> Status = bomb
    ;   count(Game, X, Y, N),
        (   N = 0 -> Status = empty
        ;   Status = N
        )
    ).

% 2. show_answer(Game).
show_answer(Game) :-
    size(Game, SizeX, SizeY),
    show_rows(Game, 1, SizeX, SizeY),
    true.

show_rows(Game, CurrentRow, SizeX, SizeY) :-
    CurrentRow =< SizeY,
    show_row(Game, 1, CurrentRow, SizeX),
    nl,
    NextRow is CurrentRow + 1,
    show_rows(Game, NextRow, SizeX, SizeY).

show_rows(_, CurrentRow, _, SizeY) :-
    CurrentRow > SizeY.

show_row(Game, CurrentCol, Y, SizeX) :-
    CurrentCol =< SizeX,
    open_at(Game, CurrentCol, Y, Status),
    print_status(Status),
    NextCol is CurrentCol + 1,
    show_row(Game, NextCol, Y, SizeX).

show_row(_, CurrentCol, _, SizeX) :-
    CurrentCol > SizeX.

print_status(bomb) :-
    format("* ").

print_status(empty) :-
    format("  ").

print_status(N) :-
    integer(N),
    format("~d ", [N]).

% 3. is_survive(Game, Opened)
is_survive(Game, Opened) :-
    \+ (member([X, Y], Opened), bomb(Game, X, Y)).


% 4. show_status(Game, Opened).
open_adjacent(Game, X, Y, Opened, UpdatedOpened) :-
    size(Game, SizeX, SizeY),
    X1 is max(X-1, 1),
    X2 is min(X+1, SizeX),
    Y1 is max(Y-1, 1),
    Y2 is min(Y+1, SizeY),
    open_at(Game, X, Y, Status),
    (   Status = empty
    ->  findall([NX, NY],
                (   between(X1, X2, NX),
                    between(Y1, Y2, NY),
                    \+ member([NX, NY], Opened),
                    open_at(Game, NX, NY, Status2),
                    Status2 \= bomb
                ),
                Adjacent),
        expand_opened(Game, Adjacent, [[X, Y] | Opened], UpdatedOpened)
    ;   UpdatedOpened = [[X, Y] | Opened]
    ).

expand_opened(_, [], Opened, Opened).
expand_opened(Game, [[X, Y] | Rest], Opened, UpdatedOpened) :-
    (   member([X, Y], Opened)
    ->  expand_opened(Game, Rest, Opened, UpdatedOpened)
    ;   open_adjacent(Game, X, Y, Opened, TempOpened),
        expand_opened(Game, Rest, TempOpened, UpdatedOpened)
    ).

show_status(Game, Opened) :-
    size(Game, SizeX, SizeY),
    expand_opened(Game, Opened, [], UpdatedOpened),
    show_rows_status(Game, 1, SizeX, SizeY, UpdatedOpened).

show_rows_status(Game, CurrentRow, SizeX, SizeY, UpdatedOpened) :-
    CurrentRow =< SizeY,
    show_row_status(Game, 1, CurrentRow, SizeX, UpdatedOpened),
    nl,
    NextRow is CurrentRow + 1,
    show_rows_status(Game, NextRow, SizeX, SizeY, UpdatedOpened).

show_rows_status(_, CurrentRow, _, SizeY, _) :-
    CurrentRow > SizeY.

show_row_status(Game, CurrentCol, Y, SizeX, UpdatedOpened) :-
    CurrentCol =< SizeX,
    (   member([CurrentCol, Y], UpdatedOpened) 
    -> open_at(Game, CurrentCol, Y, Status),
     print_status(Status)
    ;   format("? ")
    ),
    NextCol is CurrentCol + 1,
    show_row_status(Game, NextCol, Y, SizeX, UpdatedOpened).

show_row_status(_, CurrentCol, _, SizeX, _) :-
    CurrentCol > SizeX.

% 5. is_win
fopened(Game, Opened, OpenedCells) :-
    expand_opened(Game, Opened, [], OpenedCells).

find_adjacent_to_open(Game, X, Y, AdjacentCells) :-
    findall([NX, NY],
            (neighbor(X, Y, NX, NY), can_be_opened(Game, NX, NY)),
            AdjacentCells).

can_be_opened(Game, X, Y) :-
    size(Game, SizeX, SizeY),
    X > 0, X =< SizeX, Y > 0, Y =< SizeY,
    \+ bomb(Game, X, Y).

neighbor(X, Y, NX, NY) :-
    NX is X + 1, NY is Y; NX is X - 1, NY is Y;
    NX is X, NY is Y + 1; NX is X, NY is Y - 1;
    NX is X + 1, NY is Y + 1; NX is X - 1, NY is Y - 1;
    NX is X + 1, NY is Y - 1; NX is X - 1, NY is Y + 1.


is_win(Game, Opened) :-
    fopened(Game, Opened, OpenedCells),
    size(Game, SizeX, SizeY),
    findall((X5,Y5), (between(1, SizeX, X5), between(1, SizeY, Y5), bomb(Game, X5, Y5)), Bombs),
    length(Bombs, Nbombs),
    Size is SizeX * SizeY - Nbombs,
    length(OpenedCells, Size),
    \+ (member([X, Y], OpenedCells), bomb(Game, X, Y)).
