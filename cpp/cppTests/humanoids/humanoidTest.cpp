#include <iostream>
#include <ostream>
#include <vector>
#include <cxxopts.hpp>
#include <string>
#include "./baseHumanoid.hpp"

cxxopts::ParseResult makeArguments( int argCount, char *argVector[]) {
  cxxopts::Options options("Human Generator v0.1", "Generates humans and prints them as of now.");
  options.add_options()
    ("n,number", "Number of humans", cxxopts::value<std::string>(), "Number");
  try {
      cxxopts::ParseResult args = options.parse(argCount, argVector);
  } catch (const cxxopts::OptionParseException &x) {
      std::cerr << "humanoids: " << x.what() << std::endl;
      std::cerr << "usage: humanoids <number>" << std::endl;
  }
  
  return args;
}

void printHumanData(human::Human humanToPrint) {
  std::string humanValues[8] = {"First Name", "Last Name", "Nick Name", "Natural Age", "Biological Age", "Sex", "Blood", "Currently"};
  for (int j = 0; std::string n : humanToPrint.getEverything()) {
    std::cout << humanValues[j] << ":\t" << n << std::endl;
    j++;
  };
}

int main(int argc, char *argv[]) {
  cxxopts::ParseResult args = makeArguments(argc, argv);

  std::vector<std::string> possibleNames = {"Denys", "Pau", "Victor", "Gabriel", "Manin", "Basado", "Nose", "Fernando", "Men", "Jordi", "Toni", "JUJA", "Xavi"};
  std::vector<std::string> possibleBlood = {"aa", "ao", "oo", "ab", "bb", "bo", "cc"};
  std::vector<human::Human> humanPtrs;
  humanPtrs.reserve(std::stoi(args["number"].as<std::string>()) * 1.5);

  for (int i = 0; i < std::stoi(args["number"].as<std::string>()); i++) {
    humanPtrs.push_back(*new human::Human {i, i, human::selectName(possibleNames), std::to_string(i), std::to_string(i), human::selectBloodGenotype(possibleBlood), 1, 'y'});
  };

  for (human::Human human : humanPtrs) {
    printHumanData(human);
    std::cout <<std::endl;
  };
}

