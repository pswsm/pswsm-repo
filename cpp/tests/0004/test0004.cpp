#include "iostream"

class claseTest {
  private:
   int algo = 100;
    std::string altres = "lol, very funny";

  public:
    // Set
   void setAlgo(int n) {algo = n;}
   void setAltres(std::string s) {altres = s;}

   // Get
   int getAlgo() {return algo;}
   std::string getAltres() {return altres;}
};

int main() {
  claseTest prova;
  prova.getAlgo();
  prova.setAlgo(120000);
  prova.getAlgo();
  return 0;
}
