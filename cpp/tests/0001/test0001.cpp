#include <iostream>
#include <string>
#include <cmath>

int main() {
  std::string test = "Test String";
  std::cout << test << '\n';
  std::string getlineTest;
  getline (std::cin, getlineTest);

  // Jugant amb un switch
  switch (getlineTest.length()) {
    case 3:
      std::cout << "Small text, right?" << '\n';
      break;
    case 8:
      std::cout << "Now this is something!" << '\n';
      break;
    default:
      std::cout << "Pretty average, don't you think?" << '\n\n\n';
  }

  // Jugant amb un for i un continue, mai havia tingut la oportunitat
  for (size_t i = 0; i <= 15; i++) {
    if ((i % 2) == 0) {
      continue;
    }
    std::cout << i << '\n';
  }
  return 0;
}
