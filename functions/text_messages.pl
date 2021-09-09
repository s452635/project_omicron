
:- module(
    text_messages,
    [
        make_logo/0, make_main_menu/0,
        make_frame_upper/0, make_frame_lower/0, make_table_arr_dep_top/0, make_table_arr_dep_middle/0, make_table_arr_dep_bottom/0,
        make_header_goodbye/0, make_subheader_questions/0,
        make_reason_wrong/0
    ]
).

:- use_module( text_functions, [write_block/1, make_header/1, make_subheader/1, make_reason/1] ).


%
%   main
%

make_logo() :-
    write_block([
        " WELCOME TO   /‾‾‾‾\\  |‾\\  /‾| |‾|  /‾‾‾| |‾‾‾‾\\  /‾‾‾‾\\  |‾ \\ |‾|",
        "             / /‾‾\\ \\ |  \\/  | | | / /‾‾  |    / / /‾‾\\ \\ | \\ \\| |",
        "    RAILWAY  \\ \\__/ / | |\\/| | | | \\ \\__  | |\\ \\ \\ \\__/ / | |\\ \\ |",
        "     SYSTEM   \\____/  |_|  |_| |_|  \\___| |_| \\_\\ \\____/  |_| \\ _|"
    ]).

make_main_menu() :-
    write_block([
        " ┌───────────────────────────────────────────────────────────────┐",
        " │ What can we help you with today?                              │",
        " ├────┬──────────────────────────────────────────────────────────┤",
        " │ 1. │ Check Arrivals and Departures.                           │",
        " │ 2. │ Find a Connection.                                       │",
        " │ 3. │ That's all. Bye.                                         │",
        " └────┴──────────────────────────────────────────────────────────┘"
    ]).

make_frame_upper() :-
    write( " ┌───────────────────────────────────────────────────────────────┐" ), nl.

make_frame_lower() :-
    write( " └───────────────────────────────────────────────────────────────┘" ), nl.

make_table_arr_dep_top() :-
    write_block([
        " ┌────────────┬────────────┬─────────────────────────────────────┐",
        " │ ROUTE ID   │ TIME       │ STOPS                               │"
    ]).

make_table_arr_dep_middle() :-
    write( " ├────────────┼────────────┼─────────────────────────────────────┤" ), nl.

make_table_arr_dep_bottom() :-
    write( " └────────────┴────────────┴─────────────────────────────────────┘" ), nl.


%
%   headers
%

make_header_goodbye() :-
    X = [ "Goodbye. We hope to see you again." ],
    make_header( X ).

make_subheader_questions() :-
    X = [ "I need to ask you few questions. Please, use only lowercase",
          "letters and make sure to finish your answers with a dot." ],
    make_subheader( X ).


%
%   reasons
%

make_reason_wrong() :-
    make_reason( "answer incorrect or misspelled" ).
