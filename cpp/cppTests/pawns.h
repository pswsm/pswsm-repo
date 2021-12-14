#ifndef H_PAWNS
#define H_PAWNS

#include <string>
#include <vector>
#include <ctime>
#include <cstdlib>

using namespace std;

class Pawn {
  int natAge, bioAge;
  string firstName, lastName, nickName;
  bool state;

  public:
    Pawn(int naturalAge, int biologicalAge, string fName, string lName, string niName, bool alive): natAge{naturalAge}, bioAge{biologicalAge},
      firstName{fName}, lastName{lName}, nickName{niName}, state{alive}
    {};

    vector<string> getEverything() {
      vector<string> v = {};
      v.push_back(to_string(natAge));
      v.push_back(to_string(bioAge));
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
};

// class Spawn {
  // std::vector<std::string> namePool = {"pau", "victor", "pablo", "oriol", "ivan", "toni", "gerard"};
  
  // std::string name() {
    // srand(time(nullptr));
    // std::string name = namePool;
  // }

  // public:
    // Pawn *createInstance() {return new Pawn {name};}
// }

#endif
