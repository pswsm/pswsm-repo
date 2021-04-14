#include <iostream>
#include <cmath>
using namespace std;

class classeTest {
	// Tipus de classe
	public:
		// Atributs de la classe
		int num;
		string panita;
		double doubleNum;
};

int main() {
	classeTest objTest;

	objTest.num = 23;
	objTest.panita = "Miloko";
	objTest.doubleNum = 33.33;

	cout << "L'objecte:\n";
	cout << objTest.num << "\n" << objTest.doubleNum << "\n" << objTest.panita << "\n";
	
	return 0;
}
