#include <iostream>
#include <cstdlib>
#include <ctime>
#include <string>
#include <vector>

class Pawn {
  std::string name;
  int bioAge;
  int age;
  bool alive;

  public:
  std::string getName() {
    return name;
  }
  int getBioAge() {
    return bioAge;
  }
  int getAge() {
    return age;
  }
  bool getAlive() {
    return alive;
  }
  void setName(std::string newName) {
    name = newName;
  }
  void setAge(int newAge) {
    age = newAge;
  }
  void setBioAge(int newBioAge) {
    bioAge = newBioAge;
  }
  void setAlive(bool state) {
    alive = state;
  }
};

std::string genName(std::vector<std::string> names) {
  srand(time(nullptr));
  std::string name = names[rand() % names.size()];
  return name;
}

int main() {
  std::vector<std::string> namePool = {"pau", "gabi", "berta", "carla", "txell", "miguel", "adrià", "alba", "gerard", "toni", "manel", "guillem"};

  Pawn human;
  human.setName(genName(namePool));
  human.setAge(rand() % 50 + 18);
  human.setAlive(1);
  human.setBioAge(rand() % 1000 + human.getAge());

  std::cout << "This human is called " << human.getName() << "\n" << "He is " << human.getAge() <<
    " years old, although he is " << human.getBioAge() << " years old." << std::endl;
}
