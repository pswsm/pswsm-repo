#include "../../_shared/domain/Sequence.h"
#include "./DnaError.cpp"
#include <algorithm>
#include <array>
#include <string>

class Dna : public Sequence {
  private:
    const std::array<char, 4> m_allowed_chars {'a', 't', 'c', 'g'};

  public:
    Dna(std::string value) {
      try {
      for (const auto& l_base : value) {
        if (std::find(m_allowed_chars.begin(), m_allowed_chars.end(), l_base) == m_allowed_chars.end()) {
          throw DnaError("womp womp~");
        }
      }
      m_value = value;
      } catch (DnaError& error) {
        // TODO: do something here idk
        throw;
      }
  }
};
