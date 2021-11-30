#include <iostream>
#include <vector>

int main() {
  std::vector<std::string> v = {"pau", "ady", "comprensible"};
  std::cout << "v = { ";
  for (std::string n : v) {
    std::cout << n << ", ";
  }
  std::cout << "}";
}
