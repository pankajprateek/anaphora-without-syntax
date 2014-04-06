#include<iostream>
#include<vector>
#include<string>
#include "interpreter.h"
#include "mapper.h"
#include "action.h"
#define MAX_TRANSLATIONS 10

string getInterpretation(string parse){
  if(DEBUG) cout<<"Interpreting \""<<parse<<"\"..."<<endl;
  vector<pair<string, double> > mappings = getPossibleMappings(parse);
	/*
  cout<<"Listing mappings..."<<endl;
  for(int i=0; i<(int)mappings.size(); i++){
    cout<<mappings[i].first<<"\t ->"<<mappings[i].second<<endl;
  }
  */
  Action *action = new Action();
  if(DEBUG) cout<<"No. of possibilities " <<mappings.size()<<endl;

  int numTranslations = mappings.size() < MAX_TRANSLATIONS ? mappings.size() : MAX_TRANSLATIONS;
  for(int i=0; i < numTranslations ; ++i){
    
    ParseTree parseTree(mappings[i].first);
    if(DEBUG) cout<<"Parsing \""<<mappings[i].first<<"\""<<endl;
    parseTree.parse();
    
    if(parseTree.isEmpty()){
      if(DEBUG) cout<<"Could not parse "<<i+1<<"th possibility \""
        <<mappings[i].first<<"\""<<endl;
      continue;
    }
    
    if(DEBUG) cout<<"Found a parse tree:"<<endl;
    parseTree.print();
    if(DEBUG) cout<<"HERE"<<endl;
    
    return action->toString();
    
    action->extractAction(parseTree);
    while(!action->isValid()){
      parseTree.correctParseTree();
      if(parseTree.isEmpty()){//we tried all possible parses
        break;
      }
      action->extractAction(parseTree);
    }
    
    if(action->isValid()){
      continue;
    }
    
    return action->toString();
  }
  return action->toString();
}
