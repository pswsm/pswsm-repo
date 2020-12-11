#include <iostream>

int main() {
  /* code */
  float n1, n2, res;
  char op;

  std::cout << "Number" << '\n';
  std::cin >> n1;
  std::cout << "\nOperator" << '\n';
  std::cin >> op;
  std::cout << "\nNumber" << '\n';
  std::cin >> n2;
  std::cout << "Operation" << '\n' << n1 << op << n2 << "\n";

  switch (op) {
    case '+':
      std::cout << n1 << "+" << n2 << '=' << n1 + n2 << '\n';
    case '-':
      std::cout << n1 << "-" << n2 << '=' << n1 - n2<< '\n';
    case '*':
      std::cout << n1 << "*" << n2 << '=' << n1 * n2 << '\n';
    case '/':
      std::cout << n1 << "/" << n2 << '=' << n1 / n2<< '\n';
  }

  return 0;
}
