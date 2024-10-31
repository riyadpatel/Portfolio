/*
Extra Credit Item Three. AND Extra Credit Item(at the bottom)
What is the largest garden you can make with the flowers provided?

28 would be the maxium, as a given flower can only be used once in a row.
So you can arrage all flowers given to make a garden that fits the rules.
The example shown in the text file: 
gardencheck(28, [roses, orchid, azalea, iris, bird_of_paradise, 
petunias,begonias, daffodils, gladiolas, dahlia, zinnia, periwinkle, 
geranium, marigolds, carnation, buttercup, lavender, peonies, poppy, 
sunflower, gardenias,chrysanthemum, crocus, lilies, violet, tulip, 
daisies, snapdragons ]).
*/
flower(daisies, med, wet, yellow).
flower(roses, med, dry, red).
flower(petunias, med, wet, pink).
flower(daffodils, med, wet, yellow).
flower(begonias, tall, wet, white).
flower(snapdragons, tall, dry, red).
flower(marigolds, short, wet, yellow).
flower(gardenias, med, wet, red).
flower(gladiolas, tall, wet, red).
flower(bird_of_paradise, tall, wet, white).
flower(lilies, short, dry, white).
flower(azalea, med, dry, pink).
flower(buttercup, short, dry, yellow).
flower(poppy, med, dry, red).
flower(crocus, med, dry, orange).
flower(carnation, med, wet, white).
flower(tulip, short, wet, red).
flower(orchid, short, wet, white).
flower(chrysanthemum, tall, dry, pink).
flower(dahlia, med, wet, purple).
flower(geranium, short, dry, red).
flower(lavender, short, dry, purple).
flower(iris, tall, dry, purple).
flower(peonies, short, dry, pink).
flower(periwinkle, med, wet, purple).
flower(sunflower, tall, dry, yellow).
flower(violet, short, dry, purple).
flower(zinnia, short, wet, yellow).
/*
plantassign(N, List)
creates the lists for the plan while selecting a flower species for each
spot in the garden
*/
plantassign(N, List) :-
    N >= 4,
    N mod 2 =:= 0,
    helper(N, List).

helper(0, []).
helper(N, [Flower|Rest]) :-
    N > 0,
    N2 is N - 1,
    helper(N2, Rest),
    flower(Flower, _, _, _).
/*
uniquecheck(List)
check to make sure the assignment hasn't violated rules about duplicate
flowers
*/
uniquecheck(List) :-
    sort(List, Sorted),
    length(List, X),
    length(Sorted, X).
/*
colorcheck(List)
check to make sure color rules are kept
*/
colorcheck([]).
colorcheck([_]).
colorcheck([Flower1, Flower2|Rest]) :-
    flower(Flower1, _, _, Color1),
    flower(Flower2, _, _, Color2),
    dif(Color1, Color2),
    colorcheck([Flower2|Rest]).
/*
sizecheck(List)
5) No two adjacent plantings can have flowers whose size is more than one
size difference. Sizes are small, med, tall so small next to small is
fine, small next to medium is fine, but small next to tall is not.
*/

sizecheck([]).
sizecheck([_]).
sizecheck([Flower1, Flower2|Rest]) :-
    \+ size_difference(Flower1, Flower2),
    sizecheck([Flower2|Rest]).

size_difference(Flower1, Flower2) :-
    flower(Flower1, Size1, _, _),
    flower(Flower2, Size2, _, _),
    sizehelper(Size1, Size2).

sizehelper(short, tall).
sizehelper(tall, short).


/*
wetcheck(N, List)
first and last dry
middel two wet( interger division+1)
*/
wetcheck(N, List) :-
    nth1(1, List, First),
    nth1(N, List, Last),
    flower(First, _, dry, _),
    flower(Last, _, dry, _),
    B is N // 2,
    N1 is B + 1,
    nth1(B, List, Middle1),
    nth1(N1, List, Middle2),
    flower(Middle1, _, wet, _),
    flower(Middle2, _, wet, _).
/*
writegarden(List)
wwrite complete garden plan
*/
writegarden([]).
writegarden([Flower|Rest]) :-
    flower(Flower,Size, Feel,Color),
    nl,
    write("Flower: "),
    write(Flower), 
    write('\t'),
    write("Size: "),
    write(Size), 
    write('\t'),
    write("Feel: "),
    write(Feel), 
    write('\t'),
    write("Color: "),
    write(Color), 
    write('\t'),
    writegarden(Rest).
/*
gardenplan(N, List)
assign plants and check rules, then print the plan.
*/
gardenplan(N, List) :-
    plantassign(N, List),
    uniquecheck(List),
    colorcheck(List),
    sizecheck(List),
    wetcheck(N, List),
    writegarden(List).

/*
Extra Credit Item One.
gardencheck(N, List)
The list (plan) is already filled with flowers. Use existing check
routines to verify the plan is valid
*/

gardencheck(N, List):-
    uniquecheck(List),
    colorcheck(List),
    sizecheck(List),
    wetcheck(N, List).
