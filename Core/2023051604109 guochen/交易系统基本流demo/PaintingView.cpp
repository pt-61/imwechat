#include "PaintingView.h"

void PaintingView::showPaintingInfo() {
	//todo
}

std::string PaintingView::getTitle() {
	std::string title;
	std::cin >> title;
	return title;
}

std::string PaintingView::getIntrodusion() {
	std::string introdusion;
	std::cin >> introdusion;
	return introdusion;
}

double PaintingView::getPrice() {
	double price;
	std::cin >> price;
	return price;
}
