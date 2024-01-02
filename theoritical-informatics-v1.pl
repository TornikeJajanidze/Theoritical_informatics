%dataset 1
cell(1, 1, open).
cell(1, 2, blocked).
cell(1, 3, blocked).
cell(1, 4, blocked).
cell(2, 1, open).
cell(2, 2, open).
cell(2, 3, open).
cell(2, 4, open).
cell(3, 1, blocked).
cell(3, 2, blocked).
cell(3, 3, open).
cell(3, 4, open).
cell(4, 1, open).
cell(4, 2, open).
cell(4, 3, blocked).
cell(4, 4, open).

% Define the start and end points of the maze.
start(1, 1).
end(4, 4).

% Define possible moves: right, left, up, down.
move(X, Y, X1, Y) :- X1 is X + 1.  % Move right
move(X, Y, X1, Y) :- X1 is X - 1.  % Move left
move(X, Y, X, Y1) :- Y1 is Y + 1.  % Move down
move(X, Y, X, Y1) :- Y1 is Y - 1.  % Move up

% Check if a move is valid: the cell must be open and not previously visited.
valid_move(X, Y, Visited) :-
    cell(X, Y, open),
    \+ member((X, Y), Visited).

% Solve the maze using depth-first search.
solve(X, Y, Path, Path) :- end(X, Y).  % Reached the end
solve(X, Y, Visited, Path) :-
    move(X, Y, X1, Y1),  % Try a move.
    valid_move(X1, Y1, Visited),  % Check if the move is valid.
    solve(X1, Y1, [(X1, Y1)|Visited], Path).  % Continue from the new position.

% Print each cell of the maze with ASCII characters.
print_cell(X, Y, Path) :- member((X, Y), Path), write('X '), !. % Path cell
print_cell(X, Y, _) :- start(X, Y), write('S '), !.  % Start cell
print_cell(X, Y, _) :- end(X, Y), write('E '), !.  % End cell
print_cell(X, Y, _) :- cell(X, Y, blocked), write('# '), !.  % Blocked cell
print_cell(_, _, _) :- write('. '), !.  % Open cell

% Print the entire maze with the path.
print_maze_with_path(MaxX, MaxY, Path) :-
    start(StartX, StartY),
    solve(StartX, StartY, [(StartX, StartY)], Path),
    reverse(Path, RevPath),  % Reverse the path to get the correct order
    between(1, MaxX, X),
    between(1, MaxY, Y),
    print_cell(X, Y, RevPath),
    (Y == MaxY -> nl ; true),  % New line at the end of each row
    (X == MaxX, Y == MaxY -> nl ; true),  % Extra new line at the end of the maze
    fail.  % Continue to the next cell
print_maze_with_path(_, _).

% Find and print the path through the maze.
find_and_print_path :-
    print_maze_with_path(4, 4, _).