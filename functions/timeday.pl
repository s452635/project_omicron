
:- module(
    timeday,
    [
        date/3, time/2,
        weekday/1, weekday_full/2, next_weekday/2,
        time_calc/3,
        printable_time/2, printable_date/2
    ]
).

:- use_module( basic_functions, [table_concat/2] ).
:- use_module( text_functions, [write_list/1] ).


%
%   date and time definitions
%

% a time stamp
date( DayOfWeek, HourOfDay, MinuteOfHour ) :-
    weekday( DayOfWeek ),
    HourOfDay >= 0, HourOfDay =< 23,
    MinuteOfHour >= 0, MinuteOfHour =< 59.

% an amount of time
time( HourAmount, MinuteOfHour ) :-
    HourAmount >= 0,
    MinuteOfHour >= 0, MinuteOfHour =< 59.


%
%   weekday and its functions
%

weekday( mon ).
weekday( tue ).
weekday( wed ).
weekday( thu ).
weekday( fri ).
weekday( sat ).
weekday( sun ).

weekday_full( mon, "Monday" ).
weekday_full( tue, "Tuesday" ).
weekday_full( wed, "Wednesday" ).
weekday_full( thu, "Thursday" ).
weekday_full( fri, "Friday" ).
weekday_full( sat, "Saturday" ).
weekday_full( sun, "Sunday" ).

next_weekday( mon, tue ).
next_weekday( tue, wed ).
next_weekday( wed, thu ).
next_weekday( thu, fri ).
next_weekday( fri, sat ).
next_weekday( sat, sun ).
next_weekday( sun, mon ).

% internal
add_weekday( DayStart, DayFinish, Diff ) :-
    inner_add_weekday( DayStart, DayFinish, Counter ),
    (
        ( Diff = Counter, ! );
        (
            var(Counter) -> Counter > Diff ->
                !, fail
        )
    ).
inner_add_weekday( DayStart, DayStart, 0 ).
inner_add_weekday( DayStart, DayFinish, Counter ) :-
    inner_add_weekday( DayStart, DayPrev, CounterMinus ),
    next_weekday( DayPrev, DayFinish ),
    Counter is CounterMinus + 1.


%
%   datetime operations
%

time_calc(
    date( StartDay,  StartHour,  StartMinute ),
    date( FinishDay, FinishHour, FinishMinute ),
    time( TravelHour, TravelMinute )
) :-

    (
        (
            not(var( StartDay )), not(var( StartHour )), not(var( StartMinute )),
            not(var( TravelHour )), not(var( TravelMinute )) ->
                (!, time_finish( date( StartDay,  StartHour,  StartMinute ), date( FinishDay, FinishHour, FinishMinute ), time( TravelHour, TravelMinute ) ))
        );
        (
            not(var( FinishDay )), not(var( FinishHour )), not(var( FinishMinute )),
            not(var( TravelHour )), not(var( TravelMinute )) ->
                (!, time_start( date( StartDay,  StartHour,  StartMinute ), date( FinishDay, FinishHour, FinishMinute ), time( TravelHour, TravelMinute ) ))
        );
        (
            not(var( StartDay )), not(var( StartHour )), not(var( StartMinute )),
            not(var( FinishDay )), not(var( FinishHour )), not(var( FinishMinute )) ->
                (!, time_travel( date( StartDay,  StartHour,  StartMinute ), date( FinishDay, FinishHour, FinishMinute ), time( TravelHour, TravelMinute ) ))
        )
    ),
    (
        StartDay == FinishDay ->
            (
                ( ( StartHour == FinishHour, StartMinute > FinishMinute ) -> !, fail );
                ( StartHour > FinishHour -> (!, fail); true )
            ); true
    ).

% internal
time_finish(
    date( StartDay,  StartHour,  StartMinute ),
    date( FinishDay, FinishHour, FinishMinute ),    % unknown
    time( TravelHour, TravelMinute )
) :-

    CalcMinute is StartMinute + TravelMinute,
    CalcHour is StartHour + TravelHour + CalcMinute//60,

    FinishMinute is CalcMinute mod 60,
    FinishHour is CalcHour mod 24,

    (
        CalcHour < 24 ->
            FinishDay = StartDay;
            (
                DayGap is CalcHour//24,
                add_weekday( StartDay, FinishDay, DayGap )
            )
    ).

% internal
time_start(
    date( StartDay,  StartHour,  StartMinute ),     % unknown
    date( FinishDay, FinishHour, FinishMinute ),
    time( TravelHour, TravelMinute )
) :-

    CalcMinute is FinishMinute - TravelMinute,
    CalcHour is FinishHour - TravelHour - CalcMinute//60,

    StartMinute is CalcMinute mod 60,
    StartHour is CalcHour mod 24,

    (
        CalcHour < 24 ->
            FinishDay = StartDay;
            (
                DayGap = CalcHour//24,
                add_weekday( StartDay, DayGap, FinishDay )
            )
    ).

% internal
time_travel(
    date( StartDay,  StartHour,  StartMinute ),
    date( FinishDay, FinishHour, FinishMinute ),
    time( TravelHour, TravelMinute )                % unknown
) :-

    CalcMinute is FinishMinute - StartMinute,
    TravelMinute is CalcMinute mod 60,

    (
        CalcMinute > 0 ->
            CalcHour is FinishHour - StartHour;
            CalcHour is FinishHour - StartHour - 1
    ),
    add_weekday( StartDay, FinishDay, DayGap ),
    TravelHour is CalcHour + DayGap*24.


%
%   printable time and date
%

printable_time( time(Hour,Minute), PrintableTime ) :-

    atom_string( Minute, StrMinute ),

    (
        Hour < 24 ->
            (
                atom_string( Hour, StrHour ),
                table_concat( [ StrHour, "h ", StrMinute, "min" ], PrintableTime )
            );
            (
                HourMod24 is Hour mod 24,
                atom_string( HourMod24, StrHour ),
                Day is Hour // 24,
                atom_string( Day, StrDay ),
                table_concat( [ StrDay, "d ", StrHour, "h ", StrMinute, "min" ], PrintableTime )
            )
    ).

printable_date( date( Day, Hour, Minute ), X ) :-

    atom_length( Hour, HourLength ),
    (
        HourLength == 1 ->
            (
                atom_string( Hour, Str_Half_Hour ),
                string_concat( "0", Str_Half_Hour, Str_Hour )
            );
            atom_string( Hour, Str_Hour )
    ),

    atom_length( Minute, MinuteLength ),
    (
        MinuteLength == 1 ->
            (
                atom_string( Minute, Str_Half_Minute ),
                string_concat( "0", Str_Half_Minute, Str_Minute )
            );
            atom_string( Minute, Str_Minute )
    ),

    atom_string( Day, Str_Day ),
    table_concat( [ Str_Day, ", ", Str_Hour, ":", Str_Minute ], X ).
