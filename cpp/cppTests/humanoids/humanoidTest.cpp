#include <iostream>
#include <vector>
#include <cxxopts.hpp>
#include "/home/pswsm/github/pswsm-repo/cpp/cppTests/humanoids/baseHumanoid.hpp"

void printHumanData(human::Human humanToPrint) {
  std::string humanValues[8] = {"First Name", "Last Name", "Nick Name", "Natural Age", "Biological Age", "Sex", "Blood", "Currently"};
  for (int j = 0; std::string n : humanToPrint.getEverything()) {
    std::cout << humanValues[j] << ":\t" << n << std::endl;
    j++;
  };
}

int main(int argc, char ** argv) {
  cxxopts::Options options("Human Generator v0.1", "Generates humans and prints them as of now.");
  options.add_options()
    ("n,number", "Number of humans", cxxopts::value<int>()->default_value("100"))
    ;
  auto args = options.parse(argc, argv);

  std::vector<std::string> possibleNames = {"Denys", "Pau", "Victor", "Gabriel", "Manin", "Basado", "Nose", "Fernando", "Men", "Jordi", "Toni", "JUJA", "Xavi"};
  std::vector<std::string> possibleBlood = {"aa", "ao", "oo", "ab", "bb", "bo", "cc"};
  std::vector<human::Human> humanPtrs;
  humanPtrs.reserve(25);

  for (int i = 0; i < args["number"].as<int>(); i++) {
    humanPtrs.push_back(*new human::Human {i, i, human::selectName(possibleNames), std::to_string(i), std::to_string(i), human::selectBloodGenotype(possibleBlood), 1, 'y'});
  };

  for (human::Human human : humanPtrs) {
    printHumanData(human);
    std::cout <<std::endl;
  };
}

