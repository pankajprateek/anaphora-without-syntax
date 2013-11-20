#include "action.h"
#include "interpreter.h"
#include <iostream>
#include <fstream>
using namespace std;

Action::Action(){
  this->action
    = this->constructible
    = 0;
  this->length = 0.0;
  this->point1 = this->point2 = this->point3 = '_';
  this->center1 = this->center2 = '_';
  this->radius1 = this->radius2 = 0.0;
}

void Action::toString(){
  fstream g("drawing_instructions.txt", ios::out | ios::app);
  cout<<"Action: "<<this->action<<endl;
  cout<<"Constructible: "<<this->constructible<<endl;
  cout<<"Length: "<<this->length<<endl;
  cout<<"Points: "<<this->point1<<this->point2<<this->point3<<endl;
  cout<<"Centers: "<<this->center1<<this->center2<<endl;
  cout<<"Radii: "<<this->radius1<<" "<<this->radius2<<endl;

  g<<"Action: "<<this->action<<endl;
  g<<"Constructible: "<<this->constructible<<endl;
  g<<"Length: "<<this->length<<endl;
  g<<"Points: "<<this->point1<<this->point2<<this->point3<<endl;
  g<<"Centers: "<<this->center1<<this->center2<<endl;
  g<<"Radii: "<<this->radius1<<" "<<this->radius2<<endl;
  g.close();
}

bool Action::isValid(){
	switch(this->action){
		case(keywords::CONSTRUCT):
			switch(this->constructible){
				case(keywords::LINE_SEGMENT):
					if(this->length == 0.0
						|| !isValidPoint(this->point1)
						|| !isValidPoint(this->point2)){
							return false;
						}
					break;
				case(keywords::ARC):
					if(!isValidPoint(this->center1)
						||  this->radius1 == 0.0){
							return false;
						}
					break;
				case(keywords::INTERSECTING_ARCS):
					if(!isValidPoint(this->center1)
						|| !isValidPoint(this->center2)
						|| this->radius1 == 0.0
						|| this->radius2 == 0.0 ){
							return false;
					}
					break;
				default: return false; break;
			}
			break;
    case(keywords::JOIN):
      if(this->constructible!=keywords::JOINING_SEGMENT)
        return false;
      if(!isValidPoint(this->point1)
          || !isValidPoint(this->point2)){
            return false;
      }
      break;
		default: return false;
	}
	return true;
}
