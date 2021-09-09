

:- module(
    basic_functions,
    [ divide_into_digits/2, table_concat/2, diff/3 ]
).


divide_into_digits( X, L ) :-
    inner_div( X, RevL ),
    (
        (
            RevL == [],
            L is [0]
        );
        reverse( RevL, L )
    ),
    !.

inner_div( 0, [] ).
inner_div( X, [LH|L] ) :-
    Y is X // 10,
    inner_div( Y, L ),
    LH is X mod 10.

%

table_concat( [], "" ).
table_concat( [Head|Tail], X ) :-
    table_concat( Tail, Prev_X ),
    string_concat( Head, Prev_X, X ).

%

diff( Diff, NumBig, NumSmall ) :-
    (
        not( var( NumSmall ) ),
        !,
        Sum is NumSmall + Diff,
        NumBig = Sum
    );
    (
        not( var( NumBig ) ),
        !,
        Sum is NumBig - Diff,
        NumSmall = Sum
    ).

%
