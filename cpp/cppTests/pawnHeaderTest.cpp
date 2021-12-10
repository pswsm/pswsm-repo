#include <iostream>
#include "./pawns.h"

int main() {
  Pawn p {20, 232, "Pau", "Figueras", "pswsm", true};

  for (std::string n : p.getEverything()) {
    std::cout << "Data: " << n << endl;
  }
}
