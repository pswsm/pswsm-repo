#ifndef H_HUMAN
#define H_HUMAN

#include <string>
#include <vector>

namespace human {
  class Blood {
    /* Blood Type.
     * Has a genotype: for future reproduction simulation
     * Has a fenotype: for displaying the actual bloodtype */ 
    std::string genotype, fenotype;

    std::string deductBloodFenotype(std::string gen) {
      if ((gen == "aa") || (gen == "ao")) {
        return "A";
      } else if ((gen == "bb") || (gen == "bo")) {
        return "B";
      } else if (gen == "oo") {
        return "O";
      } else if (gen == "ab") {
        return "AB";
      } else {
        return "??";
      }
    }

    public:
    Blood();
    Blood(std::string gnt): genotype{gnt}
    { fenotype = deductBloodFenotype(genotype); };

    std::string getBlood() {
      return fenotype;
    }
  };

  class Human {
    int natAge, bioAge;
    std::string firstName, lastName, nickName, blood;
    bool isAlive;
    char sex;
    Blood bloodType {blood};

    public:
    Human(int naturalAge, int biologicalAge, std::string fName, std::string lName, std::string niName, std::string bt, bool alive, char sx): natAge{naturalAge}, bioAge{biologicalAge},
      firstName{fName}, lastName{lName}, nickName{niName}, blood{bt}, isAlive{alive}, sex{sx}
    {
      // bloodType {blood};
    };

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

    std::string getBloodType() {
      return bloodType.getBlood();
      // return blood;
    }

    std::vector<std::string> getEverything() {
      std::vector<std::string> v = {};
      v.push_back(firstName);
      v.push_back(nickName);
      v.push_back(lastName);
      v.push_back(std::to_string(natAge));
      v.push_back(std::to_string(bioAge));
      v.push_back(getSex());
      v.push_back(getBloodType());
      v.push_back(getAlive());
      return v;
    }
  };


  std::string selectName(std::vector<std::string> possibleNames) {
    std::string selectedName = possibleNames[random() % possibleNames.size()];
    return selectedName;
  }

  std::string selectBloodGenotype(std::vector<std::string> bts) {
    std::string selectedBloodGenotype = bts[random() % bts.size()];
    return selectedBloodGenotype;
  }
}

#endif
