#pragma once
#include <iostream>
#include <vector>

namespace BioCpp {
  class Fasta {
    private:
    std::vector<char> chain;
    std::string header;
    public:
    Fasta(std::vector<char> chain, std::string header): chain{chain}, header{header} {};
    std::string getChain() {
      return std::string(chain.begin(), chain.end());
    }
    std::string getHeader() {
      return header;
    }
    std::string pprint() {
      return getHeader() + '\n' + getChain();
    }
  };

  Fasta from_file(std::string);
}
