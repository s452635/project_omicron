
%
%   this file contains distances between cities;
%   facts itselves unused in the project, but information
%   they contain is valid - can be seen in 'data/dreslo_railway.pdf'
%   and was used to calculate travel times in 'data/links.pl'
%


line( X, Y, Len ) :-
    conn( Y, X, Len );
    conn( X, Y, Len ).

%   main lines
conn( 'Centerile', 'Persneo', 37 ).
conn( 'Persneo', 'Harloe', 42 ).
conn( 'Persneo', 'Kuhlu', 21 ).
conn( 'Kuhlu', 'Harloe', 21 ).
conn( 'Harloe', 'Hernez Amteo', 42 ).
conn( 'Centerile', 'Bluetrich', 41 ).
conn( 'Bluetrich', 'Rotteburg', 23 ).
conn( 'Rotteburg', 'Derlone', 16 ).
conn( 'Derlone', 'Persneo', 36 ).
conn( 'Rotteburg', 'Persneo', 28 ).
conn( 'Rotteburg', 'Purslu', 13 ).
conn( 'Purslu', 'Persneo', 15 ).

%   Centerile suburbs
conn( 'Selkou', 'Resne', 14 ).
conn( 'Lower Resne', 'Resne', 3 ).
conn( 'Resne', 'Centerile', 8 ).
conn( 'Burdu', 'Kuleo', 8 ).
conn( 'Kuleo', 'Centerile', 6 ).

%   Bluetrich valley
conn( 'Secile', 'Nurnun', 6 ).
conn( 'Vurku', 'West Bluetrich', 22 ).
conn( 'Nurnun', 'West Bluetrich', 27 ).
conn( 'Nurnun', 'Parlou', 6 ).
conn( 'Parlou', 'Bluetrich', 10 ).
conn( 'West Bluetrich', 'Bluetrich', 5 ).

%   Rotteburg - Derlone agglomeration
conn( 'Tulsso Dull', 'Rotteburg', 11 ).
conn( 'Tulsso Dull', 'Derlone', 9 ).
conn( 'Semko', 'Tulsso Dull', 5 ).
conn( 'Pulku', 'Derlone', 6 ).
conn( 'Pulku', 'Semko', 5 ).

%   Persneo branchette
conn( 'Garlich', 'Parcedonia', 7 ).
conn( 'Parcedonia', 'Persneo', 15 ).

%   Harloe - Hernez Amteo peninsula
conn( 'Fersen', 'Harloe', 11 ).
conn( 'Jelta', 'Fersen', 12 ).
conn( 'Truske', 'Jelta', 7 ).
conn( 'Truske', 'Hernez Amteo' ).
