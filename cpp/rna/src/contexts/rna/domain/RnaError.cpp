#include <exception>
#include <string>
class RnaError : public std::exception {
  private:
    std::string m_reason {};

  public:
    RnaError(std::string reason): m_reason(reason) {};
};
