
%%% sep 5 / 06:20

start_the_path( StartCapDate, StartStop, FinishCapStop ) :-

    findall(
        ( SortingTime, RouteId, StartStop, StartDate, FinishStop, FinishDate ),
        find_trains_leaving_this_week(
            RouteId, SortingTime, StartCapDate,
            StartStop, StartDate,
            FinishStop, FinishDate
        ),
        AllDep
    ),
    sort( 1, @<, AllDep, AllDepSorted ),
    go_throught_iteration( AllDepSorted, FinishCapStop, 0, 1 ).

find_trains_leaving_this_week(
    RouteId, SortingTime, date(StartCapDay,StartCapHour,StartCapMinute),
    StartStop, date(StartDay,StartHour,StartMinute),
    FinishStop, date(FinishDay,FinishHour,FinishMinute)
) :-

    %   finding and checking
    link(
        StartStop, FinishStop,
        date(StartDay,StartHour,StartMinute), time(TravelHour,TravelMinute),
        RouteId
    ),
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


go_throught_iteration( IterList, FinishCapStop, 5, TrainChanges ) :- !,
    write_block( ["<<< found enoth >>>"] ),
    read( X ),
    (
        X == y,
        go_throught_iteration( IterList, FinishCapStop, 0, TrainChanges )
    ).
go_throught_iteration( [], _, _, _ ) :- !, write_block( ["<<< runned outta possbles >>>"] ).
go_throught_iteration( [H|Tail], FinishCapStop, TotalFound, TrainChanges ) :-
    write_block( ["< started a path >"] ),
    first_iteration( H, FinishCapStop, Found, TrainChanges ),
    NewTotalFound is TotalFound + Found,
    go_throught_iteration( Tail, FinishCapStop, NewTotalFound, TrainChanges ). % recur further


first_iteration( % found a path
    ( _, RouteId, StartStop, StartDate, FinishCapStop, FinishDate ),
    FinishCapStop, Found, 0
) :-

    !, Found = 1,
    write_block( ["< found a path >"] ).

first_iteration( % go further this line
    ( _, RouteId, StartStop, StartDate, FinishStop, FinishDate ),
    FinishCapStop, Found, TrainChanges
) :-

    (
        link( FinishStop, NextStop, TravelDate, TravelTime, RouteId ),
        !,
        write_list( [TrainChanges, " ", FinishStop] ),
        ( % TODO : leaving the train
            TrainChanges == 0 -> true;
                write_block( ["left the train"] )
        ),
        time_calc( TravelDate, NextDate, TravelTime),
        first_iteration(
            ( _, RouteId, StartStop, StartDate, NextStop, NextDate ),
            FinishCapStop, Found, TrainChanges
        )
    );
    !, Found = 0,
    write_block( ["    < cap >"] ).

%%%
