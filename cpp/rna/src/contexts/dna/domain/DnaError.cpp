#include <exception>
#include <string>
class DnaError : public std::exception {
  private:
    std::string m_reason;

  public:
    DnaError(std::string reason): m_reason(reason) {};

    std::string valueOf() {
      return m_reason;
    }
};

