#include "Market.h"

#include "User.h"

Market::Market(std::vector<Painting> paintings) {
	this->patintings = paintings;
}

Market::~Market() {}

std::vector<Painting> Market::getPatintings() {
	return this->patintings;
}

bool Market::addPainting(Painting p, User* u) {
	if(u->addPainting(p)) {
		this->patintings.push_back(p);
		return true;
	}
	return false;
}

bool Market::deletePainting() {
	//todo
}

bool Market::updatePainting() {
	//todo
}
