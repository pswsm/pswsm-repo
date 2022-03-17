#include <iostream>
#include <memory>
#include <vector>
#include "/home/pswsm/github/pswsm-repo/cpp/cppTests/humanoids/baseHumanoid.hpp"

// void showAllInfo(Pawn humanoid) {
  // std::cout << "Humanoid full name: " << humanoid.getName() << "\nHumanoid biological age: " << humanoid.getBioAge()
            // << "\nHumanoid natural age: " << humanoid.getNatAge() << "\nHumanoid is alive: " << humanoid.getAlive();
// }
//
int main() {
  std::vector<Human> humanPtrs;
  std::string humanValues[7] = {"Natural Age", "Biological Age", "First Name", "Last Name", "Nick Name", "Sex", "Currently"};

  for (int i = 0; i < 5; i++) {
    humanPtrs.push_back(*new Human {i, i, std::to_string(i), std::to_string(i), std::to_string(i), 1, 'x'});
  };

  for (int i = 1; Human a : humanPtrs) {
    std::cout << "Human " << i << "\n";
    for (int j = 0; std::string n : a.getEverything()) {
      std::cout << humanValues[j] << ": " << n << std::endl;
      j++;
    }
    std::cout << std::endl;
    i++;
  }


}

// int main() {
//   std::make_unique(new Human(18, 18, "Pau", "", "pswsm", true));
// }
