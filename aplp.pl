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

/* Predicado para retornar primeira palavra da linha X (tudo em ASCII) */
naLinhaPrimeiraPalavra(X, L, Arq) :-
	naLinha(X, Linha, Arq),
	primeiraPalavra(L, Linha).

primeiraPalavra([], []).
primeiraPalavra([], [32 | _]).
primeiraPalavra([H | T], [H | R]) :- primeiraPalavra(T, R).


/* Predicado para imprimir a linha X como string */
imprimeLinha(L) :-
	string_codes(S, L),
	write(S), nl.

/* Procura a linha X do estado S*/
procuraEstado(1, 1, "tutorial", _).

procuraEstado(X, X1, S, [ L1, L2 | _ ]) :-
	X = X1 + 1,
	string_codes("", L1),
	string_codes(S, L2).

procuraEstado(X, Y, S, [ _ | C ]) :-
	Y1 is Y + 1,
	procuraEstado(X, Y1, S, C).

limpaTela :-
	nl, nl, nl, nl, nl, nl, nl, nl, nl, nl, nl, nl, nl, nl, nl, nl, nl, nl, nl, nl.

/* Imprime a mensagem do estado S */
imprimeEstado(X, S, Arq) :-
	procuraEstado(X, 1, S, Arq),
	X1 is X + 1,
	naLinha(X1, L, Arq),
	limpaTela,
	imprimeLinha(L).

/* Le quantas opcoes o usuario possui no estado da linha X */
quantasOpcoes(X, Op, Arq) :-
	X2 is X + 2,
	naLinha(X2, C, Arq),
	number_codes(Op, C).

proximoEstado(S, X, Arq) :-
	naLinhaPrimeiraPalavra(X, P, Arq),
	string_codes(S, P).

leOpcoes(X, 2, Arq) :-
	X1 is X + 3,
	write("1 - "), naLinhaCortaPalavra(X1, L1, Arq), imprimeLinha(L1),
	X2 is X + 4,
	write("2 - "), naLinhaCortaPalavra(X2, L2, Arq), imprimeLinha(L2), nl.

leOpcoes(X, 3, Arq) :-
	X1 is X + 3,
	write("1 - "), naLinhaCortaPalavra(X1, L1, Arq), imprimeLinha(L1),
	X2 is X + 4,
	write("2 - "), naLinhaCortaPalavra(X2, L2, Arq), imprimeLinha(L2),
	X3 is X + 5,
	write("3 - "), naLinhaCortaPalavra(X3, L3, Arq), imprimeLinha(L3), nl.

/* Predicado principal */

/* Uma opcao */
jogaEstado(S, Arq) :-
	procuraEstado(X, 1, S, Arq),
	quantasOpcoes(X, 1, Arq),
	imprimeEstado(X, S, Arq),
	nl, write("Digite qualquer tecla para continuar..."), nl,
	get_char(_),
	X3 is X + 3,
	proximoEstado(Prox, X3, Arq),
	jogaEstado(Prox, Arq).

/* Duas ou tres opcoes */
jogaEstado(S, Arq) :-	
	procuraEstado(X, 1, S, Arq),
	quantasOpcoes(X, Op, Arq),
	Op >= 2,
	Op =< 3,
	
	imprimeEstado(X, S, Arq),
	nl, write("O que deseja fazer?"), nl,
	
	leOpcoes(X, Op, Arq),
	
	get(Opt), get_char(_),
	
	NX is (X + 2 + Opt - 48),
	proximoEstado(Prox, NX, Arq),
	jogaEstado(Prox, Arq).

main:-
	prompt(_, ''),
	phrase_from_file(linhas(Arq), decisions),
	limpaTela,
	jogaEstado("tutorial", Arq),
	halt(0).