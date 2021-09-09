
:- module(
    arr_dep,
    [
        init_arr_dep/2, init_arr_dep/3
    ]
).

:- use_module( data_functions ).
:- use_module( basic_functions ).
:- use_module( text_functions ).
:- use_module( text_messages ).
:- use_module( timeday ).


%
%   inits
%

init_arr_dep( Stop, date(Day,Hour,Minute), Span ) :-

    % id lists
    findall(
        [SortableDate,RouteId,OutDate],
        routeId_finder( "arr", Stop, date(Day,Hour,Minute), Span, RouteId, OutDate, SortableDate ),
        ListArr
    ),
    findall(
        [SortableDate,RouteId,OutDate],
        routeId_finder( "dep", Stop, date(Day,Hour,Minute), Span, RouteId, OutDate, SortableDate ),
        ListDep
    ),

    % header
    string_upper( Stop, StopCap ),
    printable_date( date(Day,Hour,Minute), DatePrint ),
    string_upper( DatePrint, DatePrintUpper ),
    table_concat( [ StopCap, " (", DatePrintUpper, ") in next ", Span, " hours" ], TableHeader ),

    % main init
    inner_init_arr_dep( ListArr, ListDep, Stop, TableHeader ).

init_arr_dep( Stop, weekday(Day) ) :-

    % id lists
    findall(
        [SortableDate,RouteId,date(Day,Hour,Minute)],
        routeId_finder("arr", Stop, date(Day,Hour,Minute), RouteId, SortableDate),
        ListArr
    ),
    findall(
        [SortableDate,RouteId,date(Day,Hour,Minute)],
        routeId_finder("dep", Stop, date(Day,Hour,Minute), RouteId, SortableDate),
        ListDep
    ),

    % header
    string_upper( Stop, StopCap ),
    weekday_full( Day, DayFull ),
    string_upper( DayFull, DayFullUpper ),
    table_concat( [ StopCap, " on ", DayFullUpper ], TableHeader ),

    % main innit
    inner_init_arr_dep( ListArr, ListDep, Stop, TableHeader ).

% internal
inner_init_arr_dep( ListArr, ListDep, Stop, TableHeader ) :-

    % cleaning before
    tty_clear(),
    database_clean( "arr" ),
    database_clean( "dep" ),

    % making the tables and writing them to file
    sort( 1, @<, ListArr, SortedListArr ),
    table_verse_arr( SortedListArr, Stop ),
    sort( 1, @<, ListDep, SortedListDep ),
    table_verse_dep( SortedListDep, Stop ),

    % init the table showing
    show_table_arr( TableHeader ),

    % cleaning after
    database_clean( "arr" ),
    database_clean( "dep" ).


%
%   id finders
%

routeId_finder( "arr", Stop, date(Day,Hour,Minute), Span, RouteId, date(FoundDay,FoundHour,FoundMinute), SortableDate ) :-
    link( _, Stop, date(FoundDay,FoundHour,FoundMinute), _, RouteId ),
    time_calc( date(Day,Hour,Minute), date(FoundDay,FoundHour,FoundMinute), time(DiffHour,DiffMinute) ),
    (
        DiffHour < Span;
        DiffHour = Span, DiffMinute = 0
    ),
    SortableDate is DiffHour*100 + DiffMinute.

routeId_finder( "dep", Stop, date(Day,Hour,Minute), Span, RouteId, date(FoundDay,FoundHour,FoundMinute), SortableDate ) :-
    link( Stop, _, date(FoundDay,FoundHour,FoundMinute), _, RouteId ),
    time_calc( date(Day,Hour,Minute), date(FoundDay,FoundHour,FoundMinute), time(DiffHour,DiffMinute) ),
    (
        DiffHour < Span;
        DiffHour = Span, DiffMinute = 0
    ),
    SortableDate is DiffHour*100 + DiffMinute.

