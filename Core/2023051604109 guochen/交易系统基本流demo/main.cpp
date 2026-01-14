#include <iostream>
#include <string>
#include <vector>

#include "TradingManager.h"

void showView(User user, Market market);

int main() {
	//for test:
	TradingManager* t = new TradingManager();
	std::vector<Painting> paintings;
	User user1("uID", "Test_User001", paintings);
	User user0("uID", "Seller000", paintings);
	Painting painting0("pID", &user0, "My Test", "This is for test. ", 0);
	Market market(paintings);
	market.addPainting(painting0, &user0);
	
	int n;
	while(1) {
		showView(user1, market);
		std::cin >> n;
		if(n == 0 || n == -1) {
			switch(n) {
				case -1:
					exit(0);
					break;
				case 0:
					std::cout << "--------------------------------" << std::endl;
					std::cout << "Please Enter title, introdusion, price: " << std::endl;
					t->listPainting(&market, &user1);
					std::cout << "List painting successfully." << std::endl;
					std::cout << "--------------------------------" << std::endl;
					break;
			}
		}
	}
	return 0;
}

void showView(User user, Market market) {
	std::cout << "Welcome " << user.getName() << "!" << std::endl;
	std::cout << "--------------------------------" << std::endl;
	std::cout << "Painting list:" << std::endl;
	for(int i = 0; i < market.getPatintings().size(); i++) {
		Painting p = market.getPatintings().at(i);
		std::cout << i+1 << "." << p.getTitle() << "  $" << p.getPrice() << std::endl;
	}
	std::cout << std::endl << "0.list painting" << std::endl << "-1.exit" << std::endl;
	std::cout << "--------------------------------" << std::endl;
	std::cout << "Please Enter(only 0 or -1 is active now): ";
}
