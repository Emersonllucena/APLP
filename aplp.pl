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

menor_igual(X, Y) :- X =< Y.
maior_que(X, Y) :- X > Y.

getKey(0, "sono").
getKey(1, "nota_calculo").
getKey(2, "nota_p1").
getKey(3, "dinheiro").
getKey(4, "amizade").
getKey(5, "amorzinho").
getKey(6, "professor_bravo").
getKey(7, "olavo").
getKey(8, "reagiu").
getKey(9, "prova_ic").
getKey(10, "terminou_p1").


inicializa(Att) :-
	Att = _{0:0, 1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0, 10:0}.

/* Atributo + */
updateAtt(X, Arq, Att, Att_) :-
	naLinhaPrimeiraPalavra(X, Arg, Arq),
	naLinhaCortaPalavra(X, [43], Arq),

	string_codes(L, Arg),
	getKey(Key, L),


	Quant is Att.get(Key) + 1,
	Att_ = Att.put(Key, Quant).

/* Atributo - */
updateAtt(X, Arq, Att, Att_) :-
	naLinhaPrimeiraPalavra(X, Arg, Arq),
	naLinhaCortaPalavra(X, [45], Arq),

	string_codes(L, Arg),
	getKey(Key, L),

	Quant is Att.get(Key) - 1,
	Att_ = Att.put(Key, Quant).

/* 0 efeitos colaterais */
novoAtt(X, Arq, Att, Att) :-
	naLinha(X, C, Arq),
	number_codes(0, C).

/* 1 efeito colateral */
novoAtt(X, Arq, Att, Att_) :-
	naLinha(X, C, Arq),
	number_codes(1, C),
	
	X1 is X + 1,
	updateAtt(X1, Arq, Att, Att_).

/* 2 efeitos colaterais */
novoAtt(X, Arq, Att, Att_) :-
	naLinha(X, C, Arq),
	number_codes(2, C),

	X1 is X + 1,
	updateAtt(X1, Arq, Att, Att1),

	X2 is X + 2,
	updateAtt(X2, Arq, Att1, Att_).

/* 3 efeitos colaterais */
novoAtt(X, Arq, Att, Att_) :-
	naLinha(X, C, Arq),
	number_codes(3, C),

	X1 is X + 1,
	updateAtt(X1, Arq, Att, Att1),

	X2 is X + 2,
	updateAtt(X2, Arq, Att1, Att2),

	X3 is X + 3,
	updateAtt(X3, Arq, Att2, Att_).


/* Predicado principal */

/* Uma opcao */
jogaEstado(S, Arq, Att) :-
	procuraEstado(X, 1, S, Arq),
	procuraEstado(END, 1, "END", Arq),
	X < END,

	quantasOpcoes(X, 1, Arq),
	
	imprimeEstado(X, S, Arq),
	nl, write("Digite qualquer tecla para continuar..."), nl,
	get_char(_),

	X4 is X + 4,

	novoAtt(X4, Arq, Att, Att_),

	X3 is X + 3,
	proximoEstado(Prox, X3, Arq),
	jogaEstado(Prox, Arq, Att_).

/* Duas ou tres opcoes */
jogaEstado(S, Arq, Att) :-	
	procuraEstado(X, 1, S, Arq),
	procuraEstado(END, 1, "END", Arq),
	X < END,

	quantasOpcoes(X, Op, Arq),
	Op >= 2,
	Op =< 3,
	
	imprimeEstado(X, S, Arq),
	nl, write("O que deseja fazer?"), nl,
	
	leOpcoes(X, Op, Arq),
	
	get(Opt), get_char(_),
	Opt_ is Opt - 48,
	
	jogaEstadoAposEscolherOpcao(S, X, Arq, Att, Op, Opt_).


/* Estado especial (condicional) */
jogaEstado(S, Arq, Att) :-
	procuraEstado(X, 1, S, Arq),
	procuraEstado(END, 1, "END", Arq),
	X > END,

	X1 is X + 1,
	naLinhaPrimeiraPalavra(X1, Arg, Arq),
	naLinhaCortaPalavra(X1, Q, Arq),

	number_codes(Quant, Q),

	string_codes(L, Arg),
	getKey(Key, L),
	RealQuant is Att.get(Key),

	jogaEstadoAposCondicional(X, Quant, RealQuant, Arq, Att).


jogaEstado("GAME_OVER", _, _).


/* Usuario digitou corretamente */
jogaEstadoAposEscolherOpcao(_, X, Arq, Att, Op, Opt) :-
	Opt >= 1,
	Opt =< Op,

	X_ is X + 3 + Op,
	novoAtt(X_, Arq, Att, Att_),

	NX is X + 2 + Opt,
	proximoEstado(Prox, NX, Arq),
	jogaEstado(Prox, Arq, Att_).

/* Usuario digitou entrada invalida - uma opcao diferente das apresentadas */
jogaEstadoAposEscolherOpcao(S, _, Arq, Att, Op, Opt) :-
	(Opt < 1; Opt > Op),
	jogaEstado(S, Arq, Att).

jogaEstadoAposCondicional(X, Quant, RealQuant, Arq, Att) :-
	RealQuant =< Quant,

	X2 is X + 2,
	proximoEstado(Prox, X2, Arq),
	jogaEstado(Prox, Arq, Att).


jogaEstadoAposCondicional(X, Quant, RealQuant, Arq, Att) :-
	RealQuant > Quant,

	X3 is X + 3,
	proximoEstado(Prox, X3, Arq),
	jogaEstado(Prox, Arq, Att).

menu :-
	nl, nl, nl,
    write(" -------------------------------- "), nl,
    write("|         Menu Principal         |"), nl,
    write(" -------------------------------- "), nl,
    write("| 1 - Jogar                      |"), nl,
    write("| 2 - Créditos                   |"), nl,
    write("| 3 - Sair                       |"), nl,
    write(" -------------------------------- "), nl,

    get(Opt), get_char(_),
	Opt_ is Opt - 48,

	menuOpcao(Opt_),
	menu.

menuOpcao(1) :-
	phrase_from_file(linhas(Arq), decisions),
	limpaTela,
	inicializa(Att),
	jogaEstado("tutorial", Arq, Att).

menuOpcao(2) :- creditos.
menuOpcao(3) :- sair.

menuOpcao(X) :-
	(X < 1; X > 3),
	menu.

creditos :-
	limpaTela,
	write( " ----------------------------------------- " ), nl,
    write( "| Universidade Federal de Campina Grande  |" ), nl,
    write( "| Departamento de Sistemas e Computação   |" ), nl,
    write( " ----------------------------------------- " ), nl,
    write( "| Paradigmas de Linguagens de Programação |" ), nl,
    write( " ----------------------------------------- " ), nl,
    write( "| Professor:                              |" ), nl,
    write( "| -- Everton Leandro                      |" ), nl,
    write( " ----------------------------------------- " ), nl,
    write( "| Time de Desenvolvimento:                |" ), nl,
    write( "| -- Daniel Mitre                         |" ), nl,
    write( "| -- Emerson Lucena                       |" ), nl,
    write( "| -- Gustavo Ribeiro                      |" ), nl,
    write( "| -- Rafael Guerra                        |" ), nl,
    write( "| -- Rerisson Matos                       |" ), nl,
    write( " ----------------------------------------- " ), nl.

sair :-
	nl, write("Obrigado por jogar!"), nl,
	halt.


main:-
	prompt(_, ''),
	menu,
	halt.