#include<iostream>
#include<cstdio>
#include<algorithm>
#include<string>
#define debug 0
using namespace std;

string toupper(string a) {
  for(int i=0;i<a.length();i++) {
    if(a[i] >= 97 and a[i] <= 122)
      a[i] = a[i] - 32;
  }
  return a;
}

bool isPointSingle(string str) {
  if(str.length() == 1 and str.compare(toupper(str))==0)
    return true;
  return false;
}

bool isPointDouble(string str) {
  if(str.length() == 2 and str.compare(toupper(str))==0)
    return true;
  return false;
}

bool isPointTriple(string str) {
  if(str.length() == 3 and str.compare(toupper(str))==0)
    return true;
  return false;
}

bool isNumber(string str) {
  for(int i=0;i<str.length();i++) {
    if(str[i]<48 or str[i]>57)
      return false;
  }
  return true;
}

// int main() {
//   string str = "a";
//   cout<<isNumber("9.1")<<endl;
// }
