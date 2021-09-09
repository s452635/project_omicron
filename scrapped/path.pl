
%
%   unused in final build; unfinished
%   stubs of a pathfinding algorhytm
%


:- module(
    path,
    [
        find_path/5, find_path/6,
        the_absolute_init/3
    ]
).

:- use_module( text_messages ).
:- use_module( text_functions ).
:- use_module( timeday ).


%
%   paths
%

find_path(
    StopStart, date(WeekdayStart,HourStart,MinuteStart),
    StopFinish, date(WeekdayFinish,HourFinish,MinuteFinish),
    ChoiceChanges, ChoiceSort
) :-
    write_block( [ StopStart, WeekdayStart, HourStart, MinuteStart,
        StopFinish, WeekdayFinish, HourFinish, MinuteFinish,
        ChoiceChanges, ChoiceSort ] ),
    write( "welcome to bigger path finder" ), nl.

find_path(
    StopStart, date(WeekdayStart,HourStart,MinuteStart),
    StopFinish,
    ChoiceChanges, ChoiceSort
) :-
    write_block( [ StopStart, WeekdayStart, HourStart, MinuteStart,
        StopFinish, ChoiceChanges, ChoiceSort ] ),
    write( "welcome to path finder" ), nl.


%
%   tests
%

the_absolute_init( StartCapDate, StartStop, FinishCapStop ) :-

    all_dep_utsde( StartCapDate, StartStop, FinishCapStop, AllDepSorted ),
    iterate( AllDepSorted, FinishCapStop, 0 ).

iterate( AllDepSorted, FinishCapStop, TrainChanges ) :-

    go_throught_list( AllDepSorted, FinishCapStop, 0, TrainChanges ),
    read( Input ),  % TODO : find other reason
    (
        Input == y ->
            MoreTrainChanges is TrainChanges + 1,
            iterate( AllDepSorted, FinishCapStop, MoreTrainChanges )
    ).

go_throught_list( IterList, FinishCapStop, 20, TrainChanges ) :- !,
    read( Input ),
    (
        Input == y,
        go_throught_list( IterList, FinishCapStop, 0, TrainChanges )
    ).
go_throught_list( [], _, _, _ ) :- !.
go_throught_list( [H|Tail], FinishCapStop, TotalFound, TrainChanges ) :-
    go_throught_route( H, FinishCapStop, Found, TrainChanges ),
    NewTotalFound is TotalFound + Found,
    go_throught_list( Tail, FinishCapStop, NewTotalFound, TrainChanges ). % recur further

    go_throught_route( % found a path
        ( _, RouteId, StartStop, StartDate, FinishCapStop, FinishDate ),
        FinishCapStop, Found, 0
    ) :-

        !, Found = 1.

go_throught_route(
    ( _, RouteId, StartStop, StartDate, FinishStop, FinishDate ),
    FinishCapStop, Found, TrainChanges
) :-

    (
        link( FinishStop, NextStop, TravelDate, TravelTime, RouteId ),
        !,
        (
            TrainChanges == 0 -> true;
                ( % TODO : switching the train
                    all_dep_utsde( FinishDate, FinishStop, FinishCapStop, AllDepSorted ),
                    write_block( AllDepSorted ),
                    iterate( AllDepSorted, FinishCapStop, 0 )
                )
        ),
        time_calc( TravelDate, NextDate, TravelTime ),
        go_throught_route(
            ( _, RouteId, StartStop, StartDate, NextStop, NextDate ),
            FinishCapStop, Found, TrainChanges
        )
    );
    !, Found = 0.


%
%   helpers
%

all_dep_utsde( % utsde -> untill the same date earlier
    % in
        StartCapDate, StartStop, FinishCapStop,
    % out
        AllDepSorted
) :-

    findall(
        ( SortingTime, RouteId, StartStop, StartDate, FinishStop, FinishDate ),
        find_dep_utsde(
            RouteId, SortingTime, StartCapDate,
            StartStop, StartDate,
            FinishStop, FinishDate
        ),
        AllDep
    ),
    sort( 1, @<, AllDep, AllDepSorted ).

find_dep_utsde( % utsde -> untill the same date earlier
    RouteId, SortingTime, date(StartCapDay,StartCapHour,StartCapMinute),
    StartStop, date(StartDay,StartHour,StartMinute),
    FinishStop, date(FinishDay,FinishHour,FinishMinute)
) :-

    link(
        StartStop, FinishStop,
        date(StartDay,StartHour,StartMinute), time(TravelHour,TravelMinute),
        RouteId
    ),

    %   untill the same day earlier
    (
        not( StartCapDay == StartDay ) -> true;
            (
                StartCapHour < StartHour -> true;
                    ( StartCapMinute < StartMinute -> true )
            )
    ),

    %   sorting time
    time_calc(
        date(StartCapDay,StartCapHour,StartCapMinute),
        date(StartDay,StartHour,StartMinute),
        time(DiffHour,DiffMinute)
    ),
    SortingTime is DiffHour*100 + DiffMinute,

    %   finish time
    time_calc(
        date(StartDay,StartHour,StartMinute),
        date(FinishDay,FinishHour,FinishMinute),
        time(TravelHour,TravelMinute)
    ).
