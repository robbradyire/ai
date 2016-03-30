lc(X,KB) :- cn(C,KB), member(X,C).

cn(C,KB) :- cn([],C,KB).
cn(TempC,C,KB) :- member([H|B],KB),
                  all(B,TempC),
                  nonmember(H,TempC),
                  cn([H|TempC],C,KB).
cn(C,C,_).

all([],_).
all([H|T],L) :- member(H,L), all(T,L).

nonmember(_,[]).
nonmember(X,[H|T]) :- X\=H, nonmember(X,T).

appendC([_], List, List).
appendC([H1,H2|Tail], KB, [[H2]|NewKB]) :- appendC([H1|Tail], KB, NewKB).

lcRule([H|Tail],KB) :- appendC([H|Tail], KB, NewKB), lc(H, NewKB),!.
