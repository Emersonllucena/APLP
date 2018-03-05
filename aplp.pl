:- initialization main.
:- use_module(library(pio)).

/* Gramatica para ler linhas do arquivo e guardar em uma lista */
linhas([]) 			--> call(eos), !.
linhas([L|Linhas])	--> linha(L), linhas(Linhas).

linha([])			--> ("\n" ; call(eos) ), !.
linha([L|Ls])		--> [L], linha(Ls).

eos([], []).


/* Predicado para retornar conteudo da linha X (tudo em ASCII) */
naLinha(1, L, [ L | _ ]).
naLinha(X, L, [ _ | C ]) :-
	X1 is X - 1,
	naLinha(X1, L, C).

/* Predicado para retornar conteudo da linha X apos a primeira palavra (tudo em ASCII) */
naLinhaCortaPalavra(X, L, Arq) :-
	naLinha(X, Linha, Arq),
	cortaPalavra(L, Linha).

cortaPalavra([], []).
cortaPalavra(L, [32 | L]).
cortaPalavra(L, [_ | T]) :- cortaPalavra(L, T).


/* Predicado para imprimir a linha X como string */
imprimeLinha(L) :-
	string_codes(S, L),
	write(S), nl.

main:-
	phrase_from_file(linhas(Arq), decisions),
	naLinhaCortaPalavra(10	, L, Arq),
	imprimeLinha(L),
	halt(0).