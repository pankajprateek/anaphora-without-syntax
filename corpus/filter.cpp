#include<iostream>
#include<fstream>
#include<string>
#include<wchar.h>
using namespace std;

int main(int argv, char *argc[]) {
  if(argv < 1)
    return 0;
  string current = "\0", previous = "\0";
  ifstream f(argc[1]);
  if(!f)
    return 0;
  while(!f.eof()) {
    getline(f,current);
    if(current[0]=='#'){
      //do nothing
    } else if ((current == "\r" or current == "\n") and previous == current) {
      //do nothing
    } else {
      // cout<<current<<endl;
      int l=current.length();
      for(int i=0;i<l;i++) {
	if(current[i] == ',' or current[i] == '.') {
	  //do nothing
	} else if ((unsigned int)current[i-1] == 4294967246 and (unsigned int)current[i] == 4294967188) {
	  cout<<"triangle ";
	} else if ((unsigned int)current[i] == 4294967246) {
	  //do nothing
	} else if ((unsigned int)current[i-1] == 4294967234 and (unsigned int)current[i] == 4294967216) {
	  cout<<" degrees";
	} else if ((unsigned int)current[i] == 4294967234) {
	  //do nothing
	} else if ((unsigned int)current[i-1] == 4294967266 and (unsigned int)current[i] == 4294967176) {
	  cout<<"angle";
	} else if ((unsigned int)current[i] == 4294967266) {
	  //do nothing
	} else {
	  cout<<current[i];
	}
      }
      cout<<endl;
      previous=current;
    }
  }
}
