
stop( X ) :-
    town( X );
    city( X ).

%   cities
city( "Centerile" ).
city( "Bluetrich" ).
city( "Rotteburg" ).
city( "Derlone" ).
city( "Persneo" ).
city( "Harloe" ).
city( "Hernez Amteo" ).

%   connecting towns
town( "Kuhlu" ).
town( "Purslu" ).

%   Centerile suburbs
town( "Selkou" ).
town( "Lower Resne" ).
town( "Resne" ).
town( "Burdu" ).
town( "Kuleo" ).

%   Bluetrich valley
town( "Secile" ).
town( "Nurnun" ).
town( "Parlou" ).
town( "Vurku" ).
town( "West Bluetrich" ).

%   Rotteburg - Derlone agglomeration
town( "Tulsso Dull" ).
town( "Semko" ).
town( "Pulku" ).

%   Persneo branchette
town( "Garlich" ).
town( "Parcedonia" ).

%   Harloe - Hernez Amteo peninsula
town( "Fersen" ).
town( "Jelta" ).
town( "Truske" ).
