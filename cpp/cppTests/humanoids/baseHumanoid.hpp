#ifndef H_HUMAN
#define H_HUMAN

#include <string>
#include <vector>
#include <ctime>

namespace human {
  class Human {
    int natAge, bioAge;
    std::string firstName, lastName, nickName;
    bool isAlive;
    char sex;

    public:
    Human(int naturalAge, int biologicalAge, std::string fName, std::string lName, std::string niName, bool alive, char sx): natAge{naturalAge}, bioAge{biologicalAge},
      firstName{fName}, lastName{lName}, nickName{niName}, isAlive{alive}, sex{sx}
    {};

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

    std::string getSex() {
      if (sex == 'x' || sex == 'X') {
        return "Female";
      } else if (sex == 'y' || sex == 'Y') {
        return "Male";
      } else {
        return "Unknown";
      }
    }

    std::string getAlive() {
      if (isAlive == true) {
        return "Alive";
      } else if (isAlive == false){
        return "Deceased";
      } else {
        return "Unknown";
      }
    }

    std::vector<std::string> getEverything() {
      std::vector<std::string> v = {};
      v.push_back(std::to_string(natAge));
      v.push_back(std::to_string(bioAge));
      v.push_back(firstName);
      v.push_back(nickName);
      v.push_back(lastName);
      v.push_back(getSex());
      v.push_back(getAlive());
      return v;
    }
  };

  std::string selectName(std::vector<std::string> possibleNames) {
    // srand(time(nullptr));
    std::string selectedName = possibleNames[random() % possibleNames.size()];
    return selectedName;
  }
}

#endif
