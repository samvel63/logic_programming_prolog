# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Мхитарян С.А.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |   3 (удовл)           |  23.12.17             |
| Левинская М.А.|              |               |

> Программа частично заимствована, собеседование по реферату и тексту программы не показали полного понимания материала.

## Введение

Курсовой проект позволит мне улучшить навыки по 3 и 4 лабораторной работе(3 поиска: в глубину, ширину, с итерационным погружением и созданию естественно-языкового интерфейса, который обрабатывает некоторые вопросы). Улучшится понимание того, как происходит парсинг и как его вообще надо осуществлять.<br>
Появятся новые знания о Prolog и в целом обо всем программировании. Этому поспособствует написание эссе. 

## Задание

 1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM с использованием сервиса MyHeritage.com 
 2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, используя следующее представление: parents(потомок, отец, мать)
 3. Реализовать предикат проверки/поиска: Золовка 
 4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве
 5. [На оценки хорошо и отлично] Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. 

## Получение родословного дерева

Я создал родословное дерево Льва Толстого на сайте myheritage.com. Пришлось добавить деревей и золовок из-за того, что таких не было в дереве, но по одному из заданий требуется найти золовку.
В родословном дереве присутствует 26 индивидуума.

## Конвертация родословного дерева

Так как в последнее время приходится часто сталкиваться с языком С++(олимпиады, ООП, самостоятельная практика), то выбор упал именно на него. В принципе, парсинг можно реализовать всего за ~70 строчек кода, что по мне не очень сложно.
Хотя, пожалуй, на Python было бы легче реализовать такое же задание.

Программа рассматривает GED файл построчно, разбивая строку на отдельные слова, которые в данной строке нумеруются с 0.<br>
Программа кроме того, что преобразует в вид parents(потомок, отец, мать), записывает всех женщин и мужчин в роду в виде female(женщина) и male(мужчина). Предикаты female(женщина) и male(мужчина) необходимы для выполнения пунктов 3, 4, 5 курсовой работы.
```c
struct TMan {
    string name;
    string surn;
    string id;
};

int main() {
    map<string, string> dic;
    TMan lol;
    map<string, string>::iterator It;
    string temp1;
    string temp2;
    string husb;
    string wife;
    string chil;
    vector<string> female;
    vector<string> male;

    while(cin >> temp2) {
        if(temp2 == "INDI") {
            lol.id = temp1;
        } else if(temp1 == "GIVN") {
            lol.name = temp2;
        } else if(temp1 == "SURN") {
            lol.surn = temp2;
        } else if(temp1 == "_MARNM") {
            lol.surn = temp2;
        } else if(temp1 == "SEX") {
            if(temp2 == "F") {
                female.push_back(lol.surn + " " + lol.name);
            } else if(temp2 == "M") {
                male.push_back(lol.surn + " " + lol.name);
            }
        } else if(temp2 == "0") {
            string tmp = lol.surn + " " + lol.name;
            dic.insert(make_pair(lol.id, tmp));
        } else if(temp2 == "FAM") {
            while(temp2 != "0") {
                if(temp1 == "HUSB") {
                    It = dic.find(temp2);
                    husb = It->second;
                } else if(temp1 == "WIFE") {
                    It = dic.find(temp2);
                    wife = It->second;
                } else if(temp1 == "CHIL") {
                    It = dic.find(temp2);
                    chil = It->second;
                    cout << "parents('" << chil << "', '" << husb << "', '" << wife << "')." << endl;
                }
                temp1 = temp2;
                cin >> temp2;
            }
        }
        temp1 = temp2;
    }
    cout << endl;
    for(auto i : female) {
        cout << "female('" << i << "')." << endl;
    }
    for(auto i : male) {
        cout << "male('" << i << "')." << endl;
    }
    return 0;
}
```
Тест:
```c
parents('Tolstoy Lev', 'Tolstoy Nikolai', 'Volkonskaya Maria').
parents('Volkonskaya Maria', 'Volkonsky Nikolai', 'Trubetskaya Ekaterina').
parents('Tolstoy Nikolai', 'Tolstoy Ilya', 'Akraeva Alisa').
parents('Tolstoy Ilya', 'Tolstoy Andrey', 'Shetinina Aleksandra').
parents('Tolstaya Aleksandra', 'Tolstoy Andrey', 'Shetinina Aleksandra').
parents('Tolstaya Tatyana', 'Tolstoy Andrey', 'Shetinina Aleksandra').
parents('Tolstaya Roman', 'Tolstoy Andrey', 'Shetinina Aleksandra').
parents('Tolstoy Andrey', 'Tolstoy Ivan', 'Polyakina Anastasiya').
parents('Volkonsky Nikolai', 'Volkonsky Sergey', 'Chaadaeva Maria').
parents('Volkonskaya Janna', 'Volkonsky Sergey', 'Chaadaeva Maria').
parents('Volkonsky Bogdan', 'Volkonsky Sergey', 'Chaadaeva Maria').
parents('Volkonsky Sergey', 'Volkonsky Fedor', 'Alexandra Nikolaeva').
parents('Trubetskaya Ekaterina', 'Trubetskoy Dmitriy', 'Odoevskaya Varvara').
parents('Trubetskoy Kirill', 'Trubetskoy Uriy', 'Golovina Olga').
parents('Trubetskoy Dmitriy', 'Trubetskoy Uriy', 'Golovina Olga').
parents('Odoevskaya Varvara', 'Odoevsky Ivan', 'Tolstaya Praskovya').

female('Volkonskaya Maria').
female('Trubetskaya Ekaterina').
female('Shetinina Aleksandra').
female('Chaadaeva Maria').
female('Odoevskaya Varvara').
female('Golovina Olga').
female('Tolstaya Praskovya').
female('Tolstaya Aleksandra').
female('Tolstaya Tatyana').
female('Volkonskaya Janna').
female('Akraeva Alisa').
female('Polyakina Anastasiya').
male('Tolstoy Nikolai').
male('Tolstoy Lev').
male('Volkonsky Nikolai').
male('Tolstoy Ilya').
male('Tolstoy Andrey').
male('Tolstoy Ivan').
male('Volkonsky Sergey').
male('Volkonsky Fedor').
male('Trubetskoy Dmitriy').
male('Trubetskoy Uriy').
male('Odoevsky Ivan').
male('Tolstaya Roman').
male('Trubetskoy Kirill').
male('Volkonsky Bogdan').

```

