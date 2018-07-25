% Реализация стандартных предикатов обработки списков:

% 1) lenght - необходим для получения длины списка

myLength([],0).
myLength([X|T],N) :- 
      myLength(T,N1), 
      N is N1+1.

% Пример: 
% | ?- myLength([1, 27, 20], N).
%  N = 3

% 2) member - необходим для проверки принадлежности элемента к списку

myMember(X,[X|_]). 
myMember(X,[_|Y]):-
   myMember(X,Y).

% Пример: 
% | ?- myMember(3, [3, 5 ,6]).
% true ? 
% yes
% | ?- myMember(20, [1, 2, 3]).
% no

% 3) append - необходим для слияния двух списков в третий 

myAppend([], L, L). 
myAppend([X|L1], L2, [X|L3]):-
    myAppend(L1, L2, L3).

% Пример: 
% | ?- myAppend([1, 2], [3], Y).
% Y = [1,2,3]

% 4) delete - необходим для удаления элемента из списка

myDelete(X,[X|T],T).
myDelete(X,[H|T],[H|N]):-
   myDelete(X,T,N).

% Пример: 
% | ?- myDelete(2, [1, 2, 3], X).
% X = [1,3] ? 
% yes
% | ?- myDelete(1, [1, 2, 3], X).
% X = [2,3] ? 
% yes

% 5) permute - необходим для проверки списка на перестановку

myPermute([], []).
myPermute(L, [X | T]):-
    myDelete(X, L, Y),
    myPermute(Y, T).

% Пример: 
% | ?- myPermute([1, 2, 3], [1, 2, 3]).
% true ? 
% yes
% | ?- myPermute([1, 2, 3], [3, 2, 1]).
% true ? 
% yes
% | ?- myPermute([1, 2, 3], [1, 3, 2]).
% true ? 
% yes
% | ?- myPermute([1, 2, 3], [1, 4, 3]).
% no
%| ?- myPermute([1, 2, 3], [1, 3, 3]).
% no

% 6) sublist - необходим для проверки вхождения одного списка в другой список
 
mySublist([],[]).
mySublist([X|L],[X|S]):-
    mySublist(L,S).
mySublist(L, [_|S]):-
    mySublist(L,S).

% Пример: 
% | ?- mySublist([1, 2], [1, 2, 3, 4]).
% true ? 
% yes
% | ?- mySublist([0, 2], [1, 2, 3, 4]).
% no

% Задача №4. Удаление элемента с заданным номером (11 вариант)

% Без помощи стандартных предикатов

del_1(_,[],[]).
del_1(1,[_|Tail],Tail) :-!.
    I1 is I - 1,
    del_1(I1,Tail,NewTail).
    

% Пример:
% | ?- del_1(1, [1, 2, 3, 4, 5], X).
% X = [2,3,4,5]
% yes
% | ?- del_1(5, [2, 4, 6, 1, 40, 90], X).
% X = [2,4,6,1,90]
% yes
% | ?- del_1(2, [3, 4, 5], X).
% X = [3,5]
% yes

% С помощью стандартных предикатов

del_n([] ,_ ,_ ,M ,M):-!.
del_n([H|T], Index, N, L, List):-
    Index < N,
    Index1 = Index + 1,
    append(L, [H], L2),
    del_n(T, Index1, N, L2, List).
 del_n([H|T], Index, N, L, List):-
    Index > N,
    Index1 = Index + 1,
    append(L, [H], L2),
    del_n(T, Index1, N, L2, List).   
del_n([_|T], Index, N, L, List):-
    Index1 = Index + 1,
    del_n(T, Index1, N, L, List).

    
% Пример:
% | ?- del_n([1,2,3,3,4,5], 1, 3, [], List).
% List = [1,2,3,4,5] ? 
% yes
% | ?- del_n([3],1,1,[],List).
% List = []
% yes
% | ?- del_n([1, 3],1,3,[],List).
% List = [1,3] ? 
% yes

% Задача №5. Вычисление суммы двух векторов-списков (с учетом возможного несовпадения размерностей) (16 вариант)

% Без помощи стандартных предикатов
sum([],0).
sum([H|T],Sum):-  
    sum(T,Sum1),  
    Sum=H+Sum1.

sumall([], [], 0).
sumall(X, Y, N) :-
    sum(X, A),
    sum(Y, B),
    N is A + B.

% Пример:
% | ?- sumall([1, 3, 1], [2, 0], X).
% X = 7
% yes
% | ?- sumall([1, 2], [1, 2], X).
% X = 6
% yes
% | ?- sumall([1, 2, 3], [5, 20], X).
% X = 31
% yes
% | ?- 

% С помощью стандартных предикатов
sumOfTwoLists([], [], 0).
sumOfTwoLists(X, Y, N) :-
    sum_list(X, A),
    sum_list(Y, B),
    N is A + B.

% Пример:
% | ?- sumOfTwoLists([1, 3, 1], [2, 0], X).
% X = 7
% yes
% | ?- sumOfTwoLists([1, 2], [1, 2], X).
% X = 6
% yes
% | ?- sumOfTwoLists([1, 2, 3], [5, 20], X).
% X = 31
% yes
% | ?- 

% Содержательный пример:
% Поменять элементы с четными и нечетными индексами местами

replace_index([],M,M).
replace_index([X,Y|T],L,List):-
    append(L,[Y],L1),
   append(L1,[X],L2),
   replace_index(T,L2,List).

% Пример
% | ?- replace_index([2,1,4,3,6,5],[],Rep).
% Rep = [1,2,3,4,5,6]
% yes
