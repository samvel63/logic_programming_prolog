% Task 2: Relational Data

% The line below imports the data
:- ['one.pl'].

% Вариант 3

% X - номер группы, L - список группы
group(X,L) :-
    findall(Z,student(X,Z),L).


% X - список всех оценок студента, Y - средний балл
average_mark(X, Y) :-
    sum_list(X, Sum),
    length(X, N),
    Y is Sum / N.

% X - студент, С - список всех оценок ученика
marks(X, C) :-
    findall(Y, grade(X, _, Y), C).

% Х - студент, Res - средний балл
studentAverageMark(X, Res) :-
    marks(X, Y),
    average_mark(Y, Res).

% Проверка, сдал ли студент предмет. Если "yes" или "true", то сдал, иначе не сдал.
studentCheckPassExam(X) :-
    marks(X, R),
    \+member(2, R).

% X - предмет, N - кол-во студентов не сдавших предмет
studentNumberOfFailedExam(X, N) :-
    subject(Y, X),
    findall(A, grade(A, Y, 2), C),
    length(C, N).

% X - номер группы, Res - фамилия ученика с набольшим средним баллом в группе
groupMaxAverageMark(X, Res) :-
    findall(A, (group(X, L), member(Y, L), studentAverageMark(Y, A)), M),
    max_list(M, R),
    findall(S, (group(X, L), member(S, L), studentAverageMark(S, R)), Res).