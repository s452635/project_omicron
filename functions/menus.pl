
:- module(
    menus,
    [ menu_main/0 ]
).

:- use_module( text_messages ).
:- use_module( text_functions ).
:- use_module( timeday ).
:- use_module( arr_dep ).


%
%   menus
%

menu_main() :-

    tty_clear(), nl,
    make_logo(), nl, make_main_menu(),
    nl, read(Input), nl,

    (
        (
            Input == 1,
            menu_arr_dep(),
            menu_main()
        );
        (
            Input == 2,
            menu_connections(),
            menu_main()
        );
        (
            Input == 3,
            menu_goodbye()
        );
        menu_main()
    ).

menu_goodbye() :-
    make_header_goodbye(), nl.

menu_arr_dep() :-

    % question strings
    QSTRBLK_STOP = [ "Which train stop?" ],
    QSTRBLK_WEEKDAY = [ "Which day of the week? (mon/tue/wed/thu/fri/sat/sun)" ],
    QSTRBLK_WHEN =
        [
            "Do you want:",
            "[a] all the arrivals and departures on that day,",
            "[b] just the ones in the next few hours."
        ],
    QSTRBLK_SPAN = [ "In next how many hours?" ],
    QSTRBLK_HOUR = [ "At what time? (hh:mm)" ],
    % question strings

    tty_clear(),
    nl, make_header_q( "Arrivals and Departures" ), make_subheader_questions(), nl,

    question_stop( QSTRBLK_STOP, Stop ),
    question_weekday( QSTRBLK_WEEKDAY, Weekday ),
    question_choice( QSTRBLK_WHEN, [a,b], When ),

    (
        (
            When == 'a',
            init_arr_dep( Stop, weekday(Weekday) )
        );
        (
            When == 'b',
            question_hour( QSTRBLK_HOUR, date( _, Hour, Minute ) ),
            question_span( QSTRBLK_SPAN, Span ),
            init_arr_dep( Stop, date(Weekday,Hour,Minute), Span )
        )
    ).

menu_connections() :-

    % question strings
    QSTRBLK_START_STOP = [ "From where?" ],
    QSTRBLK_FINISH_STOP = [ "To where?" ],
    QSTRBLK_START_WEEKDAY = [ "What day of the week is it today? (mon/tue/wed/thu/fri/sat/sun)" ],
    QSTRBLK_START_TIME = [ "What time is it? (hh:mm)" ],
    QSTRBLK_ASK_BEFORE = [ "Do you need to arrive there before a certain time? (y/n)" ],
    QSTRBLK_FINISH_WEEKDAY = [ "At which day of the week? (mon/tue/wed/thu/fri/sat/sun)" ],
    QSTRBLK_FINISH_TIME = [ "At what time? (hh:mm)" ],
    QSTRBLK_ASK_CHANGES = [ "Do you mind train changes over 15 min? (y/n)" ],
    QSTRBLK_ASK_SORT =
        [
            "What is your sorting preference?",
            "[a] quickest,",
            "[b] least train changes,",
            "[c] soonest there."
        ],
    % question strings

    tty_clear(), nl,
    make_header_q( "Find a Connection" ), make_subheader_questions(), nl,

    % basic questions
    question_stop( QSTRBLK_START_STOP, StopStart ),
    question_stop( QSTRBLK_FINISH_STOP, StopFinish ),
    question_weekday( QSTRBLK_START_WEEKDAY, WeekdayStart ),
    question_hour( QSTRBLK_START_TIME, date(_,HourStart,MinuteStart) ),

    % arriving before
    question_choice( QSTRBLK_ASK_BEFORE, [y,n], ChoiceBefore ),
    (
        ChoiceBefore == 'y' ->
            (
                question_weekday( QSTRBLK_FINISH_WEEKDAY, WeekdayFinish ),
                question_hour( QSTRBLK_FINISH_TIME, date(_,HourFinish,MinuteFinish) )
            ); true
    ),

    % preferences
    question_choice( QSTRBLK_ASK_CHANGES, [y,n], ChoiceChanges ),
    question_choice( QSTRBLK_ASK_SORT, [a,b,c], ChoiceSort ),

    % calling
    (
        ChoiceBefore == 'y' ->
        find_path(
            StopStart, date(WeekdayStart,HourStart,MinuteStart),
            StopFinish, date(WeekdayFinish,HourFinish,MinuteFinish),
            ChoiceChanges, ChoiceSort
        );
        find_path(
            StopStart, date(WeekdayStart,HourStart,MinuteStart),
            StopFinish,
            ChoiceChanges, ChoiceSort
        )
    ).


%
%   question functions
%

question_stop( QuestionTextBlock, Stop ) :-
    ask_question( QuestionTextBlock, Answer ),
    capitalise( Answer, CapitalisedAnswer ),
    (
        stop( CapitalisedAnswer ) ->
            Stop = CapitalisedAnswer;
            (
                make_reason_wrong(),
                question_stop( QuestionTextBlock, Stop )
            )
    ).

question_weekday( QuestionTextBlock, Weekday ) :-
    ask_question( QuestionTextBlock, Answer ),
    (
        weekday( Answer ) ->
            Weekday = Answer;
            (
                make_reason_wrong(),
                question_weekday( QuestionTextBlock, Weekday )
            )
    ).

question_hour( QuestionTextBlock, Time ) :-
    ask_question( QuestionTextBlock, Answer ),
    (
        (
            format( atom( AtomAnswer ), "~w", Answer ),
            split_string( AtomAnswer, ":", "", [AtomHour|[AtomMinute|[]]] ),
            atom_number( AtomHour, Hour ),
            atom_number( AtomMinute, Minute ),
            Time = date( _, Hour, Minute ), !
        );
        (
            question_hour( QuestionTextBlock, Time ),
            make_reason_wrong()
        )
    ).

question_span( QuestionTextBlock, Span ) :-
    ask_question( QuestionTextBlock, Answer ),
    (
        (
            ( not( number( Answer ) ); Answer =< 0 ),
            make_reason( "not a range of time" ),
            question_span( QuestionTextBlock, Span )
        );
        (
            Answer >= 16,
            make_reason( "too big of a range of time" ),
            question_span( QuestionTextBlock, Span )
        );
        (
            Span = Answer
        )
    ).

question_choice( QuestionTextBlock, Options, Choice ) :-
    ask_question( QuestionTextBlock, Answer ),
    (
        member( Answer, Options ) ->
            Choice = Answer;
            question_choice( QuestionTextBlock, Options, Choice )
    ).


%
%   path stub
%

find_path(
    StopStart, date(WeekdayStart,HourStart,MinuteStart),
    StopFinish, date(WeekdayFinish,HourFinish,MinuteFinish),
    ChoiceChanges, ChoiceSort
) :-

    unfinished_notice().

find_path(
    StopStart, date(WeekdayStart,HourStart,MinuteStart),
    StopFinish,
    ChoiceChanges, ChoiceSort
) :-

    unfinished_notice().

unfinished_notice() :-

    tty_clear(), nl,
    make_header( ["This part of the program is unfinished."] ),
    make_subheader( ["type [back] to come back to main menu"] ),
    nl,

    read( Input ),
    (
        Input == back -> true;
            unfinished_notice()
    ).
