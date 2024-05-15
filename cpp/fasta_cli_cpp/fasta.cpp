#include "fasta.hpp"
#include <exception>
#include <iostream>
#include <fstream>
#include <deque>

namespace BioCpp  {
  Fasta from_file(std::string iFilename, std::string oFilename) {
    std::ifstream fasta_file(iFilename);
    std::ofstream dest_file(oFilename);
    if (!fasta_file.is_open()) {
      throw new std::exception;
    }
    std::string line;
    while (fasta_file >> line) {
      
    }
    fasta_file.close(); dest_file.close();
  }
}
