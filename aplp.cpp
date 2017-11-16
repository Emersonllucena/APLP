#include <iostream>
#include <stdio.h>
#include <unistd.h>
#include <cstdlib>
#include <locale.h>
#include <map>
#include <vector>
#include <assert.h>

using namespace std;

const int DEFAULT_SLEEP = 1;

map<string, string> message;
map<string, int> attributes;
map<string, vector<string> > choices, choice_message, collaterals;

void read_input_file() {
    freopen("decisions", "r", stdin);
    while(1) {
        string state, msg, dec_state, dec_msg, collateral;
        int n_decisions, n_collat;

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
    cout << " (?) Informe a sua escolha: ";
    cin >> choice;
    cin.ignore();
    std::system("clear");
    cout << endl;
    return choice;
}

void tutorial() {
    cout << "------------------------------------------------------------\n";
    cout << "| Aqui vai um tutorial bem simples pra voc� se habituar com |\n";
    cout << "| o estilo do jogo                                          |\n";
    cout << "------------------------------------------------------------\n\n";

    cout << " (!) � anivers�rio da sua m�e e voc� gostaria de dar um \n";
    cout << "animal de estima��o para ela.\n\n";
    cout << " - Qual animal de estima��o voc� ir� escolher?\n\n";
    cout << " 1 - C�o\n";
    cout << " 2 - Gato\n\n";

    int choice = read_key();

    if (choice == 1) {
        cout << "\n (!) Voc� entrega o c�ozinho para sua m�e e ela adora seu presente\n\n";
        press_key();
    } else if (choice == 2) {
        cout << "\n (!) Nossa, como voc� p�de esquecer que sua m�e � al�rgica � gatos?\n\n";
        press_key();
    } else {
        cout << " (!) Escolha inv�lida\n";
        press_key();
        tutorial();
    }
}

void play_state(string state) {
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
        cout << "O que voc� ir� fazer?\n\n";
        for(int i = 0; i < (int) choices[state].size(); i++) {
            cout << (i+1) << " - " << choice_message[state][i] << endl;
        }

        int choice = read_key() - 1;
        if(choice >= (int) choices[state].size()) {
            cout << " (!) Escolha inv�lida\n";
            press_key();
            play_state(state);
        } else {
            play_state(choices[state][choice]);
        }
    }
}

void play_menu() {
    cout << "----------------------------------------------------------\n";
    cout << "| Como jogar?                                             |\n";
    cout << "----------------------------------------------------------\n";
    cout << "| - Voc� se deparar� com situa��es onde dever� fazer      |\n";
    cout << "| algumas escolhas para poder prosseguir. Repare que suas |\n";
    cout << "| escolhas podem impactar no rumo da sua vida, portanto,  |\n";
    cout << "| fa�a as escolhas da maneira que voc� julgar melhor.     |\n";
    cout << "----------------------------------------------------------\n\n";

    press_key();
    tutorial();

    cout << "               -----------------------------------------------\n";
    cout << "              | ~~~~~~~~~~~~~~~ Hora do show! ~~~~~~~~~~~~~~~ |\n";
    cout << "               -----------------------------------------------\n\n";

    press_key();

    string character_name;
    cout << " (?) Informe o seu nome: ";
    cin >> character_name;
    cin.ignore();

    std::system("clear");

    cout << "Ol�, " << character_name << ". Ap�s algumas semanas como um bom \n";
    cout << "fera do curso de Ci�ncia da Computa��o da UFCG, voc� j� passou por \n";
    cout << "algumas situa��es bem t�picas de um estudante universit�rio. No entanto, \n";
    cout << "como todos sabem, a vida � uma caixinha de surpresas e sempre nos reserva \n";
    cout << "situa��es bobas e inusitadas. Bom, vamos deixar de conversa fiada.\n";
    cout << "Pronto para come�ar?\n";

    press_key();
    play_state("2");
}

void credits_menu() {
    cout << " -----------------------------------------\n";
    cout << "| Universidade Federal de Campina Grande  |\n";
    cout << "| Departamento de Sistemas e Computa��o   |\n";
    cout << " -----------------------------------------\n";
    cout << "| Paradigmas de Linguagens de Programa��o |\n";
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
    cout << "| 2 - Cr�ditos                  |\n";
    cout << "| 3 - Sair                      |\n";
    cout << " ------------------------------- \n\n";

    int option;
    cout << " (?) Informe a op��o desejada: ";
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
        cout << " (!) Op��o Inv�lida\n";
        //sleep(DEFAULT_SLEEP);
        std::system("clear");
        main_menu();
    }
}

int main() {
    setlocale(LC_ALL, "");
    read_input_file();

    cout << "\n\n"; play_state("2"); /// Apenas para testar mais rapido

    main_menu();
    return 0;
}
