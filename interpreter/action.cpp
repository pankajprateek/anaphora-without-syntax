#include "action.h"
#include <iostream>
using namespace std;

void Action::toString(){
	cout<<"Action: "<<this->action<<endl;
	cout<<"Constructible: "<<this->constructible<<endl;
	cout<<"Length "<<this->length<<endl;
	cout<<"Points "<<this->point1<<this->point2<<this->point3<<endl;
	cout<<"Centers "<<this->center1<<this->center2<<endl;
	cout<<"Radii "<<this->radius1<<this->radius2<<endl;
}

