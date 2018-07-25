memb(X,[X|_]). % проверка на принадлежность
memb(X,[_|Y]):-
memb(X,Y).

subl(Sub,List):- % проверка вхождения
    app(_,Y2,List), %списка в качестве подсписка
    app(Sub,_,Y2).

rem(X, [X|T], T). % удаление из списка
rem(X, [Y|T], [Y|T1]):-
    rem(X,T,T1).

perm([],[]):-!. % перестановка списка
perm(L,[X|T]):-
    rem(X,L,R),
    perm(R,T).

perm1([],[]):-!. % перестановка списка
perm1(L,[X|T]):-
    rem(X,L,R),
    perm1(R,T), !.

surname(borisov).
surname(kirillov).
surname(danin).
surname(savin).

prof(mechanic).
prof(chemist).
prof(builder).
prof(radioman).

%last([_,_,_,_],D).

third([_,_,C,_],C).
second([_,B,_,_],B).
first([A,_,_,_],A).

xy(X,Y,[X|T]):-
    memb(Y,T).
xy(X,Y,[A|T]):-
    xy(X,Y,T).

result(Res):- %Борисов, Кириллов, Данин, Санин
    perm([borisov, kirillov, danin, savin], [X1,X2,X3,X4]),
    perm([mechanic, chemist, builder, radioman],[Y1,Y2,Y3,Y4]),

    Res = [p(X1,Y1),p(X2,Y2),p(X3,Y3),p(X4,Y4)],

    \+last(Res,p(borisov,_)),
    \+first(Res,p(borisov,_)),
    \+last(Res,p(kirillov,_)),

    \+first(Res,p(_,chemist)),
    \+last(Res,p(_,chemist)),

    perm(Res,Chess),
    last(Res,Oldest),
    last(Chess,Oldest),
    \+last(Chess,p(borisov,_)),
    \+first(Chess,p(borisov,_)),

    xy(p(borisov,_),p(savin,_),Chess),
    xy(p(danin,_),p(borisov,_),Chess),

    xy(p(_,builder),p(_,mechanic),Chess),

    perm(Res,Theater),
    last(Theater,Oldest),

    xy(p(_,mechanic),p(_,chemist),Theater),
    xy(p(_,chemist),p(_,builder),Theater),

    xy(p(kirillov,_),A,Res),
    xy(A,p(borisov,_),Theater),

    perm(Res,Ski),
    first(Res,Youngest),
    last(Ski,Youngest),
    \+first(Ski,p(borisov,_)),
    xy(p(_,builder),p(_,radioman),Ski).

    xy(M,p(borisov,_),Res),

    xy(M,p(borisov,_),Ski).
