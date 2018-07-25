:- consult('result.pl').

:- style_check(-singleton).
better('SWI-Prolog', AnyOtherProlog?).

sister_in_law(Wife, Zol) :- % Золовка
    parents(_, X, Wife),
    parents(X, Y, Z),
    parents(Zol, Y, Z),
    Zol \= X, female(Zol).

check(X,Y,father):-
    parents(Y, X, B).

check(X,Y,mother):-
    parents(Y, B, X).

check(X,Y,sister):-
    female(X),
    parents(X, A, B),
    parents(Y, A, B),
    X \= Y.

check(X,Y,brother):-
    male(X),
    parents(X, A, B),
    parents(Y, A, B),
    X \= Y.

check(X,Y,son):-
    (parents(X, Y, B);parents(X, A, Y)),
    male(X).

check(X,Y,daughter):-
    (parents(X, Y, B);parents(X, A, Y)),
    female(X).

check(X,Y,husband):-
    parents(A, X, Y).

check(X,Y,wife):-
    parents(A, Y, X).

step(X,Y):-
    check(X,Y,_).

check_relation(X):-
    member(X,[father,mother,sister,brother,son,daughter,husband,wife]).
ask_relative(X,Y,Res):- % цепочка родства, через которую связаны 2 человека
    check_relation(Res),!,
    check(X,Y,Res).

relative(X,Y, Res):-
    search_id(X,Y,Res),!.

transform([_],[]):-!.
transform([First,Second|Tail],ResList):-
    length([First,Second|Tail],B),
    A is B - 1,
    length(ResList,A),
    check(First,Second,Relation),
    ResList = [Relation|Tmp],
    transform([Second|Tail],Tmp),!.

prolong([X|T],[Y,X|T]):-
    step(X,Y),
    \+ member(Y,[X|T]).

integer1(1).
integer1(X):-
    integer1(Y),
    X is Y + 1.

search_id(Start,Finish,Path,DepthLimit):-
    depth_id([Start],Finish,Res,DepthLimit),
    reverse(Res,Path).

depth_id([Finish|T],Finish,[Finish|T],0).
depth_id(Path,Finish,R,N):-
    N @> 0,
    prolong(Path,NewPath),
    N1 is N - 1,
    depth_id(NewPath,Finish,R,N1).

search_id(Start,Finish,Path):-
    integer1(Level),
    search_id(Start,Finish,Res,Level),
    transform(Res, Path).

wordQuestion(X):-
    member(X,[how,who,'How','Who']).

quantity(X):-
    member(X,[much,many]).

relatives(X):-
    member(X,[sisters,brothers,sons,daughters]).
rrelative(sister,sisters).
rrelative(brother,brothers).
rrelative(son,sons).
rrelative(daughter,daughters).

wordHelp(X):-
    member(X,[do,does]).              

haveHas(X):-
    member(X,[have,has]).         

is(X):-
    member(X,[is]).               

particle(X):-
    member(X,["'s"]).             

question(X):-
    member(X,['?']).              

pronouns(X):-
    member(X,[his,her,he,she]).               



%                   вопросы
ask(List):-  % how many *relatives* does '*name*' have ?
    List = [A,B,C,D,E,F,H],
    wordQuestion(A), quantity(B), relatives(C), wordHelp(D),
    (male(E);female(E)), nb_setval(lastName,E),
    haveHas(F), question(H),

    rrelative(C1,C),
    setof(X,ask_relative(X,E,C1),T),
    length(T,Res),!,
    write(E), write(" have "),
    ((Res =:= 1,write(Res),write(" "),write( C1));(\+(Res =:= 1),write(Res),write(" "),write( C))),!.

ask(List):- % how many *relatives* does *pronouns* have ?
    List = [A,B,C1,D,E1,F,H],
    wordQuestion(A), quantity(B), relatives(C1), wordHelp(D),
    pronouns(E1), nb_getval(lastName,E),
    haveHas(F), question(H),

    rrelative(C,C1),
    setof(X,ask_relative(X,E,C),T),
    length(T,Res),
    write(E), write(" have "),
    ((Res =:= 1,write(Res),write(" "),write(C));(\+(Res =:= 1),write(Res),write(" "),write(C1))),!.

ask(List):- % who is '*name*' *relation*?
    List = [A,B,C,D,E,F],
    wordQuestion(A), is(B),
    (male(C);female(C)), nb_setval(lastName,C),
    particle(D), check_relation(E), question(F), !,
    check(Res,C,E), write(Res),write(" is "), write(C),write("'s "),write(E).

ask(List):- % who is *pronouns* *relation*?
    List = [A,B,C1,D,E],
    wordQuestion(A), is(B), pronouns(C1),
    nb_getval(lastName,C), check_relation(D), question(E),!,
    check(Res,C,D),
    write(Res),write(" is "), write(C),write("'s "),write(D).

ask(List):- % is '*name*' '*name*' 's *relation*?
    List = [A,B,C,D,E,F],
    nb_setval(lastName,C), is(A),
    (male(B);female(B)),(male(C);female(C)),
    particle(D), check_relation(E), question(F), check(B,C,E),!.

ask(List):- % is '*name*' *pronouns* 's *relation*?
    List = [A,B,C1,D,E],
    is(A), (male(B);female(B)),
    pronouns(C1), check_relation(D), question(E),

    nb_getval(lastName,C),
    check(B,C,D), !.

