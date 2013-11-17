#include<iostream>
#include "interpreter.h"
#include "mapper.h"

int main(){
	interpret();
	return 0;
}

void interpret(){
	vector<pair<string, double> > mappings = getPossibleMappings();
	
	for(int i=0; i<(int)mappings.size(); i++){
		cout<<mappings[i].first<<"\t ->"<<mappings[i].second<<endl;
	}
	
}
