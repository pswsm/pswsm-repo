#pragma once

#include <string>
class Sequence {
  protected:
    std::string m_value {};

  public:
    Sequence() = default;
    Sequence(std::string value): m_value{value} {};
    
    const std::string& valueOf() const {
      return m_value;
    };
};
