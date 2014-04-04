#include <iostream>
#include <stdlib.h>
#include "parse.h"
#include "grammar.h"
#include "lib.h"

using namespace std;
extern grammar_t grammar;

void ParseTree::correctParseTree(){
  return;
}
    
void ParseTree::parse(){
  if(root!=NULL) deleteSubtree(root);
  this->generateListOfWords();
  this->printListOfWords();
}

void ParseTree::printListOfWords(){
  cout<<"Printing List of words"<<endl;
  for(int i=0; i< (int)this->words.size(); i++){
    cout<<"\""<<this->words[i].content<<"\" leafIndex: "
      <<this->words[i].leafIndex<<endl;
  }  
}

void ParseTree::generateListOfWords(){
  vector<string> split_str = split(this->str);
  for(int i=0; i< (int)split_str.size(); i++){
    Word* word = new Word(split_str[i]);
    this->words.push_back(*word);
  }
}

void ParseTree::deleteSubtree(ParseTreeNode* node){
  if(node!=NULL) free(node);
}
