#include <iostream>
#include <vector>
#include "/home/pswsm/github/pswsm-repo/cpp/cppTests/humanoids/baseHumanoid.hpp"

void printHumanData(human::Human humanToPrint) {
  std::string humanValues[7] = {"Natural Age", "Biological Age", "First Name", "Last Name", "Nick Name", "Sex", "Currently"};
  for (int j = 0; std::string n : humanToPrint.getEverything()) {
    std::cout << humanValues[j] << ": " << n << std::endl;
    j++;
  };
}

int main() {
  std::vector<std::string> possibleNames = {"Denys", "Pau", "Victor", "Gabriel", "Manin", "Basado", "Nose", "Fernando"};
  std::vector<human::Human> humanPtrs;
  humanPtrs.reserve(100);

  for (int i = 0; i < 100; i++) {
    humanPtrs.push_back(*new human::Human {i, i, human::selectName(possibleNames), std::to_string(i), std::to_string(i), 1, 'y'});
  };

  for (human::Human human : humanPtrs) {
    printHumanData(human);
  };
}

