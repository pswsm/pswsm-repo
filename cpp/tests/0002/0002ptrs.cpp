#include "iostream"
#include "string"
#include "cmath"

int main() {
  std::string varU = "test", varDos = "test2", varTres = "test3";
  std::cout << "Les ubicacions en memòria de les següents variables" << '\n'
  << varU << "\t" << &varU << "\n"
  << varDos << "\t" << &varDos <<"\n"
  << varTres << "\t" << &varTres <<"\n";
  return 0;
}
