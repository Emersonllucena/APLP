#include <iostream>
#include <stdio.h>
#include <unistd.h>
#include <cstdlib>
#include <locale.h>
#include <map>
#include <set>
#include <vector>
#include <assert.h>

using namespace std;
typedef string Attribute;
typedef string State;

map<State, string> message;
map<Attribute, int> attributes;
map<State, vector<string> > choices, choice_message, collaterals;

set<State> special, visited;
map<State, pair<Attribute, int> > special_condition;
map<State, pair<State, State> > special_next_state;


void read_input_file() {
    freopen("decisions", "r", stdin);

    string state, msg, dec_state, dec_msg, collateral;
	int n_decisions, n_collat, quant;

    while(1) {
        cin >> state;
        cin.ignore();

        if(state == "END") break;

        getline(cin, msg);
        message[state] = msg;


        cin >> n_decisions;
        cin.ignore();

        for(int i = 0; i < n_decisions; i++) {
            cin >> dec_state;
            cin.ignore();

            choices[state].push_back(dec_state);

            getline(cin, dec_msg);
            choice_message[state].push_back(dec_msg);
        }

        cin >> n_collat;
        cin.ignore();

        for(int i = 0; i < n_collat; i++) {
            getline(cin, collateral);
            collaterals[state].push_back(collateral);
        }
    }
    ///CONDITIONALS
    while(1) {
        cin >> state;
        cin.ignore();

        if(state == "END") break;

		special.insert(state);

		string attribute, state1, state2;

		cin >> attribute >> quant;
		special_condition[state] = pair<Attribute, int> (attribute, quant);

		cin >> state1 >> state2;
		special_next_state[state] = pair<State, State> (state1, state2);
    }

    freopen("/dev/tty", "r", stdin);
}

void press_key() {
    cout << " (!) Pressione alguma tecla para prosseguir... ";
    cin.ignore();
    std::system("clear");
    cout << endl;
}

int read_key() {
    int choice;
    cout << "\n (?) Informe a sua escolha: ";
    cin >> choice;
    cin.ignore();
    std::system("clear");
    cout << endl;
    return choice;
}

void end_game() {
	if(visited.count("33")) {
		cout << "Voce morreu porque tentou ser corajoso demais. Lembre-se: você e' apenas um estudante de computacao!\n";
	} else if(visited.count("59.7")) {
		cout << "Voce nao manteve habitos muito saudaveis. Eu sei, e' apenas um estudante! Mas se cuide na proxima\n";
	} else {
		int nota_calculo = 7 + attributes["nota_calculo"];
		cout << nota_calculo << "!!!\n";
		press_key();
		
		if(nota_calculo < 7) {
			cout << "Que droga. Voce foi mal na prova. Da proxima vez, estude mais, faca a prova descansado e nao coma nada estranho antes!\n";
			press_key();
			cout << "Voce vai precisar fazer prova final.\n";
		} else if(nota_calculo == 7) {
			cout << "7... Podia ser pior!\n";
			press_key();
			cout << "Podia ser melhor...\n";
		} else {
			cout << "O esforco valeu a pena! Voce fica orgulhoso da nota. A maior da turma!\n";
		}
		press_key();
		
		cout << "Fim de periodo! O que voce conseguiu? Vamos ver:\n";
		press_key();
		
		cout << nota_calculo << " em calculo.\n";
		press_key();
		
		int nota_intr = 6;
		if(visited.count("39")) nota_intr = 8;
		cout << nota_intr << " em IC.\n";
		press_key();
		
		if(visited.count("46.1")) {
			cout << "Voce nao terminou a ultima unidade de P1\n";
		} else {	
			cout << "Voce conseguiu finalizar P1!!\n";
		}
		press_key();
		
		int amorzinho = attributes["amorzinho"], amizade = attributes["amizade"];
		
		if(amizade >= 2) {
			cout << "Voce foi um bom amigo durante o periodo e e' querido por todos da turma\n";
		} else {
			cout << "Voce saiu pouco com sua turma, e por isso, passou as ferias um pouco sozinho. Seja mais sociavel!\n";
		}
		press_key();
		
		if(amorzinho >= 3) {
			cout << "Nas proximas semanas, voce e seu amor ficam cada vez mais proximos. Tudo indica que vai dar namoro!\n";
		} else {
			cout << "Acaba o periodo e voce nao arranja uma namorada! Paciencia...\n";
		}
		press_key();
		
		cout << "Fim do jogo! Sera' que poderia ter ido melhor?\n";
		press_key();
	}
}