routeId_finder( "arr", Stop, date(Day,Hour,Minute), RouteId, SortableDate ) :-
    link( _, Stop, date(Day,Hour,Minute), _, RouteId ),
    SortableDate is Hour*100 + Minute.

routeId_finder( "dep", Stop, date(Day,Hour,Minute), RouteId, SortableDate ) :-
    link( Stop, _, date(Day,Hour,Minute), _, RouteId ),
    SortableDate is Hour*100 + Minute.


%
%   table verses
%

table_verse_arr( [], _ ) :- !.
table_verse_arr( [[_,RouteId,Time]|TailArr], Stop ) :-

    % commissioning verse
    city_stop_list_arr( RouteId, Stop, CityStopList ),
    make_stop_str_block( "arr", CityStopList, StopStrBlock ),
    write_verse_to_file( "arr", RouteId, Time, StopStrBlock ),

    % continue down the list
    table_verse_arr( TailArr, Stop ).

city_stop_list_arr( RouteId, Stop, CityStopList ) :-
    link( StopFrom, Stop, _, _, RouteId ),
    inner_city_stop_list_arr( RouteId, StopFrom, CityStopList ).

inner_city_stop_list_arr( RouteId, Stop, CityStopList ) :-
    (
        (
            link( StopFrom, Stop, _, _, RouteId ) ->
                (
                    !, inner_city_stop_list_arr( RouteId, StopFrom, OldCityStopList ),
                    (
                        (
                            city( Stop ) ->
                                !, CityStopList = [Stop|OldCityStopList]
                        );
                        CityStopList = OldCityStopList
                    )
                )
        );
        CityStopList = [Stop], !
    ).

table_verse_dep( [], _ ) :- !.
table_verse_dep( [[_,RouteId,Time]|TailDep], Stop ) :-

    % commissioning verse
    city_stop_list_dep( RouteId, Stop, CityStopList ),
    make_stop_str_block( "dep", CityStopList, StopStrBlock ),
    write_verse_to_file( "dep", RouteId, Time, StopStrBlock ),

    % continue down the list
    table_verse_dep( TailDep, Stop ).

city_stop_list_dep( RouteId, Stop, CityStopList ) :-
    link( Stop, StopTo, _, _, RouteId ),
    inner_city_stop_list_dep( RouteId, StopTo, CityStopList ).

inner_city_stop_list_dep( RouteId, Stop, CityStopList ) :-
    (
        (
            link( Stop, StopTo, _, _, RouteId ) ->
                (
                    !, inner_city_stop_list_dep( RouteId, StopTo, OldCityStopList ),
                    (
                        (
                            city( Stop ) ->
                                !, CityStopList = [Stop|OldCityStopList]
                        );
                        CityStopList = OldCityStopList
                    )
                )
        );
        CityStopList = [Stop], !
    ).


%
%   table showing
%

show_table_arr( TableHeader ) :-

    tty_clear(), nl,

    table_concat( [ "arrivals to ", TableHeader ], FullTableHeader ),
    make_header( [FullTableHeader] ),

    TX_S = [ "type [dep] to view departures", "type [back] to go back to main menu" ],
    make_subheader( TX_S ), nl,

    (
        is_file_empty( "arr" ) ->
            (
                make_header( ["no arrivals found"] ), nl
            );
            (
                make_table_arr_dep_top(),
                read_verses( "arr" ), nl
            )
    ),

    read( Input ),
    (
        (
            Input == 'back'
        );
        (
            Input == 'dep',
            show_table_dep( TableHeader )
        );
        show_table_arr( TableHeader )
    ).

