#include <iostream>
#include <vector>

#include "Painting.h"

class Patining;

class Market {
	public:
		Market(std::vector<Painting>);
		~Market();
		std::vector<Painting> getPatintings();
		bool addPainting(Painting, User*);
		bool deletePainting();	//todo
		bool updatePainting();	//todo
	private:
		std::vector<Painting> patintings;
};
