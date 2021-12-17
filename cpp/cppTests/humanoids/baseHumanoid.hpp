#ifndef H_PAWNS
#define H_PAWNS

#include <string>
#include <vector>
#include <ctime>
#include <cstdlib>

class Pawn {
  int natAge, bioAge;
  std::string firstName, lastName, nickName;
  bool state;

  public:
    Pawn(int naturalAge, int biologicalAge, std::string fName, std::string lName, std::string niName, bool alive): natAge{naturalAge}, bioAge{biologicalAge},
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

// class Spawn {
  // std::std::vector<std::std::string> namePool = {"pau", "victor", "pablo", "oriol", "ivan", "toni", "gerard"};
  
  // std::std::string name() {
    // srand(time(nullptr));
    // std::std::string name = namePool;
  // }

  // public:
    // Pawn *createInstance() {return new Pawn {name};}
// }

#endif
