#include "TradingManager.h"

#include <string>

#include "PaintingView.h"

void TradingManager::listPainting(Market* m, User* u) {
	std::string title;
	std::string introdusion;
	double price;
	std::cin >> title >> introdusion >> price;
	Painting painting("pID", u, title, introdusion, price);
	m->addPainting(painting, u);
}

void TradingManager::unlistPainting() {
	//todo
}

void TradingManager::updatePainting() {
	//todo
}

void TradingManager::buy() {
	//todo
}

void TradingManager::pay() {
	//todo
}