## Предикат поиска родственника

Предикат ищет золовку - сестра мужа. То есть в предикат вводится имя жены. По нему находится сестра мужа.<br>
Так как предикат может вывести брата, нам необходимо проверить, женщина ли выданный родственник, для этого подходит предикат female(женщина).

```prolog
sister_in_law(Wife, Zol) :-
    parents(_, X, Wife),
    parents(X, Y, Z),
    parents(Zol, Y, Z),
    Zol \= X, female(Zol).
```

```prolog
?- sister_in_law('Volkonskaya Maria', X).
false.

?- sister_in_law('Akraeva Alisa', X).
X = 'Tolstaya Aleksandra' ;
X = 'Tolstaya Tatyana' .

?- sister_in_law('Trubetskaya Ekaterina', X).
X = 'Volkonskaya Janna' .

?- sister_in_law('Volkonsky Sergey', X).
false.
```

## Определение степени родства

Для поиска родства используется поиск из 3 лабораторной работы, а то есть поиск с итеративным погружением.
С помощью предиката check(индивидуум, индивидуум, связь) строится родственная цепочка через отца, мать, сестру, брата, сына, дочь, мужа, отца.

```prolog
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
```

Тесты:
```prolog
?- relative('Tolstoy Lev', 'Volkonsky Fedor', X).
X = [son, daughter, son, son].

?- relative('Volkonsky Fedor', 'Tolstoy Lev', X).
X = [father, father, father, mother].

?- relative('Tolstaya Tatyana', 'Tolstaya Aleksandra', X).
X = [sister].

?- relative('Trubetskaya Ekaterina', 'Volkonskaya Maria', X).
X = [mother].


```

## Естественно-языковый интерфейс

Естественно-языковой интерфейс может отвечать на вопрос о кол-ве близких родственников(братья, сестры и т.д.). Можно спросить "Кто брат Льва Толстого?". Так же можно спросить прямо - "Трубетская Екатерина сестра Льва Толстого?". Так же можно запоминать имя, что обращаться в последующих вопросах через she/he/her это реализовано с помощью предиката nb_setval(latName, name).

```prolog
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
```

Тесты:
```prolog
?- ask([how,many,brothers,does,'Volkonskaya Janna',have,?]).
Volkonskaya Janna have 2 brothers
true.

?- ask([how,many,brothers,does,she,have,?]).
Volkonskaya Janna have 2 brothers
true.

?- ask([how,many,daughters,does,she,have,?]).
false.

?- ask([is,'Volkonsky Nikolai','Volkonskaya Janna',"'s",brother,?]).
true.

?- ask([is,'Volkonsky Bogdan',her,brother,?]).
true.
```
## Выводы

В ходе выполнения данной курсовой работы мне удалось закрепить навыки работы с Prolog. Пришлось погрузится в прошлое Prolog и свое воображение, чтобы понять, что же было бы, если бы Prolog изобрели первым языком программирования.

Интересным и несложным был опыт парсинга на С++. 

В итоге я хочу сказать, что данный курс дался мне нелегко, так как тяжело было перестроиться на новую парадигму программирования, но впечатления, которые он оставил и опыт, подарили мне желание изучать все больше разных граней такого приятного занятия, как программирование.
