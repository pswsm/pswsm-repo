#include <iostream>

using namespace std;

float suma(float a, float b) {
  float r; r = a + b; return r;
}

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
      case '+':
      // res = suma(n1, n2);
      cout << suma(n1, n2) << endl;
      break;
      case '-':
      cout << n1 << "-" << n2 << '=' << n1 - n2 << '\n';
      // res = n1 - n2;
      break;
      case '*':
      cout << n1 << "*" << n2 << '=' << n1 * n2 << '\n';
      // res = n1 * n2;
      break;
      case '/':
      cout << n1 << "/" << n2 << '=' << n1 / n2 << '\n';
      // res = n1 / n2;
      break;
      default:
      cout << "Bad Operator: " << op << " not found!\n";
      // kLoop = false;
      break;
    }
    cout << "Vols fer una altra operació?[y/n]" << '\n';
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
