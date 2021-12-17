#include <iostream>
#include "/home/pswsm/github/pswsm-repo/cpp/cppTests/humanoids/baseHumanoid.hpp"

void showAllInfo(Pawn humanoid) {
  std::cout << "Humanoid full name: " << humanoid.getName() << "\nHumanoid biological age: " << humanoid.getBioAge()
            << "\nHumanoid natural age: " << humanoid.getNatAge() << "\nHumanoid is alive: " << humanoid.getAlive();
}

int main() {
  Pawn p {20, 232, "Pau", "Figueras", "pswsm", true};

  for (std::string n : p.getEverything()) {
    std::cout << "Data: " << n << std::endl;
  }

  showAllInfo(p);
}
