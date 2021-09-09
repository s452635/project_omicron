
:- module(
    text_functions,
    [
        write_list/1, write_block/1,
        capitalise/2, pad_with_spaces/3,
        make_block/1, make_reason/1, make_header/1, make_subheader/1, make_header_q/1,
        ask_question/2
    ]
).

:- use_module( text_messages, [make_frame_upper/0, make_frame_lower/0] ).


%
%   pure output
%

write_list( [] ) :- nl.
write_list( [H|Tail] ) :- write( H ), write_list( Tail ).

write_block( [] ).
write_block( [H|Tail] ) :- write( H ), nl, write_block( Tail ).


%
%   basic
%

capitalise( String, CapitalisedString ) :-

    sub_string( String, 0, 1, _, FirstLetter ),
    string_upper( FirstLetter, FirstLetterUpper ),

    string_length( String, FullLength ),
    TailLength is FullLength - 1,
    sub_string( String, 1, TailLength, _, TailLetters ),

    string_concat( FirstLetterUpper, TailLetters, CapitalisedString ).

pad_with_spaces( String, DesiredLength, PaddedString ) :-
    string_length( String, StringLength ),
    (
        StringLength >= DesiredLength ->
            ( PaddedString = String, ! );
            (
                concat( String, " ", StringSpace ),
                pad_with_spaces( StringSpace, DesiredLength, PaddedString )
            )
    ).


%
%   make
%

make_block( [] ).
make_block( [H|Tail] ) :- write("   "), write( H ), nl, make_block( Tail ).

make_reason( Reason ) :-
    write_list( ["   <<< ", Reason, " >>>"] ).

make_header( TextList ) :-
    make_frame_upper(),
    inner_make_header( TextList ).

make_subheader( TextList ) :-
    inner_make_header( TextList ).

inner_make_header( [TLH|[]] ) :-
    pad_with_spaces( TLH, 61, PaddedTLH ),
    write_list( [" │ ", PaddedTLH, " │ "] ),
    make_frame_lower(), !.

inner_make_header( [TLH|TextListTail] ) :-
    pad_with_spaces( TLH, 61, PaddedTLH ),
    write_list( [" │ ", PaddedTLH, " │ "] ),
    inner_make_header( TextListTail ).

make_header_q( Text ) :-
    pad_with_spaces( Text, 45, PaddedText ),
    write( " ┌───────────────┬───────────────────────────────────────────────┐" ), nl,
    write_list( [ " │ Questionnaire │ ",  PaddedText, " │ " ] ),
    write( " └───────────────┴───────────────────────────────────────────────┘" ), nl.


%
%   more complicated
%

ask_question( Question, Answer ) :-
    nl, make_block( Question ), nl,
    read( Answer ).
