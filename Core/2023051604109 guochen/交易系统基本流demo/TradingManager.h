#pragma once

#include <iostream>

#include "Market.h"
#include "User.h"

class Market;
class User;

class TradingManager {
	public:
		void listPainting(Market*, User*);
		void unlistPainting();	//todo
		void updatePainting();	//todo
		void buy();				//todo
		void pay();				//todo
};
