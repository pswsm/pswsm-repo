#ifndef H_HUMANOID
#define H_HUMANOID

#include <string>
#include <vector>
#include <ctime>
#include <cstdlib>

class Humanoid {

  struct Leg {
    int max_hitpoints = 1000;
    int default_hitpoints = 1000;
    int cur_hitpoints = default_hitpoints;
    bool can_heal = (cur_hitpoints < (max_hitpoints-50)) ? true : false;
    int max_legs = 2;
    int default_legs = 2;
    int cur_legs = default_legs;
    
    void addLeg() {
    // This just adds one leg.
      if (cur_legs >= max_legs) {
        cur_legs = cur_legs + 1;
      }
    }
  };

  int natAge, bioAge;
  std::string firstName, lastName, nickName;
  bool state;

  public:
    Humanoid(int naturalAge, int biologicalAge, std::string fName, std::string lName, std::string niName, bool alive): natAge{naturalAge}, bioAge{biologicalAge},
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
      std::string fullName = firstName + " \"" + nickName + "\" " + lastName;
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
    // Humanoid *createInstance() {return new Humanoid {name};}
// }

#endif
