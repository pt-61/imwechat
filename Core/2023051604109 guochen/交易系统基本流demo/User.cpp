#include "User.h"

User::User(std::string ID, std::string name, std::vector<Painting> paintings) {
	this->ID = ID;
	this->name = name;
	this->paintings = paintings;
}

User::~User() {}

std::string User::getName() {
	return this->name;
}

bool User::addPainting(Painting p) {
	this->paintings.push_back(p);
	return true;
}

bool User::deletePainting() {
	//todo
}

bool User::updatePainting() {
	//todo
}
