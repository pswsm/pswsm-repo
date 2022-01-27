#ifndef H_HUMAN
#define H_HUMAN

#include <string>
#include <vector>
#include <ctime>
#include <cstdlib>
#include <memory>

class Human {
  int natAge, bioAge;
  std::string firstName, lastName, nickName;
  bool state;

  public:
    Human(int naturalAge, int biologicalAge, std::string fName, std::string lName, std::string niName, bool alive): natAge{naturalAge}, bioAge{biologicalAge},
      firstName{fName}, lastName{lName}, nickName{niName}, state{alive}
    {};

    std::vector<std::string> getEverything() {
      std::vector<std::string> v = {};
      v.push_back(std::to_string(natAge));
      v.push_back(std::to_string(bioAge));
      v.push_back(firstName);
      v.push_back(nickName);
      v.push_back(lastName);
      if (state == true) {
        v.push_back("Alive");
      } else {
        v.push_back("Dead");
      }
      return v;
    }

    int getNatAge() {
      return natAge;
    }

    int getBioAge() {
      return bioAge;
    }

    std::string getName() {
      std::string fullName = firstName + "\"" + nickName + "\"" + lastName;
      return fullName;
    }

    std::string getAlive() {
      if (state == true) {
        return "Alive";
      } else {
        return "Deceased";
      }
    }
};

#endif
