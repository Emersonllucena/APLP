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

set<State> special;
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

void play_state(string state) {
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
        cout << " O que você irá fazer?\n\n";
        for(int i = 0; i < (int) choices[state].size(); i++) {
            cout << (i+1) << " - " << choice_message[state][i] << endl;
        }

        int choice = read_key() - 1;
        if(choice >= (int) choices[state].size()) {
            cout << " (!) Escolha inválida\n";
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
    cout << "| - Você se deparará com situações onde deverá fazer      |\n";
    cout << "| algumas escolhas para poder prosseguir. Repare que suas |\n";
    cout << "| escolhas podem impactar no rumo da sua vida, portanto,  |\n";
    cout << "| faça as escolhas da maneira que você julgar melhor.     |\n";
    cout << "----------------------------------------------------------\n\n";

    press_key();
	play_state("tutorial");
    std::system("clear");
}

void credits_menu() {
    cout << " -----------------------------------------\n";
    cout << "| Universidade Federal de Campina Grande  |\n";
    cout << "| Departamento de Sistemas e Computação   |\n";
    cout << " -----------------------------------------\n";
    cout << "| Paradigmas de Linguagens de Programação |\n";
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
    cout << "| 2 - Créditos                  |\n";
    cout << "| 3 - Sair                      |\n";
    cout << " ------------------------------- \n\n";

    int option;
    cout << " (?) Informe a opção desejada: ";
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
        cout << " (!) Opção Inválida\n";
        std::system("clear");
        main_menu();
    }
}

int main() {
    setlocale(LC_ALL, "Portuguese");
    read_input_file();

    //cout << "\n\n"; play_state("2"); /// Apenas para testar mais rapido

    main_menu();
    return 0;
}
