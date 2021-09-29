#include <iostream>

using namespace std;

float suma(float a, float b) { float r = a + b; return r; }

float resta(float a, float b) { float r = a - b; return r; }

float times(float a, float b) { float r = a * b; return r; }

float divid(float a, float b) { float r = a / b; return r; }

int main() {
  // Variables
  float n1, n2, res; char op, qC;
  system("clear");

  while (true) {
    cout << "Introdueixi operació:\n";
    cin >> n1 >> op >> n2;
    //El switch de la calculadora
    //Determina quina operació es farà segons l'operador (op)
    switch (op) {
      case '+': cout << suma(n1, n2) << endl;
      break;
      case '-': cout << resta(n1, n2) << endl;
      break;
      case '*': cout << times(n1, n2) << endl;
      break;
      case '/': cout << divid(n1, n2) << endl;
      break;
      default: cout << "Bad Operator: " << op << " not found!\n";
      break;
    }
    cout << "\nVols fer una altra operació?[y/n]" << '\n';
    cin >> qC;
    if (qC == 'n' || qC == 'N') {
      cout << endl;
      return 0;
    } else {
      system("clear");
      continue;
    }
  }
}
