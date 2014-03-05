#include<iostream>
#include<cstdio>
#include<vector>
#include<cassert>
#include<string>
#include<cstdlib>
#include "filter.h"
using namespace std;

// Action: 5
// Constructible: 104
// Length: 0
// Points: AC_
// Centers: __
// Radii: 0 0

typedef struct action {
  int value;
  int constructible;
  double length;
  char points[3];
  char centers[2];
  double radii[2];
  
  action (void){
    value = 0;
    constructible = 0;
    length = 0.0;
    points[0] = points[1] = points[2] = '_';
    centers[0] = centers[1] = '_';
    radii[0] = radii[1] = 0;
  }

  void init (void){
    value = 0;
    constructible = 0;
    length = 0.0;
    points[0] = points[1] = points[2] = '\0';
    centers[0] = centers[1] = '\0';
    radii[0] = radii[1] = 0;
  }

  void setAction(int a) {
    value = a;
  }

  void setConstructible(int a) {
    constructible = a;
  }

  void setLength(double l) {
    length = l;
  }
  
  void setPoint1(char a) {
    points[0] = a;
  }

  void setPoint2(char a) {
    points[1] = a;
  }

  void setPoint3(char a) {
    points[2] = a;
  }
  
  void setCenter1(char a) {
    centers[0] = a;
  }

  void setCenter2(char a) {
    centers[1] = a;
  }

  void setRadii1(double a) {
    radii[0] = a;
  }

  void setRadii2(double a) {
    radii[0] = a;
  }

  void print(void) {
    cout<<endl;
    cout<<"Action: "<<value<<endl;
    cout<<"Constructible: "<<constructible<<endl;
    cout<<"Length: "<<length<<endl;
    cout<<"Points: "<<points[0]<<points[1]<<points[2]<<endl;
    cout<<"Centres: "<<centers[0]<<centers[1]<<endl;
    cout<<"Radii: "<<radii[0]<<" "<<radii[1]<<endl;
    cout<<endl;
  }
} action;

action A;
vector<string> sentence;

int searchCommand() {
  int l = sentence.size();
  for(int i=0;i<l;i++) {
    if(sentence[i] == "construct" or sentence[i] == "cut" or sentence[i] == 
"mark" or sentence[i] == "label" or sentence[i] == "join") {
      return i;
    }
  }
  return -1;
}

int searchConstructible(int index) {
  int i=index-1, j=index+1;
  while(i>=0 or j<sentence.size()) {
    if(i>=0) {
      if(sentence[i] == "line") {
	return i;
      }
      if(sentence[i] == "arc") {  
	//search for intersecting also here
	return i;
      }
      if(sentence[i] == "circle") {
	return i;
      }
      if(sentence[i] == "angle") {
	return i;
      }
    }
    if(j<sentence.size()) {
      if(sentence[j] == "line") {
	return j;
      }
      if(sentence[j] == "arc") {
	//search for intersecting also here
	return j;
      }
      if(sentence[j] == "circle") {
	return j;
      }
      if(sentence[j] == "angle") {
	return j;
      }
    }
    j++;
    i--;
  }
  return -1;
}

void searchAddressLineSegment(int index) {
  // sentence[index] == "line"
  // sentence[index+1] == "segment"
  int i=index-1, j=index+1;
  while(i>=0 or j<sentence.size()) {
    if(i>=0) {
      if(isPointDouble(sentence[i])) {
	A.setPoint1(sentence[i][0]);
	A.setPoint2(sentence[i][1]);
	return;
      }
    }
    if(j<sentence.size()) {
      if(isPointDouble(sentence[j])) {
	A.setPoint1(sentence[j][0]);
	A.setPoint2(sentence[j][1]);
	return;
      }
    }
    i--;
    j++;
    // add stuff for previous objects and free objects
  }
}

void searchLineSegmentProperties(int index) {
  // only one level of depth implemented yet 
  // as compared to 3 levels in grammar
  // implement free variable, previous length
  // and dependency on other line segment
  // only real cm implement yet
  int i=index-1, j=index+1;
  while(i>=0 or j<sentence.size()) {
    if(i>=0) {
      if(isNumber(sentence[i]) and sentence[i+1] == "cm") {
	A.setLength(stod(sentence[i]));
	return;
      }
    }
    if(j<sentence.size()) {
      if(isNumber(sentence[j]) and sentence[j+1] == "cm") {
	A.setLength(stod(sentence[j]));
	return;
      }
    }
    i--;
    j++;
    // add stuff for previous objects and free objects
  }
}

void searchConstructibleAndProperties(int index) {
  int index1 = searchConstructible(index);
  assert(index1 != -1);
  // assumption: word linesegment, arc circle angle would occur
  // "Construct AB of length 5 cm" is not valid
  if(sentence[index1] == "line" and sentence[index1+1] == "segment") {
    A.setConstructible(101);
    searchAddressLineSegment(index1);
    searchLineSegmentProperties(index1);
  }
  else if(sentence[index1] == "line") {  // FIXME
    A.setConstructible(-1);
    // do something
  }
  else if(sentence[index1] == "arc") {
    A.setConstructible(103);
    // do something
  }
  else if(sentence[index1] == "intersecting") {  // FIXME
    // Check how they occur
    // Currently assuming index of word "intersecting"
    // or maybe "intersect" is returned
    // Currently only arcs implemented
    // Would implement this later
    A.setConstructible(102);
    // do something
  }
  else if(sentence[index1] == "circle") {  // FIXME
    A.setConstructible(-1);
    // do something
  }
  else if(sentence[index1] == "angle") {   // FIXME
    A.setConstructible(-1);
    // do something
  }
}

void parse() {
  int index = searchCommand();
  assert(index != -1);
  if(sentence[index] == "construct") {
    A.setAction(1);
    searchConstructibleAndProperties(index);
  }
  else if(sentence[index] == "cut") {
    A.setAction(2);
    // do something
  }
  else if(sentence[index] == "mark") {
    A.setAction(3);
    // do something
  }
  else if(sentence[index] == "label") {
    A.setAction(4);
    // do something
  }
  else if(sentence[index] == "join") {
    A.setAction(5);
    // do something
  }
  return;
}

void init() {
  A.init();
  sentence.clear();
}

int main() {
  init();
  sentence.push_back("construct");
  sentence.push_back("line");
  sentence.push_back("segment"); 
  sentence.push_back("AB");
  sentence.push_back("measure");
  sentence.push_back("length");
  sentence.push_back("7.8");
  sentence.push_back("cm");

  parse();
  A.print();
}
