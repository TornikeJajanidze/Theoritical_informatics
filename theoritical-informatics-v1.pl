% Define the maze layout.
cell(1, 1, open). cell(1, 2, blocked). cell(1, 3, blocked). cell(1, 4, blocked).
cell(2, 1, open). cell(2, 2, open). cell(2, 3, open). cell(2, 4, open).
cell(3, 1, blocked). cell(3, 2, blocked). cell(3, 3, open). cell(3, 4, open).
cell(4, 1, open). cell(4, 2, open). cell(4, 3, blocked). cell(4, 4, open).

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

% Solve the maze using depth-first search with a step counter.
solve(X, Y, Visited, Path, Steps) :-
    end(X, Y),  % Reached the end
    length(Visited, L), 
    Steps is L - 1,  % Subtracting 1 because the starting cell isn't a step.
    Path = Visited.

solve(X, Y, Visited, Path, Steps) :-
    move(X, Y, X1, Y1),  % Try a move.
    valid_move(X1, Y1, Visited),  % Check if the move is valid.
    solve(X1, Y1, [(X1, Y1)|Visited], Path, Steps).  % Continue from the new position.

% Print each cell of the maze with ASCII characters.
print_cell(X, Y, Path) :- member((X, Y), Path), write('X '), !. % Path cell
print_cell(X, Y, _) :- start(X, Y), write('S '), !.  % Start cell
print_cell(X, Y, _) :- end(X, Y), write('E '), !.  % End cell
print_cell(X, Y, _) :- cell(X, Y, blocked), write('# '), !.  % Blocked cell
print_cell(_, _, _) :- write('. '), !.  % Open cell

% Print the entire maze with the path and steps.
print_maze_with_path(MaxX, MaxY, Path, Steps) :-
    forall(between(1, MaxX, X),
           (forall(between(1, MaxY, Y),
                    print_cell(X, Y, Path)),
            nl)),  % New line at the end of each row
    write('Number of steps to solve: '), write(Steps), nl.

% Find and print the path through the maze with the least number of steps.
find_shortest_path :-
    start(StartX, StartY),
    solve(StartX, StartY, [(StartX, StartY)], Path, Steps),
    reverse(Path, RevPath),  % Reverse the path to get the correct order
    print_maze_with_path(4, 4, RevPath, Steps).

% Initiate the search for the shortest path.
:- find_shortest_path.
