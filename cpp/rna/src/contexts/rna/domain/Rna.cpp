#include "../../../contexts/_shared/domain/Sequence.h"
#include "./RnaError.cpp"
#include <algorithm>
#include <array>
#include <string>

class Rna : public Sequence {
  private:
    std::array<char, 4> m_allowed_chars {'a', 'u', 'c', 'g'};

  public:
    Rna(std::string value) {
      try {
        for (const char& l_base : value) {
          if (std::find(m_allowed_chars.begin(), m_allowed_chars.end(), l_base) == m_allowed_chars.end()) {
            throw RnaError("womp womp~~");
          };
        }
        m_value = value;
      } catch (RnaError error) {
        // TODO: something
        throw error;
      };
    };
};
