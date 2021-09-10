
:- module(
    data_functions,
    [
        database_atom/2, database_clean/1, database_add/2,
        is_file_empty/1
    ]
).

:- use_module( basic_functions, [table_concat/2] ).


database_atom( Database, DatabaseRef ) :-
    table_concat( ["data/dynamic_", Database, ".txt"], DatabaseRefStr ),
    atom_string( DatabaseRef, DatabaseRefStr ).

database_clean( Database ) :-
    database_atom( Database, DatabaseRef ),
    tell( DatabaseRef ),
    told.

database_add( Database, Data ) :-
    database_atom( Database, DatabaseRef ),
    append( DatabaseRef ),
    write( Data ),
    write( "." ),
    write( "\n" ),
    told.

is_file_empty( Database ) :-
    database_atom( Database, DatabaseRef ),
    see( DatabaseRef ),
    read( L ),
    seen,
    L = end_of_file.
