#include "Painting.h"

Painting::Painting(std::string ID, User* ower, std::string title, std::string introdusion, double price) {
	this->ID = ID;
	this->ower = ower;
	this->title = title;
	this->introdusion = introdusion;
	this->price = price;
}

Painting::~Painting() {}

User* Painting::getOwner() {
	//todo
}

std::string Painting::getTitle() {
	return this->title;
}

std::string Painting::getIntrodusion() {
	//todo
}

double Painting::getPrice() {
	return this->price;
}

void Painting::setInfo() {
	//todo
}
