% Define the maze layout.
cell(1, 1, open).
cell(2, 1, blocked).
cell(3, 1, blocked).
cell(4, 1, blocked).
cell(1, 2, open).
cell(2, 2, open).
cell(3, 2, open).
cell(4, 2, blocked).
cell(1, 3, blocked).
cell(2, 3, blocked).
cell(3, 3, open).
cell(4, 3, open).
cell(1, 4, open).
cell(2, 4, open).
cell(3, 4, blocked).
cell(4, 4, open).

% Define possible moves: right, left, up, down.
move(X, Y, X1, Y) :- X1 is X + 1, X1 > 0.  % Move right
move(X, Y, X1, Y) :- X1 is X - 1, X1 > 0.  % Move left
move(X, Y, X, Y1) :- Y1 is Y + 1, Y1 > 0.  % Move down
move(X, Y, X, Y1) :- Y1 is Y - 1, Y1 > 0.  % Move up

% Check if a move is valid: the cell must be open and not previously visited.
valid_move(X, Y, Visited) :-
    cell(X, Y, open),
    \+ member((X, Y), Visited).

% Solve the maze using depth-first search with a step counter.
solve(X, Y, EndX, EndY, Visited, Path, Steps) :-
    X == EndX, Y == EndY,  % Check for the end
    length(Visited, L), 
    Steps is L - 1,  % Subtract 1 as the starting cell isn't a step.
    Path = Visited.

solve(X, Y, EndX, EndY, Visited, Path, Steps) :-
    move(X, Y, X1, Y1),  % Try a move.
    valid_move(X1, Y1, Visited),  % Check if the move is valid.
    solve(X1, Y1, EndX, EndY, [(X1, Y1)|Visited], Path, Steps).  % Continue from the new position.

% Print each cell of the maze with ASCII characters.
print_cell(X, Y, Path) :- member((X, Y), Path), write('X '), !. % Path cell
print_cell(X, Y, _) :- cell(X, Y, open), write('. '), !.  % Open cell
print_cell(_, _, _) :- write('# '), !.  % Blocked cell

% Print the entire maze with the path and steps.
print_maze_with_path(MaxX, MaxY, Path, Steps) :-
    forall(between(1, MaxY, Y),
           (forall(between(1, MaxX, X),
                    print_cell(X, Y, Path)),
            nl)),  % New line at the end of each row
    write('Number of steps to solve: '), write(Steps), nl.

% Find and print the path through the maze with the least number of steps.
find_shortest_path(StartX, StartY, EndX, EndY) :-
    solve(StartX, StartY, EndX, EndY, [(StartX, StartY)], Path, Steps),
    reverse(Path, RevPath),  % Reverse the path to get the correct order
    print_maze_with_path(4, 4, RevPath, Steps).


% Check if the cell is open.
is_cell_open(X, Y) :-
    cell(X, Y, open).

% Validate coordinates.
validate_coordinates(X, Y) :-
    is_cell_open(X, Y), !.
validate_coordinates(_, _) :-
    write('The point is blocked or invalid. Please re-enter.'), nl, fail.

% Interactive user input for start and end points with validation.
prompt_for_points :-
    write('Initial Maze Layout: (O for open, B for blocked)'), nl,
    print_maze_layout(4, 4), nl,
    repeat,
        write('Enter Start X: '), read(StartX),
        write('Enter Start Y: '), read(StartY),
        (is_cell_open(StartX, StartY) -> !; write('Start point is blocked. Please re-enter.'), nl, fail),
    repeat,
        write('Enter End X: '), read(EndX),
        write('Enter End Y: '), read(EndY),
        (is_cell_open(EndX, EndY) -> !; write('End point is blocked. Please re-enter.'), nl, fail),
    find_shortest_path(StartX, StartY, EndX, EndY).

    print_maze_layout(MaxX, MaxY) :-
        forall(between(1, MaxY, Y),
               (forall(between(1, MaxX, X),
                        (cell(X, Y, open) -> write('O '); write('B '))),
                nl)).  % New line at the end of each row
% Initiate the search for the shortest path with user input.
:- prompt_for_points.