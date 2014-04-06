#include<iostream>
#include<vector>
#include<string>
#include "interpreter.h"
#include "grammar.h"

using namespace std;
grammar_t grammar;

int main(){
  grammar = GrammarReader::getGrammar();
  //GrammarReader::printGrammar(grammar);
  
  string cmd;
  while(getline(cin, cmd)) {
    cout<<cmd<<endl;
    string interpretation = getInterpretation(cmd);
    cout<<interpretation;
  }

  return 0;
}
