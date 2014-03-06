#include<iostream>
#include<cstdio>
#include<vector>
#include<cassert>
#include<string>
#include<cstdlib>
#include<fstream>
#include "filter.h"
#include "mapper.h"
using namespace std;

#define MaxUsed 50

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
    points[0] = points[1] = points[2] = '_';
    centers[0] = centers[1] = '_';
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
    radii[1] = a;
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
bool used[MaxUsed];

int searchPointPair(int index) {
  int i=index-1, j=index+1;
  while(i>=0 or j<sentence.size()) {
    if(i>=0) {
      if(isPointDouble(sentence[i]))
	return i;
    }
    if(j<sentence.size()) {
      if(isPointDouble(sentence[j]))
	return j;
    }
    i--;
    j++;
  }
  return -1;
}

int searchCommand() {
  int l = sentence.size();
  for(int i=0;i<l;i++) {
    if(sentence[i] == "construct" or sentence[i] == "draw" or sentence[i] == "cut" or sentence[i] == 
"mark" or sentence[i] == "label" or sentence[i] == "join") {
      return i;
    }
  }
  return -1;
}

int searchIntersecting(int index) {
  int i=index-1, j=index+1;
  while(i>=0 or j<sentence.size()) {
    if(i>=0) {
      if(sentence[i] == "intersecting" or sentence[i]=="intersect")
	return i;
    }
    if(j<sentence.size()) {
      if(sentence[j] == "intersecting" or sentence[j]=="intersect")
	return j;
    }
    i--;
    j++;
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
      if(sentence[i] == "lineSegment") {
	return i;
      }
      // if(sentence[i] == "arc") {  
      // 	//search for intersecting also here
      // 	return i;
      // }
      if(sentence[i] == "arc" or sentence[i] == "arcs") {
	int in1 = searchIntersecting(i);
	if(in1 != -1)
	  return in1;
	else
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
      if(sentence[j] == "lineSegment") {
	return j;
      }
      // if(sentence[j] == "arc") {
      // 	//search for intersecting also here
      // 	return j;
      // }
      if(sentence[j] == "arc" or sentence[j] == "arcs") {
	int in1 = searchIntersecting(j);
	if(in1 != -1)
	  return in1;
	else
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

int findIntersectionPoint(int index) {
  //index is for intersecting or intersect
  int i=index-1,j=index+1;
  while(i>=0 or j<sentence.size()) {
    if(i>=0) {
      if(isPointSingle(sentence[i])) {
	used[i] = true;
	return i;
      }
    }
    if(j<sentence.size()) {
      if(isPointSingle(sentence[j])) {
	used[j] = true;
	return j;
      }
    }
    i--;
    j++;
  }
  return -1;
}

int findCentre(int index) {
  // index is centres index for first time
  // index is for first point in second time
  int i=index-1,j=index+1;
  while(i>=0 or j<sentence.size()) {
    if(i>=0) {
      if(isPointSingle(sentence[i]) and !used[i]) {
	used[i] = true;
	return i;
      }
    }
    if(j<sentence.size()) {
      if(isPointSingle(sentence[j]) and !used[i]) {
	used[j] = true;
	return j;
      }
    }
    i--;
    j++;
  }
  return -1;  
}

int findRadius(int index) {
  // index is radius index for first time
  // index is for first point in second time
  int i=index-1,j=index+1;
  while(i>=0 or j<sentence.size()) {
    if(i>=0) {
      if(isNumber(sentence[i]) and !used[i]) {
	used[i] = true;
	return i;
      }
    }
    if(j<sentence.size()) {
      if(isNumber(sentence[j]) and !used[i]) {
	used[j] = true;
	return j;
      }
    }
    i--;
    j++;
  }
  return -1;  
}

int searchCentresKeyword(int index) {
  int i=index-1,j=index+1;
  while(i>=0 or j<sentence.size()) {
    if(i>=0) {
      if(sentence[i] == "centres" or sentence[i] == "centers" or sentence[i] == "centre" or sentence[i] == "center") {
	return i;
      }
    }
    if(j<sentence.size()) {
      if(sentence[j] == "centeres" or sentence[j] == "centers" or sentence[j] == "centere" or sentence[j] == "center") {
	return j;
      }
    }
    i--;
    j++;
  }
  return -1;  
}

int searchRadiusKeyword(int index) {
  int i=index-1,j=index+1;
  while(i>=0 or j<sentence.size()) {
    if(i>=0) {
      if(sentence[i] == "radii" or sentence[i] == "radius") {
	return i;
      }
    }
    if(j<sentence.size()) {
      if(sentence[j] == "radii" or sentence[j] == "radius") {
	return j;
      }
    }
    i--;
    j++;
  }
  return -1;  
}

void searchConstructibleAndProperties(int index) {
  int index1 = searchConstructible(index);
  assert(index1 != -1);
  // assumption: word linesegment, arc circle angle would occur
  // "Construct AB of length 5 cm" is not valid
  if((sentence[index1] == "line" and sentence[index1+1] == "segment") or (sentence[index1] == "lineSegment")) {
    A.setConstructible(101);
    searchAddressLineSegment(index1);
    searchLineSegmentProperties(index1);
  }
  else if(sentence[index1] == "line") {  // FIXME
    A.setConstructible(-1);
    // do something
  }
  else if(sentence[index1] == "arc" or sentence[index1] == "arcs") {
    A.setConstructible(103);
    // do something
  }
  else if(sentence[index1] == "intersecting" or sentence[index1] == "intersect") {  // FIXME
    // Check how they occur
    // Currently assuming index of word "intersecting"
    // or maybe "intersect" is returned
    // If arcs found, then search for intersecting
    // else if arc then not
    // may not be a good measure
    A.setConstructible(102);
    int index2 = findIntersectionPoint(index1);
    assert(index2 != -1);
    A.setPoint1(sentence[index2][0]);
    int index3 = searchCentresKeyword(index1);
    assert(index3 != -1);
    int index4 = findCentre(index3);
    assert(index4 != -1);
    int index5 = findCentre(index4);
    assert(index5 != -1);
    if(index4<index5) {
      A.setCenter1(sentence[index4][0]);
      A.setCenter2(sentence[index5][0]);
    } else {
      A.setCenter2(sentence[index4][0]);
      A.setCenter1(sentence[index5][0]);
    }
    int index6 = searchRadiusKeyword(index1);
    assert(index6 != -1);
    int index7 = findRadius(index6);
    assert(index7 != -1);
    int index8 = findRadius(index7);
    assert(index8 != -1);
    if(index7 < index8) {
      A.setRadii1(stod(sentence[index7]));
      A.setRadii2(stod(sentence[index8]));
    } else {
      A.setRadii2(stod(sentence[index7]));
      A.setRadii1(stod(sentence[index8]));
    }
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
  if(sentence[index] == "construct" or sentence[index] == "draw") {
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
    //sentence of the form join AB
    A.setAction(5);
    A.setConstructible(104);
    int index1 = searchPointPair(index);
    A.setPoint1(sentence[index1][0]);
    A.setPoint2(sentence[index1][1]);
    // do something
  }
  return;
}

void init() {
  A.init();
  sentence.clear();
  for(int i=0;i<MaxUsed;i++) {
    used[i] = false;
  }
}

int main() {
  // sentence 1
  // sentence.push_back("construct");
  // sentence.push_back("line");
  // sentence.push_back("segment"); 
  // sentence.push_back("AB");
  // sentence.push_back("measure");
  // sentence.push_back("length");
  // sentence.push_back("7.8");
  // sentence.push_back("cm");

  // sentence 2
  // sentence.push_back("center"); 
  // sentence.push_back("A");
  // sentence.push_back("and");
  // sentence.push_back("B");
  // sentence.push_back("as");
  // sentence.push_back("centers");
  // sentence.push_back("and");
  // sentence.push_back("radius");
  // sentence.push_back("4");
  // sentence.push_back("and");
  // sentence.push_back("5");
  // sentence.push_back("cm");
  // sentence.push_back("draw");
  // sentence.push_back("two");
  // sentence.push_back("arcs");
  // sentence.push_back("intersecting");
  // sentence.push_back("each");
  // sentence.push_back("other");
  // sentence.push_back("at");
  // sentence.push_back("C");

  // sentence 3
  // sentence.push_back("join");
  // sentence.push_back("AB");

  string str;
  fstream f("drawing_instructions.txt", ios::out | ios::app);
  while(getline(cin, str)) {
    init();
    cout<<str<<endl;

    vector<pair<string, double> > mappings = getPossibleMappings(str);
    cout<<"Listing mappings..."<<endl;	
    for(int i=0; i<(int)mappings.size(); i++){
      cout<<mappings[i].first<<"\t ->"<<mappings[i].second<<endl;
    }
    
    for(int i=0;i<int(mappings.size());i++) {
      vector<string> words = split(mappings[i].first);
      for(int j=0;j<int(words.size());j++) {
	sentence.push_back(words[j]);
      }
      parse();
      A.print();
      f<<"Action: "<<A.value<<endl;
      f<<"Constructible: "<<A.constructible<<endl;
      f<<"Length: "<<A.length<<endl;
      f<<"Points: "<<A.points[0]<<A.points[1]<<A.points[2]<<endl;
      f<<"Centres: "<<A.centers[0]<<A.centers[1]<<endl;
      f<<"Radii: "<<A.radii[0]<<" "<<A.radii[1]<<endl;
      f<<endl;
      break;
    }
  }
  f.close();
}
