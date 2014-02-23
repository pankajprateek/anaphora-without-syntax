#include "grammar.h"
#include<stdio.h>
#include<string>
#include<iostream>
#include<fstream>
#include<assert.h>

#ifndef GRAMMAR_FILE_PATH
#define GRAMMAR_FILE_PATH "../corpus/language_grammar.grm"
#endif

using namespace std;

grammar_t GrammarReader::getGrammar(){
  ifstream grammarFile(GRAMMAR_FILE_PATH);
  string line;
  grammar_t grammar;
  
  if(!grammarFile.is_open() || grammarFile.eof()){
    throw string("Cannot open grammar file\n");
  }
  
  getline(grammarFile, line);//get the next non-terminal
  while(!grammarFile.eof()){
    //~ cout<<"NONTERMINAL LINE"<<line<<endl;
    assert(line.find("=") != string::npos);//commands =
    nonterminal_t nonTerminal = line.substr(0, line.find(" ")); //commands =
    productionrules_t productionRules;
    
    getline(grammarFile, line);//command
    while(!line.empty()){
      productionrule_t productionRule;
      int cursorIndex = line.find_first_not_of(" ");
      //~ cout<<"PRODUCTION RULE LINE"<<line<<endl;
      assert(cursorIndex != string::npos);
      if(!line.substr(cursorIndex, 1).compare("|")){
        //| commands command
        cursorIndex = line.find_first_not_of(" ", cursorIndex+1);
      }
      assert(cursorIndex != string::npos);
      while(cursorIndex != string::npos){
        //either a space or end of string
        int nextDelimiter = line.find_first_of(" ", cursorIndex);
        
        if(nextDelimiter==string::npos){
          nextDelimiter = line.length();
        }
        
        productionRule.push_back(
          line.substr(cursorIndex, nextDelimiter - cursorIndex)
        );
        
        cursorIndex = line.find_first_not_of(" ", nextDelimiter);
        
      }
      productionRules.push_back(productionRule);
      getline(grammarFile, line);
    }
    grammar[nonTerminal] = productionRules;
    while(!grammarFile.eof() && line.empty()){
      getline(grammarFile, line);//get the next non-terminal
    }
  }
  return grammar;
}

void GrammarReader::printGrammar(grammar_t grammar){
  for(grammar_t::iterator it = grammar.begin(); it != grammar.end(); ++it){
    cout<<(*it).first<<" ="<<endl;
    productionrules_t productionRules = (*it).second;
    for(productionrules_t::iterator it2 = productionRules.begin(); it2 != productionRules.end(); ++it2){
      productionrule_t productionRule = (*it2);
      for(productionrule_t::iterator it3 = productionRule.begin(); it3 != productionRule.end(); ++it3){
        cout<<(*it3)<<" ";
      }
      cout<<endl;
    }
    cout<<endl;
  }
}
