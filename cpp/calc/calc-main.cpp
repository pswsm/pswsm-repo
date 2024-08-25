#include <functional>
#include <iostream>

float suma(float a, float b) { float r = a + b; return r; }

float resta(float a, float b) { float r = a - b; return r; }

float times(float a, float b) { float r = a * b; return r; }

float divid(float a, float b) { float r = a / b; return r; }

class App {};

enum Operand {
  SUM = '+',
  RES = '-',
  MUL = '*',
  DIV = '/'
};

class Calculator {
  private:
    Operand m_operand {};
    float m_rhs {};
    float m_lhs {};

  public:
    Calculator(Operand operand, float rhs, float lhs): m_operand(operand), m_lhs(lhs), m_rhs(rhs) {}

    
}

int main() {
  // Variables
  float n1, n2, res; char op, qC;
  system("clear");

  while (true) {
    std::cout << "Introdueixi operació:\n";
    std::cin >> n1 >> op >> n2;
    //El switch de la calculadora
    //Determina quina operació es farà segons l'operador (op)
    switch (op) {
      case '+': std::cout << suma(n1, n2) << std::endl;
      break;
      case '-': std::cout << resta(n1, n2) << std::endl;
      break;
      case '*': std::cout << times(n1, n2) << std::endl;
      break;
      case '/': std::cout << divid(n1, n2) << std::endl;
      break;
      default: std::cout << "Bad Operator: " << op << " not found!\n";
      break;
    }
    std::cout << "\nVols fer una altra operació?[y/n]\n";
    std::cin >> qC;
    if (qC == 'n' || qC == 'N') {
      std::cout << std::endl;
      return 0;
    } else {
      system("clear");
      continue;
    }
  }
}
