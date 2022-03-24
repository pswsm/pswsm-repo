#include <iostream>
#include <vector>
#include <string>
#include  "/home/pswsm/github/pswsm-repo/cpp/cppTests/humanoids/baseHumanoid.hpp"

void printHumanData(human::Human humanToPrint) {
  std::string humanValues[8] = {"First Name", "Last Name", "Nick Name", "Natural Age", "Biological Age", "Sex", "Blood", "Currently"};
  for (int j = 0; std::string n : humanToPrint.getEverything()) {
    std::cout << humanValues[j] << ":\t" << n << std::endl;
    j++;
  };
}

int main() {
  std::vector<std::string> names = {"Pau", "Manel", "Joan", "Gabriel", "Arnau", "Pablo", "Pol", "Josep", "Ramon", "Xavi", "Marc", "Aleix"};
  std::vector<std::string> bloodGroups = {"aa", "ao", "ab", "oo", "bo", "bb"};

  std::vector<human::Human> humanPtrs;

  for (int i = 0; i > 100; i++) {
    humanPtrs.push_back (*new human::Human {i, i, human::selectName(names), std::to_string(i), std::to_string(i), human::selectBloodGenotype(bloodGroups), 1, 'y'});
  };

  for (human::Human a : humanPtrs) {
    printHumanData(a);
    std::cout << std::endl;
  };
}