void play_state(string state) {
	visited.insert(state);
	if(state == "FIM") {
		end_game();
		return;
	}

	if(special.count(state)) {
		string attribute = special_condition[state].first;

		if(attributes[attribute] <= special_condition[state].second)
			play_state(special_next_state[state].first);
		else
			play_state(special_next_state[state].second);
		return;
	}

    cout << message[state] << "\n\n";

    for(string col : collaterals[state]) {
        string attr = col.substr(0, col.size() - 2);
        if(col.back() == '+') attributes[attr]++;
        else if(col.back() == '-') attributes[attr]--;
        else assert(false);
    }

    if(choices[state].size() == 1) {
        press_key();
        play_state(choices[state][0]);
    } else {
        cout << " O que voce escolhe fazer?\n\n";
        for(int i = 0; i < (int) choices[state].size(); i++) {
            cout << (i+1) << " - " << choice_message[state][i] << endl;
        }

        int choice = read_key() - 1;
        if(choice >= (int) choices[state].size()) {
            cout << " (!) Escolha invalida\n";
            press_key();
            play_state(state);
        } else {
            play_state(choices[state][choice]);
        }
    }
}

void tutorial() {
	play_state("tutorial");
}

void play_menu() {
    cout << "----------------------------------------------------------\n";
    cout << "| Como jogar?                                             |\n";
    cout << "----------------------------------------------------------\n";
    cout << "| - Voce se deparara' com situacoes onde devera' fazer      |\n";
    cout << "| algumas escolhas para poder prosseguir. Repare que suas |\n";
    cout << "| escolhas podem impactar no rumo da sua vida, portanto,  |\n";
    cout << "| faca as escolhas da maneira que voce julgar melhor.     |\n";
    cout << "----------------------------------------------------------\n\n";

    press_key();

    attributes.clear();
    visited.clear();

	play_state("tutorial");
    std::system("clear");
}

void credits_menu() {
    cout << " -----------------------------------------\n";
    cout << "| Universidade Federal de Campina Grande  |\n";
    cout << "| Departamento de Sistemas e Computação   |\n";
    cout << " -----------------------------------------\n";
    cout << "| Paradigmas de Linguagens de Programacao |\n";
    cout << " ----------------------------------------\n";
    cout << "| Professor:                              |\n";
    cout << "| -- Everton Leandro                      |\n";
    cout << " -----------------------------------------\n";
    cout << "| Time de Desenvolvimento:                |\n";
    cout << "| -- Daniel Mitre                         |\n";
    cout << "| -- Emerson Lucena                       |\n";
    cout << "| -- Gustavo Ribeiro                      |\n";
    cout << "| -- Rafael Guerra                        |\n";
    cout << "| -- Rerisson Matos                       |\n";
    cout << " -----------------------------------------\n";

    press_key();
}

void main_menu() {
    cout << " ------------------------------- \n";
    cout << "|         Menu Principal        |\n";
    cout << " ------------------------------- \n";
    cout << "| 1 - Jogar                     |\n";
    cout << "| 2 - Creditos                  |\n";
    cout << "| 3 - Sair                      |\n";
    cout << " ------------------------------- \n\n";

    int option;
    cout << " (?) Informe a opcao desejada: ";
    cin >> option;
    cin.ignore();
    std::system("clear");

    if (option == 1) {
        play_menu();
        main_menu();
    } else if (option == 2) {
        credits_menu();
        main_menu();
    } else if (option == 3) {
        cout << "Obrigado por jogar :D\n";
    } else {
        cout << " (!) Opçao Invalida\n";
        std::system("clear");
        main_menu();
    }
}

int main() {
    setlocale(LC_ALL, "Portuguese");
    read_input_file();

    //cout << "\n\n"; play_state("62"); /// Apenas para testar mais rapido

    main_menu();
    return 0;
}
