#include <iostream>

int main() {
  // Variables
  float n1, n2, res;
  char op;

  //Lectura i escriptura
  std::cout << "Numbers (2)\n";
  std::cin >> n1 >> n2;
  std::cout << "Operació" << '\n';
  std::cin >> op;

  //El switch de la calculadora
  //Determina quina operació es farà segons l'operador (op)
  switch (op) {
    case '+':
      std::cout << n1 << "+" << n2 << '=' << n1 + n2 << '\n';
      res = n1 + n2;
      break;
    case '-':
      std::cout << n1 << "-" << n2 << '=' << n1 - n2 << '\n';
      res = n1 - n2;
      break;
    case '*':
      std::cout << n1 << "*" << n2 << '=' << n1 * n2 << '\n';
      res = n1 * n2;
      break;
    case '/':
      std::cout << n1 << "/" << n2 << '=' << n1 / n2 << '\n';
      res = n1 / n2;
      break;
    default:
      std::cout << "Bad Operator: " << op << " not found!\n";
      break;
  }

  return 0;
}
