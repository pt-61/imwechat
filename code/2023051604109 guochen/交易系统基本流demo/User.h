#pragma once

#include <iostream>
#include <string>
#include <vector>

#include "Painting.h"

class Painting;

class User {
	public:
		User(std::string, std::string, std::vector<Painting>);
		~User();
		std::string getName();
		bool addPainting(Painting);
		bool deletePainting();	//todo
		bool updatePainting(); 	//todo
	private:
		std::string ID;
		std::string name;
		std::vector<Painting> paintings; 
}; 
