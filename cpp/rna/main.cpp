#include "./src/contexts/dna/domain/Dna.cpp"
#include <iostream>
#include <string>
int main() {
  std::string input;
  std::cin >> input;
  try {
    Dna* test_dna = new Dna(input);
    std::cout << test_dna->valueOf();
  } catch (DnaError& error) {
    std::cout << error.valueOf();
    return 1;
  }
  return 0;
}