show_table_dep( TableHeader ) :-

    tty_clear(), nl,

    table_concat( [ "departures from ", TableHeader ], FullTableHeader ),
    make_header( [FullTableHeader] ),

    TX_S = [ "type [arr] to view arrivals", "type [back] to go back to main menu" ],
    make_subheader( TX_S ), nl,

    (
        is_file_empty( "dep" ) ->
            (
                make_header( ["no departures found"] ), nl
            );
            (
                make_table_arr_dep_top(),
                read_verses( "dep" ), nl
            )
    ),

    read( Input ),
    (
        (
            Input == 'back'
        );
        (
            Input == 'arr',
            show_table_arr( TableHeader )
        );
        show_table_dep( TableHeader )
    ).

read_verses( Database ) :-
    database_atom( Database, DatabaseRef ),
    see( DatabaseRef ),
    read_verse(), % reading recursion here
    seen.

read_verse() :-
    read( L ),
    (
        L = end_of_file ->
            (
                !,
                make_table_arr_dep_bottom()
            );
            (
                sub_string( L, 3, 1, _, LStart ),
                ( not( LStart = " " ) -> make_table_arr_dep_middle(); ! ),
                write( L ), nl, read_verse()
            )
    ).


%
%   stop string block
%

make_stop_str_block( "dep", [LastStop|[]], StopStrBlock ) :- !,
    string_concat( "to ", LastStop, StopStr ),
    StopStrBlock = [ StopStr ].

make_stop_str_block( "arr", [LastStop|[]], StopStrBlock ) :- !,
    string_concat( "from ", LastStop, StopStr ),
    StopStrBlock = [ StopStr ].

make_stop_str_block( Type, [CSH|CityStopTail], StopStrBlock ) :-
    make_stop_str_block_inner( Type, CityStopTail, OldStopStrBlock ),
    add_to_str_block( OldStopStrBlock, CSH, StopStrBlock ).

make_stop_str_block_inner( "arr", [LastStop|[]], StopStrBlock ) :- !,
    table_concat( [ "from ", LastStop, " thru " ], StopStr ),
    StopStrBlock = [ StopStr ].

make_stop_str_block_inner( "dep", [LastStop|[]], StopStrBlock ) :- !,
    table_concat( [ "to ", LastStop, " thru " ], StopStr ),
    StopStrBlock = [ StopStr ].

make_stop_str_block_inner( Type, [CSH|CityStopTail], StopStrBlock ) :-
    make_stop_str_block_inner( Type, CityStopTail, OldStopStrBlock ),
    table_concat( [CSH, ", " ], StopStr ),
    add_to_str_block( OldStopStrBlock, StopStr, StopStrBlock ).

add_to_str_block( [BIH|BlockInTail], El, BlockOut ) :-

    atom_length( BIH, HeadLength ),
    atom_length( El, ElLength ),
    Length is HeadLength + ElLength,

    (
        Length >= 35 ->
            (
                BlockOut = [El|[BIH|BlockInTail]]
            );
            (
                string_concat( BIH, El, BIHEl ),
                BlockOut = [BIHEl|BlockInTail]
            )
    ).


%
%   verse to file
%

write_verse_to_file( Database, RouteId, Time, [SSH|StopStrTail] ) :-

    write_verse_to_file( Database, RouteId, Time, StopStrTail ),

    pad_with_spaces( " ", 10, TenSpaces ),
    pad_with_spaces( SSH, 35, SSHPadded ),

    table_concat( [ "\" │ ", TenSpaces, " │ ", TenSpaces, " │ ", SSHPadded, " │ \"" ], TableVerse ),
    database_add( Database, TableVerse ).

write_verse_to_file( Database, RouteId, Time, [SSH|[]] ) :- !,

    pad_with_spaces( RouteId, 10, RouteIdPadded ),
    pad_with_spaces( SSH, 35, SSHPadded ),
    printable_date( Time, TimeStr ),
    pad_with_spaces( TimeStr, 10, TimeStrPadded ),

    table_concat( [ "\" │ ", RouteIdPadded, " │ ", TimeStrPadded, " │ ", SSHPadded, " │ \"" ], TableVerse ),
    database_add( Database, TableVerse ).
