#pragma once

#include <iostream>
#include <string>

#include "User.h"

class User;

class Painting {
	public:
		Painting(std::string, User*, std::string, std::string, double);
		~Painting();
		User* getOwner();				//todo
		std::string getTitle();
		std::string getIntrodusion();	//todo
		double getPrice();
		void setInfo();					//todo
	private:
		std::string ID;
		User* ower;
		std::string title;
		std::string introdusion;
		double price;
};
